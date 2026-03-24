import 'package:flutter/material.dart';
import 'package:my_first_app/views/city/widgets/trip_activity_card.dart';
import '../../../models/activity_model.dart';

/// Widget affichant la liste des activités associées à un voyage.
///
/// Chaque activité est affichée sous forme de carte grâce
/// au widget [TripActivityCard].
///
/// L’utilisateur peut supprimer une activité du voyage
/// directement depuis cette liste.
class TripActivityList extends StatelessWidget {
  /// Liste des activités du voyage.
  final List<Activity> activities;

  /// Fonction appelée lorsqu’une activité doit être supprimée.
  ///
  /// [Activity] Activité à supprimer de la liste.
  final void Function(Activity activity) deleteTripActivity;

  /// Constructeur du widget [TripActivityList].
  ///
  /// [activities] Liste des activités à afficher
  /// [deleteTripActivity] Fonction permettant de supprimer une activité
  TripActivityList({
    required this.activities,
    required this.deleteTripActivity,
  });

  /// Construit l’interface utilisateur de la liste d’activités.
  ///
  /// La liste est générée dynamiquement en transformant
  /// chaque activité en widget [TripActivityCard].
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        /// Création des cartes d’activités à partir de la liste.
        children: activities
            .map(
              (activity) => TripActivityCard(
                /// Clé unique permettant à Flutter
                /// d’identifier correctement chaque widget
                /// lors des mises à jour de la liste.
                key: ValueKey(activity),

                /// Activité affichée dans la carte.
                activity: activity,

                /// Fonction de suppression de l’activité.
                deleteTripActivity: deleteTripActivity,
              ),
            )
            .toList(),
      ),
    );
  }
}
