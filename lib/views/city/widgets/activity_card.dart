import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../models/activity_model.dart';

/// Widget représentant une carte visuelle d’une activité.
///
/// Cette carte affiche :
/// - l’image de l’activité
/// - le nom de l’activité
/// - une icône de sélection si l’activité est choisie.
///
/// Elle permet également à l’utilisateur de sélectionner
/// ou désélectionner une activité en appuyant sur la carte.
class ActivityCard extends StatelessWidget {
  /// Objet représentant l’activité affichée dans la carte.
  final Activity activity;

  /// Indique si l’activité est actuellement sélectionnée.
  ///
  /// Si la valeur est `true`, une icône de validation
  /// sera affichée sur la carte.
  final bool isSelected;

  /// Fonction appelée lorsque l’utilisateur appuie sur la carte.
  ///
  /// Elle permet généralement d’ajouter ou retirer
  /// l’activité d’une sélection.
  final VoidCallback toggleActivity;

  /// Constructeur du widget [ActivityCard].
  ///
  /// [activity] Activité à afficher
  /// [isSelected] Indique si l’activité est sélectionnée
  /// [toggleActivity] Fonction appelée lors du clic sur la carte
  ActivityCard({
    required this.activity,
    required this.isSelected,
    required this.toggleActivity,
  });

  /// Construit l’interface utilisateur de la carte d’activité.
  ///
  /// L’interface comprend :
  /// - une image en arrière-plan
  /// - un bouton tactile permettant de sélectionner l’activité
  /// - une icône de validation si l’activité est sélectionnée
  /// - le nom de l’activité affiché en bas de la carte.
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          /// Image de fond représentant l’activité.
          /// L’image est récupérée depuis une URL.
          Ink.image(
            image: NetworkImage(activity.image), //AssetImage(activity.image),
            fit: BoxFit.cover,

            /// Permet de détecter le clic sur la carte.
            child: InkWell(onTap: toggleActivity),
          ),

          /// Couche contenant les informations affichées
          /// au-dessus de l’image.
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      /// Affiche une icône de validation
                      /// si l’activité est sélectionnée.
                      if (isSelected)
                        Icon(Icons.check, size: 40, color: Colors.white),
                    ],
                  ),
                ),

                /// Affichage du nom de l’activité.
                Row(
                  children: <Widget>[
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          activity.name,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
