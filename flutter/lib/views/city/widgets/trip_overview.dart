import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'trip_overview_city.dart';
import '../../../models/trip_model.dart';

/// Widget affichant le résumé d’un voyage.
///
/// Ce composant présente les informations principales d’un voyage :
/// - la ville et son image
/// - la date du voyage
/// - le montant par personne
///
/// Il permet également à l’utilisateur de sélectionner une date
/// pour le voyage grâce à un bouton.
class TripOverview extends StatelessWidget {
  // Fonction permettant d’ouvrir le sélecteur de date.
  ///
  /// Elle est appelée lorsque l’utilisateur appuie sur
  /// le bouton "Sélectionner une date".
  final VoidCallback? setDate;

  /// Objet représentant le voyage.
  final Trip trip;

  /// Nom de la ville associée au voyage.
  final String cityName;

  /// Image représentant la ville.
  final String cityImage;

  /// Montant total par personne pour le voyage.
  final double amount;

  /// Constructeur du widget [TripOverview].
  ///
  /// [setDate] Fonction permettant de choisir une date
  /// [trip] Objet contenant les informations du voyage
  /// [cityName] Nom de la ville
  /// [cityImage] Image de la ville
  /// [amount] Montant par personne
  const TripOverview({
    super.key,
    required this.setDate,
    required this.trip,
    required this.cityName,
    required this.amount,
    required this.cityImage,
  });

  /// Construit l’interface utilisateur du résumé du voyage.
  ///
  /// L’interface comprend :
  /// - un bandeau avec l’image de la ville
  /// - un champ affichant la date du voyage
  /// - un bouton pour sélectionner une date
  /// - un affichage du montant par personne.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// Bandeau affichant la ville et son image.
          TripOverviewCity(cityName: cityName, cityImage: cityImage),
          const SizedBox(height: 30),

          /// Section permettant d’afficher ou sélectionner la date.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: <Widget>[
                /// Affichage de la date du voyage.
                Expanded(
                  child: Text(
                    trip.date != null
                        ? DateFormat("d/M/y").format(trip.date!)
                        : 'Choisissez une date',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),

                /// Bouton permettant d’ouvrir le sélecteur de date.
                ElevatedButton(
                  onPressed: setDate,
                  child: const Text('Sélectionner une date'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          /// Section affichant le montant par personne.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: <Widget>[
                /// Texte indiquant le type d’information affichée.
                const Expanded(
                  child: Text(
                    'Montant / personne',
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                /// Affichage du montant calculé.
                Text(
                  '$amount €',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
