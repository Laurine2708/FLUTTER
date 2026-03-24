import 'package:flutter/material.dart';
import 'package:my_first_app/views/city/city_view.dart';
import 'package:my_first_app/views/home/home_view.dart';
import 'package:provider/provider.dart';

import 'providers/city_provider.dart';
import 'providers/trip_provider.dart';
import 'views/activity_form/activity_form_view.dart';
import 'views/google_map/google_map_view.dart';
import 'views/not_found/not_found.dart';
import 'views/trip/trip_view.dart';
import 'views/trips/trips_view.dart';

/// Point d'entrée principal de l'application.
void main() {
  runApp(const MyApp());
}

/// Widget racine de l'application.
///
/// Il initialise :
/// - les providers (state management)
/// - les routes (navigation)
/// - le thème global
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// État du widget MyApp.
///
/// Permet d'initialiser les données au démarrage.
class _MyAppState extends State<MyApp> {
  /// Provider gérant les villes.
  final CityProvider cityProvider = CityProvider();

  /// Provider gérant les voyages.
  final TripProvider tripProvider = TripProvider();

  /// Méthode appelée au démarrage de l'app.
  ///
  /// Elle permet de charger les données initiales :
  /// - villes
  /// - voyages
  @override
  void initState() {
    tripProvider.fetchData();
    cityProvider.fetchData();
    super.initState();
  }

  /// Construction de l'application.
  ///
  /// Configure :
  /// - les providers globaux
  /// - les routes de navigation
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      /// Injection des providers dans toute l'application.
      providers: [
        /// Provider des villes.
        ChangeNotifierProvider.value(value: cityProvider),

        /// Provider des voyages.
        ChangeNotifierProvider.value(value: tripProvider),
      ],

      child: MaterialApp(
        /// Supprime le bandeau debug.
        debugShowCheckedModeBanner: false,

        /// Définition des routes de l'application.
        routes: {
          /// Page d'accueil.
          '/': (_) => const HomeView(),

          /// Page d'une ville.
          CityView.routeName: (_) => CityView(),

          /// Liste des voyages.
          TripsView.routeName: (_) => TripsView(),

          /// Détail d’un voyage.
          TripView.routeName: (_) => TripView(),

          /// Formulaire d’ajout d’activité.
          ActivityFormView.routeName: (_) => const ActivityFormView(),

          /// Carte Google Maps.
          GoogleMapView.routeName: (_) => const GoogleMapView(),
        },

        /// Route appelée si aucune correspondance trouvée.
        onUnknownRoute: (_) =>
            MaterialPageRoute(builder: (context) => const NotFound()),
      ),
    );
  }
}
