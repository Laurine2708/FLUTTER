import 'package:flutter/material.dart';

import '../../../models/city_model.dart';

/// Widget affichant une bannière (header) pour une ville
/// dans le contexte d’un voyage.
///
/// Cette barre contient :
/// - l’image de la ville en arrière-plan
/// - un overlay sombre
/// - un bouton retour
/// - le nom de la ville centré
class TripCityBar extends StatelessWidget {
  /// Ville à afficher dans la bannière.
  final City city;

  /// Constructeur du widget.
  const TripCityBar({super.key, required this.city});

  /// Construit l’interface utilisateur de la bannière.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      /// Hauteur fixe de la bannière.
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          /// Image de fond de la ville.
          Image.network(
            city.image,
            fit: BoxFit.cover,
          ), //Image.asset(city.image, fit: BoxFit.cover),
          /// Overlay sombre + contenu (texte + bouton).
          Container(
            color: Colors.black38,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Column(
              children: <Widget>[
                /// Ligne contenant le bouton retour.
                Row(
                  children: <Widget>[
                    IconButton(
                      /// Icône retour.
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),

                      /// Retour à l’écran précédent.
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                /// Zone centrale avec le nom de la ville.
                Expanded(
                  child: Center(
                    child: Text(
                      city.name,

                      /// Style du texte.
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
