/// Énumération représentant l’état d’une activité.
///
/// - [ongoing] : activité en cours ou planifiée.
/// - [done] : activité terminée.
enum ActivityStatus { ongoing, done }

/// Modèle représentant une activité réalisée ou planifiée
/// dans le cadre d’un voyage.
///
/// Une activité contient différentes informations telles que :
/// - son nom
/// - la ville dans laquelle elle se déroule
/// - une image associée
/// - un prix éventuel
/// - son statut (en cours ou terminée)
/// - sa localisation éventuelle.
///
/// Cette classe est également responsable de la
/// **sérialisation et désérialisation JSON** afin de
/// faciliter les échanges avec une API ou une base de données.

class Activity {
  // Nom de l’activité.
  String name;

  /// Chemin vers l’image représentant l’activité.
  String image;

  /// Identifiant unique de l’activité.
  ///
  /// Peut être null si l’activité n’est pas encore enregistrée
  /// dans une base de données.
  String? id;

  /// Ville dans laquelle se déroule l’activité.
  String city;

  /// Prix de l’activité.
  double price;

  /// Statut actuel de l’activité.
  ActivityStatus status;

  /// Informations de localisation associées à l’activité.
  LocationActivity? location;

  /// Constructeur principal permettant de créer une activité.
  ///
  /// [name] Nom de l’activité.
  /// [city] Ville où se déroule l’activité.
  /// [image] Image associée à l’activité.
  /// [price] Prix de l’activité.
  /// [id] Identifiant optionnel de l’activité.
  /// [location] Localisation de l’activité.
  /// [status] Statut de l’activité (par défaut : [ActivityStatus.ongoing]).
  Activity({
    required this.name,
    required this.city,
    this.id,
    required this.image,
    required this.price,
    this.location,
    this.status = ActivityStatus.ongoing,
  });

  /// Construit une instance de [Activity] à partir
  /// d’un objet JSON.
  ///
  /// Cette méthode est utilisée lors de la récupération
  /// de données provenant d’une API ou d’une base de données.
  ///
  /// [json] Map contenant les données de l’activité.
  Activity.fromJson(Map<String, dynamic> json)
    : id = json['_id']?.toString(),
      name = json['name']?.toString() ?? '',
      image = json['image']?.toString() ?? '',
      city = json['city']?.toString() ?? '',
      price = (json['price'] as num?)?.toDouble() ?? 0.0,
      location = LocationActivity(
        address: json['address']?.toString() ?? '',
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      ),
      status = json['status'] == 1
          ? ActivityStatus.done
          : ActivityStatus.ongoing;

  /// Convertit l’objet [Activity] en format JSON.
  ///
  /// Cette méthode est utilisée pour envoyer les données
  /// d’une activité vers une API ou pour les stocker
  /// dans une base de données.
  ///
  /// Retourne une [Map<String, dynamic>] représentant
  /// l’activité sous forme sérialisée (Objet -> JSON).
  Map<String, dynamic> toJson() {
    Map<String, dynamic> value = {
      'name': name,
      'image': image,
      'city': city,
      'price': price,
      'address': location?.address,
      'longitude': location?.longitude,
      'latitude': location?.latitude,
      'status': status == ActivityStatus.ongoing ? 0 : 1,
    };
    if (id != null) {
      value['_id'] = id;
    }
    return value;
  }
}

/// Classe représentant la localisation d’une activité.
///
/// Cette classe regroupe les informations géographiques
/// associées à une activité, notamment :
/// - l’adresse
/// - la latitude
/// - la longitude.
class LocationActivity {
  /// Adresse formatée du lieu de l’activité.
  String? address;

  /// Longitude du lieu.
  double? longitude;

  /// Latitude du lieu.
  double? latitude;

  /// Constructeur permettant de créer une localisation d’activité.
  ///
  /// [address] Adresse du lieu.
  /// [longitude] Longitude du lieu.
  /// [latitude] Latitude du lieu.
  LocationActivity({this.address, this.longitude, this.latitude});
}
