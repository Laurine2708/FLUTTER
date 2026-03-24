import '../models/activity_model.dart';
import '../models/trip_model.dart';

/// Liste de voyages utilisée comme jeu de données local.
///
/// Cette variable contient une collection d’objets [Trip] représentant
/// différents voyages avec leurs activités associées.
///
/// Elle peut être utilisée pour :
/// - tester l’affichage des voyages dans l’application
/// - simuler des données avant la mise en place d’une API
/// - fournir des exemples d’activités liées à une ville.
///
/// Chaque [Trip] contient :
/// - une ville
/// - une date de voyage
/// - une liste d’[Activity] associées au voyage.
List<Trip> trips = [
  Trip(
    activities: [
      /// Activité représentant la visite du musée du Louvre à Paris.
      Activity(
        image: 'assets/images/activities/louvre.jpeg',
        name: 'Louvre',
        id: 'a1',
        city: 'Paris',
        price: 12.00,
      ),

      /// Activité représentant une visite du parc des Buttes-Chaumont à Paris.
      Activity(
        image: 'assets/images/activities/chaumont.jpeg',
        name: 'Chaumont',
        id: 'a2',
        city: 'Paris',
        price: 0.00,
      ),

      /// Activité représentant la visite de la cathédrale Notre-Dame à Paris.
      Activity(
        image: 'assets/images/activities/dame.jpeg',
        name: 'Notre-Dame',
        id: 'a3',
        city: 'Paris',
        price: 0.00,
      ),
    ],

    /// Ville dans laquelle se déroule le voyage.
    city: 'Paris',

    /// Date prévue du voyage (1 jour à partir de la date actuelle).
    date: DateTime.now().add(const Duration(days: 1)),
  ),

  /// Voyage prévu à Lyon sans activités enregistrées.
  Trip(
    activities: [],
    city: 'Lyon',
    date: DateTime.now().add(const Duration(days: 2)),
  ),

  /// Voyage passé à Nice (date située dans le passé).
  Trip(
    activities: [],
    city: 'Nice',
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
