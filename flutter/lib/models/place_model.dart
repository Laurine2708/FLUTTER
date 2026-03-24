/// Modèle représentant un lieu suggéré par l’API Google Places.
///
/// Cette classe est utilisée pour stocker les informations minimales
/// retournées par le service d’autocomplétion des lieux.
/// Elle contient notamment :
/// - une description textuelle du lieu
/// - un identifiant unique permettant de récupérer plus de détails via l’API.
class Place {
  /// Description textuelle du lieu.
  ///
  /// Cette information correspond généralement au nom du lieu
  /// accompagné de son adresse ou de sa localisation.
  String description;

  /// Identifiant unique du lieu fourni par l’API Google Places.
  ///
  /// Cet identifiant est utilisé pour effectuer une requête
  /// supplémentaire afin de récupérer les détails complets
  /// du lieu (adresse, coordonnées géographiques, etc.).
  String placeId;

  /// Constructeur permettant de créer une instance de [Place].
  ///
  /// [description] Description du lieu retournée par l’API.
  /// [placeId] Identifiant unique du lieu.
  Place({required this.description, required this.placeId});
}
