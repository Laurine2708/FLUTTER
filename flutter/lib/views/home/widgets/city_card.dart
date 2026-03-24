import 'package:flutter/material.dart';

import '../../../models/city_model.dart';

/// Widget représentant une carte affichant une ville.
///
/// Cette carte affiche :
/// - l'image de la ville
/// - le nom de la ville
///
/// Lorsque l'utilisateur clique sur la carte,
/// il est redirigé vers la page d'organisation du voyage
/// correspondant à cette ville.
class CityCard extends StatelessWidget {
  /// Objet représentant la ville à afficher.
  final City city;

  /// Constructeur du widget [CityCard].
  ///
  /// [city] contient les informations de la ville :
  /// - nom
  /// - image
  const CityCard({super.key, required this.city});

  /// Construit l’interface utilisateur de la carte de ville.
  ///
  /// La carte contient :
  /// - une image de fond de la ville
  /// - un texte avec le nom de la ville
  /// - une animation Hero lors de la navigation
  @override
  Widget build(BuildContext context) {
    return Card(
      /// Ombre de la carte.
      elevation: 5,
      child: SizedBox(
        height: 150,

        /// Stack permet de superposer plusieurs widgets :
        /// - l'image
        /// - le nom de la ville
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            /// Détecte le clic sur la carte.
            GestureDetector(
              child: Hero(
                /// Animation entre la liste des villes
                /// et la page de la ville.
                tag: city.name,

                /// Image de la ville.
                child: Image.network(city.image, fit: BoxFit.cover),
              ),

              /// Navigation vers la page de la ville.
              onTap: () {
                Navigator.pushNamed(context, '/city', arguments: city.name);
              },
            ),

            /// Positionnement du nom de la ville
            /// en haut à gauche de l'image.
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                /// Padding interne du texte.
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                /// Fond semi-transparent.
                color: Colors.black54,
                child: Text(
                  city.name,

                  /// Style du texte.
                  style: const TextStyle(fontSize: 35, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
