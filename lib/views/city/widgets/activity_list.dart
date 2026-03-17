import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';
import './activity_card.dart';

/// Widget affichant une liste d’activités sous forme de grille.
///
/// Chaque activité est représentée par une [ActivityCard].
/// L’utilisateur peut sélectionner ou désélectionner une activité
/// en appuyant sur la carte correspondante.
class ActivityList extends StatelessWidget {
  /// Liste complète des activités à afficher.
  final List<Activity> activities;

  /// Liste des activités actuellement sélectionnées.
  ///
  /// Cette liste est utilisée pour déterminer si une activité
  /// doit afficher l’icône de validation.
  final List<Activity> selectedActivities;

  /// Fonction appelée lorsqu’une activité est sélectionnée
  /// ou désélectionnée par l’utilisateur.
  ///
  /// [activity] Activité concernée par l’action.
  final void Function(Activity activity) toggleActivity;

  /// Constructeur du widget [ActivityList].
  ///
  /// [activities] Liste des activités à afficher
  /// [selectedActivities] Activités actuellement sélectionnées
  /// [toggleActivity] Fonction permettant de gérer la sélection
  ActivityList({
    required this.activities,
    required this.selectedActivities,
    required this.toggleActivity,
  });

  /// Construit l’interface utilisateur de la liste d’activités.
  ///
  /// Les activités sont affichées dans une grille
  /// composée de deux colonnes.
  ///
  /// Chaque activité est transformée en widget [ActivityCard].
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      /// Espacement vertical entre les cartes.
      mainAxisSpacing: 1,

      /// Espacement horizontal entre les cartes.
      crossAxisSpacing: 1,

      /// Nombre de colonnes dans la grille.
      crossAxisCount: 2,

      /// Création de la liste des cartes d’activités.
      children: activities
          .map(
            (activity) => ActivityCard(
              /// Activité affichée dans la carte.
              activity: activity,

              /// Indique si l’activité est sélectionnée.
              isSelected: selectedActivities.contains(activity),

              /// Fonction appelée lors du clic sur la carte.
              toggleActivity: () {
                toggleActivity(activity);
              },
            ),
          )
          .toList(),
    );
  }
}
