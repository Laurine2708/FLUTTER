import 'package:flutter/material.dart';

/// Widget affichant un indicateur de chargement centré.
///
/// Utilisé pour signaler à l'utilisateur que des données
/// sont en cours de chargement (API, base de données, etc.).
class DymaLoader extends StatelessWidget {
  /// Constructeur du widget.
  const DymaLoader({super.key});

  /// Construction de l’interface utilisateur.
  @override
  Widget build(BuildContext context) {
    return Container(
      /// Centre le contenu dans l'écran.
      alignment: Alignment.center,

      /// Indicateur de chargement circulaire.
      child: const CircularProgressIndicator(),
    );
  }
}
