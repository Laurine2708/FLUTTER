import 'activity_model.dart';

/// Modèle représentant une ville dans l’application.
///
/// Une ville contient :
/// - un identifiant unique
/// - une image représentative
/// - un nom
/// - une liste d’activités associées.
///
/// Cette classe est utilisée pour regrouper les activités
/// disponibles dans une même ville et faciliter leur affichage
/// dans l’application.
class City {
  /// Identifiant unique de la ville.
  ///
  /// Peut être null si la ville n’est pas encore enregistrée
  /// dans une base de données.
  String? id;

  /// Chemin vers l’image représentant la ville.
  String image;

  /// Nom de la ville.
  String name;

  /// Liste des activités disponibles dans cette ville.
  List<Activity> activities;

  /// Constructeur principal permettant de créer une instance de [City].
  ///
  /// [id] Identifiant optionnel de la ville.
  /// [image] Image représentative de la ville.
  /// [name] Nom de la ville.
  /// [activities] Liste des activités associées à la ville.
  City({
    this.id,
    required this.image,
    required this.name,
    required this.activities,
  });

  /// Construit une instance de [City] à partir d’un objet JSON.
  ///
  /// Cette méthode est utilisée pour transformer les données
  /// reçues depuis une API ou une base de données en objet Dart.
  ///
  /// [json] Map contenant les informations de la ville ainsi
  /// que la liste des activités associées.
  ///
  /// Chaque élément de la liste `activities` est converti
  /// en objet [Activity] grâce à la méthode `Activity.fromJson`.
  City.fromJson(Map<String, dynamic> json)
    : id = json['_id'],
      image = json['image'],
      name = json['name'],
      activities = (json['activities'] as List)
          .map((activityJson) => Activity.fromJson(activityJson))
          .toList();
}
