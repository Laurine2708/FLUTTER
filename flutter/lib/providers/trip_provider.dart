import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
//import '../datas/data.dart' as data;
import '../models/activity_model.dart';
import '../models/trip_model.dart';

/// Provider responsable de la gestion des voyages dans l’application.
///
/// Cette classe utilise le mécanisme [ChangeNotifier] afin de gérer
/// l’état des voyages et notifier l’interface utilisateur lorsqu’une
/// modification est effectuée.
///
/// Elle permet notamment :
/// - de récupérer les voyages depuis une API
/// - d’ajouter un nouveau voyage
/// - de mettre à jour le statut d’une activité dans un voyage
/// - d’accéder aux voyages et aux activités associées.
///
/// Ce provider sert d’intermédiaire entre l’interface Flutter
/// et le backend.
class TripProvider extends ChangeNotifier {
  /// Adresse de l’hôte du serveur backend.
  ///
  /// `10.0.2.2` permet à l’émulateur Android d’accéder
  /// au localhost de la machine de développement.
  //final String host = 'localhost';
  final String host = '10.0.2.2';

  /// Liste interne contenant les voyages récupérés depuis l’API.
  List<Trip> _trips = [];

  /// Indique si les données sont en cours de chargement.
  bool isLoading = false;

  /// Retourne une vue non modifiable de la liste des voyages.
  ///
  /// L’utilisation de [UnmodifiableListView] empêche toute modification
  /// directe de la liste depuis l’extérieur du provider.
  UnmodifiableListView<Trip> get trips => UnmodifiableListView(_trips);

  /// Récupère la liste des voyages depuis l’API backend.
  ///
  /// Une requête HTTP GET est envoyée vers l’endpoint `/api/trips`.
  /// Les données reçues sont converties en objets [Trip]
  /// puis stockées dans la liste `_trips`.
  ///
  /// Une fois les données chargées, [notifyListeners] est appelé
  /// afin de mettre à jour l’interface utilisateur.
  Future<void> fetchData() async {
    try {
      isLoading = true;
      http.Response response = await http.get(Uri.http(host, '/api/trips'));
      if (response.statusCode == 200) {
        _trips = (json.decode(response.body) as List)
            .map((tripJson) => Trip.fromJson(tripJson))
            .toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  /// Ajoute un nouveau voyage.
  ///
  /// [trip] Objet [Trip] à enregistrer.
  ///
  /// Cette méthode envoie une requête HTTP POST vers l’API
  /// afin d’ajouter le voyage dans la base de données.
  /// Si la requête réussit, le voyage retourné par l’API
  /// est ajouté à la liste locale `_trips`.
  Future<void> addTrip(Trip trip) async {
    try {
      http.Response response = await http.post(
        Uri.http(host, '/api/trip'),
        body: json.encode(trip.toJson()),
        headers: {'Content-type': 'application/json'},
      );
      if (response.statusCode == 200) {
        _trips.add(Trip.fromJson(json.decode(response.body)));
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Met à jour le statut d’une activité dans un voyage.
  ///
  /// [trip] Voyage contenant l’activité à modifier.
  /// [activityId] Identifiant de l’activité concernée.
  ///
  /// Cette méthode :
  /// 1. recherche l’activité dans le voyage
  /// 2. change son statut en [ActivityStatus.done]
  /// 3. envoie les modifications à l’API via une requête PUT
  ///
  /// Si la requête échoue, le statut de l’activité est rétabli
  /// à [ActivityStatus.ongoing].
  Future<void> updateTrip(Trip trip, String? activityId) async {
    try {
      if (activityId == null) {
        throw const HttpException('Activity id is missing');
      }

      Activity activity = trip.activities.firstWhere(
        (activity) => activity.id == activityId,
      );
      activity.status = ActivityStatus.done;
      http.Response response = await http.put(
        Uri.http(host, '/api/trip'),
        body: json.encode(trip.toJson()),
        headers: {'Content-type': 'application/json'},
      );
      if (response.statusCode != 200) {
        activity.status = ActivityStatus.ongoing;
        throw const HttpException('error');
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Recherche un voyage à partir de son identifiant.
  ///
  /// [id] Identifiant du voyage.
  ///
  /// Retourne l’objet [Trip] correspondant.
  Trip getById(String id) {
    return trips.firstWhere((trip) => trip.id == id);
  }

  /// Recherche une activité spécifique dans un voyage donné.
  ///
  /// [activityId] Identifiant de l’activité.
  /// [tripId] Identifiant du voyage contenant l’activité.
  ///
  /// Retourne l’objet [Activity] correspondant.
  Activity getActivityByIds({
    required String activityId,
    required String tripId,
  }) {
    return getById(
      tripId,
    ).activities.firstWhere((activity) => activity.id == activityId);
  }
}
