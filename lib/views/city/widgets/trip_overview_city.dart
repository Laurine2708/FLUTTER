import 'package:flutter/material.dart';

/// Widget affichant un aperçu d’une ville dans un voyage.
///
/// Ce composant affiche :
/// - l’image de la ville en arrière-plan
/// - le nom de la ville au centre
///
/// Il utilise également une animation [Hero] afin de créer
/// une transition fluide entre deux écrans lorsque l’utilisateur
/// navigue vers les détails de la ville.
class TripOverviewCity extends StatelessWidget {
  /// Nom de la ville affichée.
  final String cityName;

  /// URL de l’image représentant la ville.
  final String cityImage;

  /// Constructeur du widget [TripOverviewCity].
  ///
  /// [cityName] Nom de la ville
  /// [cityImage] URL de l’image de la ville
  const TripOverviewCity({
    super.key,
    required this.cityName,
    required this.cityImage,
  });

  /// Construit l’interface utilisateur du composant.
  ///
  /// L’interface comprend :
  /// - une image de fond représentant la ville
  /// - un effet sombre pour améliorer la lisibilité du texte
  /// - le nom de la ville affiché au centre
  /// - une animation Hero pour la transition entre écrans.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      /// Hauteur fixe du composant.
      height: 100,

      // Centre les éléments dans le Stack.
      child: Stack(
        alignment: Alignment.center,

        /// Étend les éléments sur toute la surface.
        fit: StackFit.expand,
        children: <Widget>[
          /// Animation Hero permettant une transition
          /// visuelle fluide entre les écrans.
          Hero(
            tag: cityName,

            /// Image de la ville chargée depuis une URL.
            /// Ajuste l’image pour couvrir tout l’espace.
            child: Image.network(cityImage, fit: BoxFit.cover),
          ),

          /// Couche sombre semi-transparente
          /// permettant d’améliorer la lisibilité du texte.
          Container(
            color: Colors.black45,
            child: Center(
              /// Affichage du nom de la ville.
              child: Text(
                cityName,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
