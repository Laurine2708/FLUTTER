import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../widgets/dyma.loader.dart';

/// Widget permettant d'afficher la météo actuelle d'une ville
/// en utilisant l'API OpenWeatherMap.
///
/// Il affiche :
/// - un loader pendant le chargement
/// - une icône météo une fois les données récupérées
/// - un message d'erreur en cas de problème
class TripWeather extends StatelessWidget {
  /// Nom de la ville pour laquelle récupérer la météo.
  final String cityName;

  /// URL de base de l'API OpenWeather.
  final String hostBase = 'https://api.openweathermap.org/data/2.5/weather?q=';

  /// Clé API pour accéder au service.
  final String apiKey = '&appid=f5dd5d8df05953a6da3b3676bf708ee0';

  /// Clé API pour accéder au service.
  const TripWeather({super.key, required this.cityName});

  /// Constructeur du widget.
  String get query => '$hostBase$cityName$apiKey';

  /// Appel HTTP pour récupérer les données météo.
  ///
  /// Retourne :
  /// - le code de l'icône météo (String)
  /// - "error" en cas de problème
  Future<String> get getWeather {
    return http
        .get(Uri.parse(query))
        .then((http.Response response) {
          /// Décodage du JSON reçu.
          Map<String, dynamic> body = json.decode(response.body);

          /// Extraction du code de l'icône météo.
          return body['weather'][0]['icon'] as String;
        })
        .catchError((e) => 'error');
  }

  /// Génère l'URL de l'image correspondant à l'icône météo.
  String getIconUrl(String iconName) {
    return 'https://openweathermap.org/img/wn/$iconName@2x.png';
  }

  /// Construction de l'interface utilisateur.
  ///
  /// Utilise un FutureBuilder pour gérer les états :
  /// - loading
  /// - success
  /// - error
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeather,
      builder: (_, snapshot) {
        /// Cas d'erreur.
        if (snapshot.hasError) {
          return const Text('error');

          /// Cas où les données sont disponibles.
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Titre
                const Text('Météo', style: TextStyle(fontSize: 20)),

                /// Icône météo récupérée depuis l'API
                Image.network(
                  getIconUrl(snapshot.data as String),
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          );

          /// Cas de chargement.
        } else {
          return const DymaLoader();
        }
      },
    );
  }
}
