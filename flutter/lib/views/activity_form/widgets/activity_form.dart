import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../apis/google_api.dart';
import '../../../models/activity_model.dart';
import '../../../providers/city_provider.dart';
import 'activity_form_autocomplete.dart';
import 'activity_form_image_picker.dart';
import 'package:location/location.dart';

/// Widget représentant le formulaire de création d’une activité.
///
/// Ce formulaire permet à l’utilisateur de saisir les informations
/// nécessaires pour ajouter une nouvelle activité à une ville donnée.
///
/// Les informations saisies incluent :
/// - le nom de l’activité
/// - le prix
/// - l’adresse
/// - l’image associée
/// - la localisation géographique.
///
/// Les données sont ensuite envoyées au backend via le [CityProvider].
class ActivityForm extends StatefulWidget {
  /// Nom de la ville dans laquelle l’activité sera ajoutée.
  final String cityName;

  /// Constructeur du widget [ActivityForm].
  ///
  /// [cityName] Ville associée à la nouvelle activité.
  const ActivityForm({super.key, required this.cityName});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

/// État interne du formulaire [ActivityForm].
///
/// Cette classe gère :
/// - la validation du formulaire
/// - la récupération de l’adresse via autocomplétion
/// - la récupération de la position GPS de l’utilisateur
/// - l’envoi des données au backend.
class _ActivityFormState extends State<ActivityForm> {
  /// Clé globale permettant d’accéder à l’état du formulaire.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// FocusNode permettant de gérer le focus sur le champ prix.
  late FocusNode _priceFocusNode;

  /// FocusNode permettant de gérer le focus sur le champ URL.
  late FocusNode _urlFocusNode;

  /// FocusNode permettant de gérer le focus sur le champ adresse.
  late FocusNode _addressFocusNode;

  /// Objet représentant la nouvelle activité à créer.
  late Activity _newActivity;

  /// Variable utilisée pour la validation asynchrone
  /// du nom de l’activité.
  late String? _nameInputAsync;

  /// Contrôleur pour le champ URL de l’image.
  final TextEditingController _urlController = TextEditingController();

  /// Contrôleur pour le champ adresse.
  final TextEditingController _addressController = TextEditingController();

  /// Indique si une opération de chargement est en cours.
  bool _isLoading = false;

  /// Accès simplifié à l’état du formulaire.
  FormState get form {
    return _formKey.currentState!;
  }

  /// Initialisation de l’état du widget.
  ///
  /// Cette méthode initialise :
  /// - l’objet activité
  /// - les différents FocusNode
  /// - le comportement du champ adresse avec autocomplétion.
  @override
  void initState() {
    _newActivity = Activity(
      city: widget.cityName,
      name: '',
      price: 0,
      image: '',
      location: LocationActivity(
        address: null,
        longitude: null,
        latitude: null,
      ),
      status: ActivityStatus.ongoing,
    );
    _priceFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
    _addressFocusNode = FocusNode();

    /// Écoute les changements de focus sur le champ adresse
    /// afin d’ouvrir le système d’autocomplétion.
    _addressFocusNode.addListener(() async {
      if (_addressFocusNode.hasFocus) {
        var location = await showInputAutocomplete(context);
        _addressFocusNode.nextFocus();
        if (location != null) {
          _newActivity.location = location;
          setState(() {
            if (location != null) {
              _addressController.text = location.address!;
            }
          });
          _urlFocusNode.requestFocus();
        }
      } else {
        print('no focus');
      }
    });
    super.initState();
  }

  /// Met à jour le champ URL après l’upload d’une image.
  ///
  /// [url] URL retournée par le serveur après l’envoi de l’image.
  void updateUrlField(String url) {
    setState(() {
      _urlController.text = url;
    });
  }

  /// Récupère la position actuelle de l’utilisateur.
  ///
  /// Cette méthode :
  /// - vérifie l’activation du GPS
  /// - demande les permissions nécessaires
  /// - récupère la latitude et la longitude
  /// - convertit ces coordonnées en adresse via l’API Google.
  void _getCurrentLocation() async {
    try {
      Location location = Location();
      LocationData userLocation;
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      userLocation = await location.getLocation();

      String address = await getAddressFromLatLng(
        lat: userLocation.latitude!,
        lng: userLocation.longitude!,
      );
      _newActivity.location = LocationActivity(
        address: address,
        latitude: userLocation.latitude!,
        longitude: userLocation.longitude!,
      );
      setState(() {
        _addressController.text = address;
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Libère les ressources utilisées par les FocusNode
  /// et les contrôleurs de texte.
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _urlFocusNode.dispose();
    _addressFocusNode.dispose();
    _urlController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  /// Soumet le formulaire pour créer une nouvelle activité.
  ///
  /// Cette méthode :
  /// 1. sauvegarde les valeurs du formulaire
  /// 2. vérifie que le nom de l’activité est unique
  /// 3. valide les champs du formulaire
  /// 4. envoie les données au backend via [CityProvider].
  Future<void> submitForm() async {
    try {
      CityProvider cityProvider = Provider.of<CityProvider>(
        context,
        listen: false,
      );
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      _nameInputAsync = await cityProvider.verifyIfActivityNameIsUnique(
        widget.cityName,
        _newActivity.name,
      );
      if (form.validate()) {
        await cityProvider.addActivityToCity(_newActivity);
        if (mounted) Navigator.pop(context);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  /// Construit l’interface utilisateur du formulaire.
  ///
  /// Le formulaire comprend :
  /// - un champ nom
  /// - un champ prix
  /// - un champ adresse avec autocomplétion
  /// - un bouton pour utiliser la position GPS
  /// - un champ URL d’image
  /// - un sélecteur d’image
  /// - des boutons d’annulation et de sauvegarde.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez le nom';
                } else if (_nameInputAsync != null) {
                  return _nameInputAsync;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Nom'),
              onSaved: (value) => _newActivity.name = value!,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceFocusNode),
            ),
            const SizedBox(height: 30),
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _priceFocusNode,
              decoration: const InputDecoration(hintText: 'Prix'),
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_urlFocusNode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez le Prix';
                }
                return null;
              },
              onSaved: (value) => _newActivity.price = double.parse(value!),
            ),
            const SizedBox(height: 30),
            TextFormField(
              focusNode: _addressFocusNode,
              controller: _addressController,
              decoration: const InputDecoration(hintText: 'Adresse'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez une adresse valide';
                }
                return null;
              },
              onSaved: (value) => _newActivity.location!.address = value!,
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Utiliser ma position actuelle'),
              onPressed: _getCurrentLocation,
            ),
            const SizedBox(height: 30),
            TextFormField(
              keyboardType: TextInputType.url,
              focusNode: _urlFocusNode,
              controller: _urlController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez l\'url';
                }
                return null;
              },
              decoration: const InputDecoration(hintText: 'Url image'),
              onSaved: (value) => _newActivity.image = value!,
            ),
            const SizedBox(height: 30),

            /// Widget permettant de sélectionner une image.
            ActivityFormImagePicker(updateUrl: updateUrlField),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : submitForm,
                  child: const Text('Sauvegarder'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
