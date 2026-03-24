import 'package:flutter/material.dart';

import '../views/home/home_view.dart';
import '../views/trips/trips_view.dart';

/// Widget représentant le menu latéral (Drawer) de l'application.
///
/// Il permet de naviguer entre :
/// - la page d'accueil
/// - la page des voyages
class DymaDrawer extends StatelessWidget {
  /// Constructeur du widget.
  const DymaDrawer({super.key});

  /// Construction de l’interface utilisateur du Drawer.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      /// Liste des éléments du menu.
      child: ListView(
        children: <Widget>[
          /// En-tête du Drawer avec un dégradé.
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                /// Couleurs du dégradé (couleur principale → transparente)
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

            /// Titre de l'application.
            child: const Text(
              'DymaTrip',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),

          /// Lien vers la page d'accueil.
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Accueil'),

            /// Navigation vers HomeView.
            onTap: () {
              Navigator.pushNamed(context, HomeView.routeName);
            },
          ),

          /// Lien vers la page des voyages.
          ListTile(
            leading: const Icon(Icons.flight),
            title: const Text('Mes voyages'),

            /// Navigation vers TripsView.
            onTap: () {
              Navigator.pushNamed(context, TripsView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
