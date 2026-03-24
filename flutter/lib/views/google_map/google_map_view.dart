import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/activity_model.dart';
import '../../providers/trip_provider.dart';

/// Vue affichant une carte Google Maps centrée sur une activité.
///
/// Cette page permet :
/// - d’afficher la localisation d’une activité sur une carte
/// - de placer un marqueur sur cette activité
/// - d’ouvrir la navigation Google Maps vers cette activité
class GoogleMapView extends StatefulWidget {
  /// Nom de la route permettant d'accéder à cette vue.
  static const String routeName = '/google-map';

  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

/// État interne de la vue GoogleMapView.
///
/// Cette classe gère :
/// - la récupération de l'activité
/// - l'affichage de la carte
/// - l'ouverture de la navigation GPS
class _GoogleMapViewState extends State<GoogleMapView> {
  /// Indique si les données ont déjà été chargées.
  final bool _isLoaded = false;

  /// Contrôleur de la carte Google Maps.
  late GoogleMapController _controller;

  /// Activité dont on souhaite afficher la localisation.
  late Activity _activity;

  /// Méthode appelée lorsque les dépendances changent.
  ///
  /// Elle permet de récupérer :
  /// - l'identifiant de l'activité
  /// - l'identifiant du voyage
  /// afin de retrouver l'activité correspondante via le provider.
  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      /// Récupération des arguments passés via la navigation.
      var arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

      /// Récupération de l'activité dans le provider.
      _activity = Provider.of<TripProvider>(context, listen: false)
          .getActivityByIds(
            activityId: arguments['activityId']!,
            tripId: arguments['tripId']!,
          );

      /// Si l'activité ne possède pas de localisation,
      /// on quitte la page.
      if (_activity.location == null) {
        Navigator.pop(context, null);
      }
    }
    super.didChangeDependencies();
  }

  /// Retourne les coordonnées GPS de l'activité.
  ///
  /// Elles sont utilisées pour positionner le marqueur sur la carte.
  get _activityLatLng {
    return LatLng(
      _activity.location!.latitude!,
      _activity.location!.longitude!,
    );
  }

  /// Position initiale de la caméra Google Maps.
  ///
  /// La carte est centrée sur l'activité avec un niveau de zoom de 16.
  get _initialCameraPosition {
    return CameraPosition(target: _activityLatLng, zoom: 16.0);
  }

  /// Ouvre la navigation GPS vers l'activité.
  ///
  /// Cette méthode utilise le package `url_launcher`
  /// pour ouvrir Google Maps en mode navigation.
  Future<void> _openUrl() async {
    Uri url = Uri.parse('google.navigation:q=${_activity.location!.address}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'cannot launch url';
    }
  }

  /// Construit l’interface utilisateur de la page.
  ///
  /// L'écran contient :
  /// - une carte Google Maps
  /// - un marqueur indiquant l'activité
  /// - un bouton pour lancer la navigation GPS.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Barre supérieure affichant le nom de l'activité.
      appBar: AppBar(title: Text(_activity.name)),

      /// Carte Google Maps.
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,

        /// Type de carte (standard).
        mapType: MapType.normal,

        /// Initialisation du contrôleur de carte.
        onMapCreated: (controller) => _controller = controller,

        /// Marqueur indiquant la position de l'activité.
        markers: {
          Marker(
            markerId: const MarkerId('123'),
            flat: true,
            position: _activityLatLng,
          ),
        },
      ),

      /// Bouton permettant de lancer la navigation GPS.
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.directions_car),
        onPressed: _openUrl,
        label: const Text('Go'),
      ),
    );
  }
}
