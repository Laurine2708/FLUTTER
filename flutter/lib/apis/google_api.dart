import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/activity_model.dart';
import '../models/place_model.dart';

/// Clé API utilisée pour accéder aux services de l’API Google Places.
const GOOGLE_KEY_API = 'AIzaSyBN7ZjdAqcrN1_I7toFcqgPWKaSzW4Ms20';

/// Construit l’URI permettant d’effectuer une requête d’autocomplétion
/// vers l’API Google Places.
///
/// Cette requête permet d’obtenir des suggestions de lieux
/// à partir d’une chaîne de caractères saisie par l’utilisateur.
///
/// [query] Texte saisi par l’utilisateur pour rechercher un lieu.
///
/// Retourne un objet [Uri] utilisé pour effectuer la requête HTTP.
Uri _queryAutocompleteBuilder(String query) {
  return Uri.parse(
    'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?&key=$GOOGLE_KEY_API&input=$query',
  );
}

/// Construit l’URI permettant de récupérer les détails d’un lieu
/// via l’API Google Places.
///
/// La requête retourne notamment l’adresse formatée ainsi que
/// les coordonnées géographiques associées au lieu.
///
/// [placeId] Identifiant unique du lieu fourni par l’API Google Places.
///
/// Retourne un objet [Uri] permettant d’effectuer la requête HTTP.
Uri _queryPlaceDetailsBuilder(String placeId) {
  return Uri.parse(
    "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&fields=formatted_address,geometry&key=$GOOGLE_KEY_API",
  );
}

/// Construit l’URI permettant de récupérer une adresse à partir
/// de coordonnées géographiques (latitude et longitude).
///
/// Cette requête utilise le service de géocodage inversé
/// de l’API Google Maps.
///
/// [lat] Latitude du point géographique.
/// [lng] Longitude du point géographique.
///
/// Retourne un objet [Uri] utilisé pour effectuer la requête HTTP.
Uri _queryGetAddressFromLatLngBuilder({
  required double lat,
  required double lng,
}) {
  return Uri.parse(
    "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_KEY_API",
  );
}

/// Récupère une liste de suggestions de lieux à partir
/// d’une chaîne de recherche.
///
/// Cette fonction interroge l’API **Google Places Autocomplete**
/// afin de proposer des lieux correspondant à la saisie de l’utilisateur.
///
/// [query] Texte utilisé pour rechercher des suggestions de lieux.
///
/// Retourne une liste de [Place] contenant la description
/// et l’identifiant du lieu proposé.
///
/// En cas d’erreur HTTP, une liste vide est retournée.
/// Les exceptions sont retransmises via `rethrow`.
Future<List<Place>> getAutocompleteSuggestions(String query) async {
  try {
    var response = await http.get(_queryAutocompleteBuilder(query));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return (body['predictions'] as List)
          .map(
            (suggestion) => Place(
              description: suggestion['description'] ?? '',
              placeId: suggestion['place_id'] ?? '',
            ),
          )
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    rethrow;
  }
}

/// Récupère les détails d’un lieu spécifique via l’API Google Places.
///
/// Cette fonction permet d’obtenir les informations détaillées
/// d’un lieu à partir de son identifiant, notamment :
///
/// - l’adresse formatée
/// - la latitude
/// - la longitude
///
/// [placeId] Identifiant unique du lieu fourni par Google Places.
///
/// Retourne un objet [LocationActivity] contenant
/// les informations de localisation du lieu.
///
/// Lance une exception si la requête HTTP échoue.
/// Les erreurs sont retransmises via `rethrow`.
Future<LocationActivity> getPlaceDetailsApi(String placeId) async {
  try {
    var response = await http.get(_queryPlaceDetailsBuilder(placeId));
    if (response.statusCode == 200) {
      var body = json.decode(response.body)['result'];
      return LocationActivity(
        address: body['formatted_address'],
        longitude: body['geometry']['location']['lng'],
        latitude: body['geometry']['location']['lat'],
      );
    } else {
      throw 'Erreur !';
    }
  } catch (e) {
    rethrow;
  }
}

/// Récupère l’adresse formatée correspondant à des coordonnées
/// géographiques données.
///
/// Cette fonction utilise le service de **géocodage inversé**
/// de l’API Google Maps pour transformer une latitude et une longitude
/// en adresse lisible.
///
/// [lat] Latitude du point géographique.
/// [lng] Longitude du point géographique.
///
/// Retourne une chaîne de caractères contenant l’adresse formatée.
///
/// Lance une exception si la requête HTTP échoue.
/// Les erreurs sont retransmises via `rethrow`.

Future<String> getAddressFromLatLng({
  required double lat,
  required double lng,
}) async {
  try {
    var response = await http.get(
      _queryGetAddressFromLatLngBuilder(lat: lat, lng: lng),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'][0]['formatted_address'];
    } else {
      throw 'Erreur !';
    }
  } catch (e) {
    rethrow;
  }
}
