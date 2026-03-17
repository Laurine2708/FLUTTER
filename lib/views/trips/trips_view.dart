import 'package:flutter/material.dart';
import 'package:my_first_app/widgets/dyma.loader.dart';
import 'package:provider/provider.dart';
//import '../../models/trip_model.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/dyma_drawer.dart';
import 'widgets/trip_list.dart';

/// Vue affichant la liste des voyages de l'utilisateur.
///
/// Cette page est divisée en deux onglets :
/// - Voyages à venir
/// - Voyages passés
///
/// Les données sont récupérées via le TripProvider.
class TripsView extends StatelessWidget {
  /// Nom de la route pour la navigation.
  static const String routeName = '/trips';

  /// Constructeur du widget.
  const TripsView({super.key});

  /// Construction de l’interface utilisateur.
  @override
  Widget build(BuildContext context) {
    /// Accès au provider des voyages.
    TripProvider tripProvider = Provider.of<TripProvider>(context);
    return DefaultTabController(
      /// Nombre d’onglets.
      length: 2,
      child: Scaffold(
        /// Barre supérieure avec titre + onglets.
        appBar: AppBar(
          title: const Text('Mes voyages'),

          /// Onglets "À venir" / "Passés"
          bottom: const TabBar(
            tabs: [
              Tab(text: 'À venir'),
              Tab(text: 'Passés'),
            ],
          ),
        ),

        /// Menu latéral.
        drawer: const DymaDrawer(),

        /// Corps de la page.
        body: tripProvider.isLoading != true
            /// Si les données sont chargées
            ? tripProvider.trips.length > 0
                  /// Si on a des voyages
                  ? TabBarView(
                      children: <Widget>[
                        /// Onglet : voyages à venir
                        TripList(
                          trips: tripProvider.trips
                              .where(
                                (trip) => DateTime.now().isBefore(trip.date!),
                              )
                              .toList(),
                        ),

                        /// Onglet : voyages à venir
                        TripList(
                          trips: tripProvider.trips
                              .where(
                                (trip) => DateTime.now().isAfter(trip.date!),
                              )
                              .toList(),
                        ),
                      ],
                    )
                  /// Aucun voyage
                  : Container(
                      alignment: Alignment.center,
                      child: const Text('Aucun voyage pour le moment'),
                    )
            /// Chargement des données
            : DymaLoader(),
      ),
    );
  }
}
