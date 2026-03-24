import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/city_provider.dart';
import 'widgets/trip_activities.dart';
import 'widgets/trip_city_bar.dart';
import '../../models/city_model.dart';
import 'widgets/trip_weather.dart';

/// Vue principale d’un voyage.
///
/// Cette page affiche :
/// - une bannière de la ville
/// - la météo actuelle
/// - les activités du voyage
class TripView extends StatelessWidget {
  /// Nom de la route pour la navigation.
  static const String routeName = '/trip';

  /// Nom de la route pour la navigation.
  @override
  Widget build(BuildContext context) {
    /// Récupération des arguments passés via la navigation.
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    /// Nom de la ville.
    final String cityName = arguments['cityName']!;

    /// Identifiant du voyage.
    final String tripId = arguments['tripId']!;

    /// Récupération de la ville via le provider.
    final City city = Provider.of<CityProvider>(
      context,
      listen: false,
    ).getCityByName(cityName);
    return Scaffold(
      /// Corps de la page avec scroll vertical.
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            /// Bannière avec image + bouton retour + nom de la ville.
            TripCityBar(city: city),

            /// Bannière avec image + bouton retour + nom de la ville.
            TripWeather(cityName: cityName),

            /// Widget affichant la météo de la ville.
            TripActivities(tripId: tripId),
          ],
        ),
      ),
    );
  }
}
