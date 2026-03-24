import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/activity_model.dart';
import '../../../models/trip_model.dart';
import '../../../providers/trip_provider.dart';
import '../../google_map/google_map_view.dart';

/// Widget affichant la liste des activités d’un voyage,
/// filtrées selon leur statut (en cours ou terminées).
class TripActivityList extends StatelessWidget {
  /// Identifiant du voyage.
  final String tripId;

  /// Filtre appliqué aux activités (ongoing ou done).
  final ActivityStatus filter;

  /// Constructeur du widget.
  const TripActivityList({
    super.key,
    required this.tripId,
    required this.filter,
  });

  /// Construit l’interface utilisateur.
  ///
  /// Cette méthode :
  /// - récupère le voyage via le provider
  /// - filtre les activités selon leur statut
  /// - affiche une liste dynamique
  @override
  Widget build(BuildContext context) {
    /// Récupération du voyage correspondant à l'id.
    final Trip trip = Provider.of<TripProvider>(context).getById(tripId);

    /// Filtrage des activités selon leur statut.
    final List<Activity> activities = trip.activities
        .where((activity) => activity.status == filter)
        .toList();

    /// Construction de la liste des activités.
    return ListView.builder(
      itemCount: activities.length,

      /// Builder pour chaque élément de la liste.
      ///Context et index de l'itération en cours
      itemBuilder: (context, i) {
        final Activity activity = activities[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),

          /// Si l’activité est en cours → swipe possible
          child: filter == ActivityStatus.ongoing
              /// Widget permettant de glisser pour marquer comme terminé.
              ? Dismissible(
                  /// Direction du swipe (droite → gauche).
                  direction: DismissDirection.endToStart,

                  /// Fond affiché pendant le swipe.
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent[700],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  /// Clé unique pour identifier l'élément.
                  key: ValueKey(activity.id),

                  /// Contenu principal de la carte.
                  child: InkWell(
                    /// Navigation vers la carte Google Maps.
                    onTap: () => Navigator.pushNamed(
                      context,
                      GoogleMapView.routeName,
                      arguments: {'activityId': activity.id, 'tripId': trip.id},
                    ),
                    child: Card(child: ListTile(title: Text(activity.name))),
                  ),

                  /// Action à effectuer lors du swipe.
                  confirmDismiss: (_) =>
                      Provider.of<TripProvider>(context, listen: false)
                          .updateTrip(trip, activity.id)
                          /// Si succès → on valide le swipe.
                          .then((_) => true)
                          /// Si erreur → on annule.
                          .catchError((_) => false),
                )
              /// Si activité terminée → affichage simple.
              : Card(
                  child: ListTile(
                    title: Text(
                      activity.name,

                      /// Style grisé pour indiquer que c’est terminé.
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
