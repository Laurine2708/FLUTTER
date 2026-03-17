import 'dart:async';

import 'package:flutter/material.dart';

import '../../../apis/google_api.dart';
import '../../../models/activity_model.dart';
import '../../../models/place_model.dart';

/// Affiche une boîte de dialogue permettant à l’utilisateur
/// de rechercher une adresse via un système d’autocomplétion.
///
/// Cette fonction ouvre un widget [InputAddress] sous forme
/// de dialogue et retourne la localisation sélectionnée
/// par l’utilisateur.
///
/// [context] Contexte de l’application Flutter.
///
/// Retourne un objet contenant les informations de localisation
/// sélectionnées ou `null` si l’utilisateur annule l’opération.
Future showInputAutocomplete(BuildContext context) {
  return showDialog(context: context, builder: (_) => const InputAddress());
}

/// Widget permettant de rechercher une adresse
/// à l’aide de l’API Google Places.
///
/// Ce widget affiche :
/// - un champ de recherche
/// - une liste de suggestions d’adresses
/// - la possibilité de sélectionner un lieu.
///
/// Lorsqu’un lieu est sélectionné, ses coordonnées géographiques
/// sont récupérées puis renvoyées au widget appelant.
class InputAddress extends StatefulWidget {
  /// Constructeur du widget [InputAddress].
  const InputAddress({super.key});

  @override
  State<InputAddress> createState() => _InputAddressState();
}

/// État interne du widget [InputAddress].
///
/// Cette classe gère :
/// - la recherche d’adresses
/// - l’appel à l’API d’autocomplétion
/// - la récupération des détails d’un lieu sélectionné
/// - la mise à jour de la liste des suggestions.
class _InputAddressState extends State<InputAddress> {
  /// Liste des lieux suggérés par l’API Google Places.
  List<Place> _places = [];

  /// Timer utilisé pour implémenter un système de **debounce**.
  ///
  /// Cela permet d’éviter d’effectuer une requête API
  /// à chaque frappe de l’utilisateur.
  Timer? _debounce;

  /// Recherche des suggestions d’adresses à partir du texte saisi.
  ///
  /// [value] Texte entré par l’utilisateur dans le champ de recherche.
  ///
  /// Cette méthode utilise un système de **debounce** afin de limiter
  /// le nombre de requêtes envoyées à l’API Google Places.
  /// La requête est exécutée uniquement si l’utilisateur
  /// arrête de taper pendant 1 seconde.
  Future<void> _searchAddress(String value) async {
    try {
      if (_debounce?.isActive == true) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 1), () async {
        if (value.isNotEmpty) {
          _places = await getAutocompleteSuggestions(value);
          setState(() {});
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Récupère les détails d’un lieu sélectionné.
  ///
  /// [placeId] Identifiant unique du lieu retourné
  /// par l’API Google Places.
  ///
  /// Cette méthode récupère les coordonnées géographiques
  /// et l’adresse associée au lieu sélectionné.
  ///
  /// Une fois les informations récupérées, la boîte de dialogue
  /// est fermée et les données sont retournées au widget appelant.
  Future<void> getPlaceDetails(String placeId) async {
    try {
      LocationActivity location = await getPlaceDetailsApi(placeId);
      if (mounted) {
        Navigator.pop(context, location);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Construit l’interface utilisateur du widget.
  ///
  /// L’interface comprend :
  /// - un champ de recherche pour saisir une adresse
  /// - un bouton pour fermer la recherche
  /// - une liste de suggestions retournées par l’API Google Places.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Rechercher',
                  prefixIcon: Icon(Icons.search),
                ),

                /// Déclenche la recherche d’adresses
                /// lorsque le texte change.
                onChanged: _searchAddress,
              ),
              Positioned(
                top: 5,
                right: 3,
                child: IconButton(
                  icon: const Icon(Icons.clear),

                  /// Ferme la boîte de dialogue sans retourner
                  /// de localisation.
                  onPressed: () => Navigator.pop(context, null),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _places.length,
              itemBuilder: (_, i) {
                var place = _places[i];
                return ListTile(
                  leading: const Icon(Icons.place),

                  /// Affiche la description du lieu suggéré.
                  title: Text(place.description),

                  /// Lorsque l’utilisateur sélectionne un lieu,
                  /// ses détails sont récupérés via l’API.
                  onTap: () => getPlaceDetails(place.placeId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
