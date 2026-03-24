import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_first_app/models/activity_model.dart';

/// Widget représentant une carte d’activité dans un voyage.
///
/// Cette carte affiche les informations principales
/// d’une activité ajoutée à un voyage :
/// - l’image de l’activité
/// - le nom de l’activité
/// - la ville associée
///
/// Elle permet également de supprimer l’activité du voyage.
class TripActivityCard extends StatefulWidget {
  /// Activité affichée dans la carte.
  final Activity activity;

  /// Fonction appelée pour supprimer l’activité du voyage.
  ///
  /// Cette fonction est généralement fournie par
  /// le widget parent qui gère la liste des activités.
  final Function deleteTripActivity;

  /// Génère une couleur aléatoire pour la carte.
  ///
  /// Cette méthode sélectionne une couleur
  /// parmi une liste prédéfinie.
  Color getColor() {
    const colors = [Colors.blue, Colors.red];
    return colors[Random().nextInt(2)];
  }

  /// Constructeur du widget [TripActivityCard].
  ///
  /// [activity] Activité à afficher
  /// [deleteTripActivity] Fonction permettant de supprimer l’activité
  TripActivityCard({
    required Key key,
    required this.activity,
    required this.deleteTripActivity,
  }) : super(key: key);

  @override
  _TripActivityCardState createState() => _TripActivityCardState();
}

/// État interne du widget [TripActivityCard].
///
/// Cette classe gère principalement l’initialisation
/// de la couleur de la carte.
class _TripActivityCardState extends State<TripActivityCard> {
  /// Couleur aléatoire attribuée à la carte.
  late Color color;

  /// Initialisation de l’état du widget.
  ///
  /// La couleur est générée une seule fois lors
  /// de la création du widget.
  @override
  void initState() {
    color = widget.getColor();
    super.initState();
  }

  /// Construit l’interface utilisateur de la carte.
  ///
  /// L’interface comprend :
  /// - une image circulaire représentant l’activité
  /// - le nom de l’activité
  /// - la ville associée
  /// - un bouton permettant de supprimer l’activité.
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        /// Image de l’activité affichée dans un avatar circulaire.
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            widget.activity.image,
          ), //AssetImage(widget.activity.image),
        ),

        /// Nom de l’activité.
        title: Text(widget.activity.name),

        /// Ville dans laquelle se déroule l’activité.
        subtitle: Text(widget.activity.city),

        /// Bouton permettant de supprimer l’activité du voyage.
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            /// Appel de la fonction de suppression.
            widget.deleteTripActivity(widget.activity);

            /// Affiche une notification temporaire (SnackBar)
            /// pour informer l’utilisateur que l’activité a été supprimée.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Activité supprimée'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
