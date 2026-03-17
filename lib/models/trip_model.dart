import 'activity_model.dart';

/// Modèle représentant un voyage dans l’application.
///
/// Un voyage correspond à un séjour dans une ville donnée
/// et peut contenir plusieurs activités planifiées par l’utilisateur.
///
/// Cette classe permet également la **sérialisation et la désérialisation**
/// des données afin de faciliter les échanges avec une API ou une base
/// de données.
class Trip {
  /// Identifiant unique du voyage.
  ///
  /// Peut être null si le voyage n’est pas encore enregistré
  /// dans une base de données.
  String? id;

  /// Ville associée au voyage.
  ///
  /// Cette propriété indique la destination principale du voyage.
  String city;

  /// Liste des activités prévues ou réalisées durant le voyage.
  ///
  /// Chaque élément de cette liste est représenté par un objet [Activity].
  List<Activity> activities;

  /// Date associée au voyage.
  ///
  /// Elle peut représenter la date de départ ou la date planifiée
  /// pour ce voyage.
  DateTime? date;

  /// Constructeur principal permettant de créer une instance de [Trip].
  ///
  /// [city] Ville du voyage.
  /// [activities] Liste des activités associées au voyage.
  /// [date] Date du voyage.
  /// [id] Identifiant optionnel du voyage.
  Trip({required this.city, required this.activities, this.date, this.id});

  /// Construit une instance de [Trip] à partir d’un objet JSON.
  ///
  /// Cette méthode est utilisée lorsque les données sont récupérées
  /// depuis une API ou une base de données.
  ///
  /// [json] Map contenant les informations du voyage.
  ///
  /// La liste des activités est convertie en objets [Activity]
  /// grâce à la méthode `Activity.fromJson`.
  Trip.fromJson(Map<String, dynamic> json)
    : id = json['_id']?.toString(),
      city = json['city']?.toString() ?? '',
      date = json['date'] != null ? DateTime.parse(json['date']) : null,
      activities = (json['activities'] as List? ?? [])
          .map(
            (activityJson) =>
                Activity.fromJson(activityJson as Map<String, dynamic>),
          )
          .toList();

  /// Convertit l’objet [Trip] en format JSON.
  ///
  /// Cette méthode est utilisée pour envoyer les données du voyage
  /// vers une API ou pour les stocker dans une base de données.
  ///
  /// Si l’identifiant [id] est présent, il est inclus dans la
  /// structure JSON retournée.
  ///
  /// Retourne une [Map<String, dynamic>] représentant
  /// le voyage sous forme sérialisée.
  Map<String, dynamic> toJson() {
    if (id != null) {
      return {
        '_id': id,
        'city': city,
        'date': date?.toIso8601String(),
        'activities': activities.map((activity) => activity.toJson()).toList(),
      };
    } else {
      return {
        'city': city,
        'date': date?.toIso8601String(),
        'activities': activities.map((activity) => activity.toJson()).toList(),
      };
    }
  }
}
