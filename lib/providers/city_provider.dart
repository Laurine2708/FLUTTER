import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
//import '../datas/data.dart' as data;
import '../models/activity_model.dart';
import '../models/city_model.dart';
import 'package:path/path.dart';
import 'dart:io';

/// Provider responsable de la gestion des villes et de leurs activités.
///
/// Cette classe utilise le système de gestion d’état de Flutter basé
/// sur [ChangeNotifier]. Elle permet :
///
/// - de récupérer les villes depuis une API
/// - d’ajouter des activités à une ville
/// - de vérifier l’unicité d’une activité
/// - d’envoyer des images d’activités vers le serveur
///
/// Lorsqu’une modification est effectuée, la méthode [notifyListeners]
/// est appelée afin de mettre à jour automatiquement l’interface utilisateur.
class CityProvider extends ChangeNotifier {
  /// Adresse de l’hôte du serveur backend.
  ///
  /// `10.0.2.2` est utilisé pour accéder au **localhost de la machine**
  /// depuis l’émulateur Android.
  //final String host = 'localhost';
  final String host = '10.0.2.2';

  /// Liste interne contenant les villes récupérées depuis l’API.
  List<City> _cities = [];

  /// Indique si les données sont en cours de chargement.
  bool isLoading = false;

  /// Retourne une vue non modifiable de la liste des villes.
  ///
  /// L’utilisation de [UnmodifiableListView] empêche la modification
  /// directe de la liste depuis l’extérieur du provider.
  UnmodifiableListView<City> get cities => UnmodifiableListView(_cities);

  /// Recherche et retourne une ville à partir de son nom.
  ///
  /// [cityName] Nom de la ville recherchée.
  ///
  /// Retourne l’objet [City] correspondant.
  City getCityByName(String cityName) =>
      cities.firstWhere((city) => city.name == cityName);

  /// Retourne une liste filtrée des villes selon un texte donné.
  ///
  /// [filter] Texte utilisé pour filtrer les villes.
  ///
  /// Seules les villes dont le nom commence par ce filtre
  /// (sans tenir compte de la casse) sont retournées.
  UnmodifiableListView<City> getFilteredCities(String filter) =>
      UnmodifiableListView(
        _cities
            .where(
              (city) =>
                  city.name.toLowerCase().startsWith(filter.toLowerCase()),
            )
            .toList(),
      );

  /// Récupère la liste des villes depuis l’API backend.
  ///
  /// Cette méthode effectue une requête HTTP GET vers
  /// l’endpoint `/api/cities`.
  ///
  /// Les données reçues sont converties en objets [City]
  /// puis stockées dans la liste `_cities`.
  ///
  /// Une fois les données chargées, [notifyListeners] est appelé
  /// afin de mettre à jour l’interface utilisateur.
  Future<void> fetchData() async {
    try {
      isLoading = true;
      http.Response response = await http.get(Uri.http(host, '/api/cities'));
      if (response.statusCode == 200) {
        _cities = (json.decode(response.body) as List)
            .map((cityJson) => City.fromJson(cityJson))
            .toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  /// Ajoute une nouvelle activité à une ville existante.
  ///
  /// [newActivity] Activité à ajouter.
  ///
  /// Cette méthode :
  /// 1. récupère l’identifiant de la ville correspondante
  /// 2. envoie une requête POST à l’API
  /// 3. met à jour la ville concernée avec les nouvelles données
  /// 4. notifie les widgets écoutant ce provider.
  Future<void> addActivityToCity(Activity newActivity) async {
    try {
      String cityId = getCityByName(newActivity.city).id!;
      http.Response response = await http.post(
        Uri.http(host, '/api/city/$cityId/activity'),
        headers: {'Content-type': 'application/json'},
        body: json.encode(newActivity.toJson()),
      );
      if (response.statusCode == 200) {
        int index = _cities.indexWhere((city) => city.id == cityId);
        _cities[index] = City.fromJson(json.decode(response.body));
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Vérifie si le nom d’une activité est unique dans une ville donnée.
  ///
  /// [cityName] Nom de la ville concernée.
  /// [activityName] Nom de l’activité à vérifier.
  ///
  /// Une requête est envoyée au backend afin de vérifier
  /// si une activité portant ce nom existe déjà.
  ///
  /// Retourne :
  /// - `null` si le nom est unique
  /// - une réponse JSON contenant l’erreur sinon.
  Future<dynamic> verifyIfActivityNameIsUnique(
    String cityName,
    String activityName,
  ) async {
    try {
      City city = getCityByName(cityName);
      http.Response response = await http.get(
        Uri.http(host, '/api/city/${city.id}/activities/verify/$activityName'),
      );
      if (response.statusCode != 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Envoie une image d’activité vers le serveur backend.
  ///
  /// [pickedImage] Fichier image sélectionné par l’utilisateur.
  ///
  /// Cette méthode utilise une requête HTTP multipart afin
  /// de transmettre le fichier au serveur.
  ///
  /// Retourne le chemin ou l’identifiant de l’image enregistré
  /// sur le serveur.
  Future<String> uploadImage(File pickedImage) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.http(host, '/api/activity/image'),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'activity',
          pickedImage.readAsBytesSync(),
          filename: basename(pickedImage.path),
          contentType: MediaType("multipart", "form-data"),
        ),
      );
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return json.decode(responseData);
      } else {
        throw 'error';
      }
    } catch (e) {
      rethrow;
    }
  }
}
