import 'package:flutter/material.dart';

/// Page affichée lorsqu'une route ou une page n'est pas trouvée.
///
/// Cette vue sert de fallback dans l'application.
/// Elle est généralement utilisée lorsque :
/// - une route n'existe pas
/// - une erreur de navigation se produit
class NotFound extends StatelessWidget {
  /// Constructeur du widget NotFound.
  const NotFound({super.key});

  /// Construit l'interface utilisateur de la page.
  ///
  /// Cette page affiche simplement un message centré
  /// indiquant que la ressource demandée est introuvable.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Corps de la page.
      body: Container(
        /// Centre le contenu dans l'écran.
        alignment: Alignment.center,

        /// Centre le contenu dans l'écran.
        child: const Text('Oops not found !'),
      ),
    );
  }
}
