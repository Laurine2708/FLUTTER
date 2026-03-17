import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';
import 'trip_activity_list.dart';

/// Widget permettant d'afficher les activités d’un voyage
/// sous forme d’onglets (tabs).
///
/// Il contient deux catégories :
/// - activités en cours
/// - activités terminées
class TripActivities extends StatelessWidget {
  /// Identifiant du voyage concerné.
  final String tripId;

  /// Constructeur du widget [TripActivities].
  const TripActivities({super.key, required this.tripId});

  /// Construit l’interface utilisateur avec des onglets.
  ///
  /// Cette vue contient :
  /// - une barre d’onglets (TabBar)
  /// - un contenu différent selon l’onglet sélectionné (TabBarView)
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      /// Nombre d’onglets.
      length: 2,
      child: Column(
        children: <Widget>[
          /// Barre d’onglets en haut.
          Container(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              /// Couleur de l’indicateur sous l’onglet actif.
              indicatorColor: Colors.blue[100],

              /// Couleur du texte sélectionné.
              labelColor: Colors.white,

              /// Couleur du texte non sélectionné.
              unselectedLabelColor: Colors.white70,

              /// Définition des onglets.
              tabs: const <Widget>[
                Tab(text: 'En cours'),
                Tab(text: 'Terminées'),
              ],
            ),
          ),

          /// Contenu des onglets.
          SizedBox(
            height: 600,
            child: TabBarView(
              /// Désactive le swipe entre les onglets.
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                /// Liste des activités en cours.
                TripActivityList(
                  tripId: tripId,
                  filter: ActivityStatus.ongoing,
                ),

                /// Liste des activités terminées.
                TripActivityList(tripId: tripId, filter: ActivityStatus.done),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
