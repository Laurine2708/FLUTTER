import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/trip_model.dart';
import '../../trip/trip_view.dart';

/// Widget affichant la liste des voyages enregistrés.
///
/// Chaque élément de la liste affiche :
/// - le nom de la ville
/// - la date du voyage (si définie)
/// - une icône d'information
///
/// Un clic sur un élément permet d'accéder au détail du voyage.
class TripList extends StatelessWidget {
  /// Liste des voyages à afficher.
  final List<Trip> trips;

  /// Constructeur du widget.
  const TripList({super.key, required this.trips});

  /// Construction de la liste des voyages.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      /// Nombre d'éléments dans la liste.
      itemCount: trips.length,

      /// Builder pour chaque élément de la liste.
      itemBuilder: (context, i) {
        /// Voyage courant.
        var trip = trips[i];
        return ListTile(
          /// Nom de la ville.
          title: Text(trip.city),

          /// Date du voyage (si elle existe).
          subtitle: trip.date != null
              ? Text(DateFormat("d/M/y").format(trip.date!))
              : null,

          /// Icône à droite.
          trailing: const Icon(Icons.info),

          /// Navigation vers la page détail du voyage.
          onTap: () => Navigator.pushNamed(
            context,
            TripView.routeName,

            /// Données envoyées à la page suivante.
            arguments: {'tripId': trip.id, 'cityName': trip.city},
          ),
        );
      },
    );
  }
}
