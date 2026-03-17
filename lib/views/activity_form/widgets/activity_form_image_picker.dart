import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/city_provider.dart';

/// Widget permettant à l’utilisateur de sélectionner une image
/// depuis la galerie ou la caméra de l’appareil.
///
/// Ce composant est utilisé dans un formulaire de création
/// d’activité afin d’associer une image à celle-ci.
///
/// L’image sélectionnée est ensuite envoyée au serveur via
/// le [CityProvider], puis l’URL retournée est transmise
/// au widget parent grâce à la fonction [updateUrl].
class ActivityFormImagePicker extends StatefulWidget {
  /// Fonction de rappel permettant de transmettre l’URL
  /// de l’image uploadée au widget parent.
  final Function updateUrl;

  /// Constructeur du widget [ActivityFormImagePicker].
  ///
  /// [updateUrl] Fonction appelée lorsque l’image a été
  /// envoyée au serveur et que l’URL est disponible.
  const ActivityFormImagePicker({super.key, required this.updateUrl});

  @override
  State<ActivityFormImagePicker> createState() =>
      _ActivityFormImagePickerState();
}

/// État interne du widget [ActivityFormImagePicker].
///
/// Cette classe gère :
/// - la sélection d’une image depuis l’appareil
/// - l’envoi de l’image au serveur
/// - l’affichage de l’image sélectionnée.
class _ActivityFormImagePickerState extends State<ActivityFormImagePicker> {
  /// Fichier image sélectionné sur l’appareil.
  File? _deviceImage;

  /// Instance du sélecteur d’image permettant
  /// d’accéder à la galerie ou à la caméra.
  final picker = ImagePicker();

  /// Permet de sélectionner une image depuis la source choisie.
  ///
  /// [source] Source de l’image (caméra ou galerie).
  ///
  /// Une fois l’image sélectionnée :
  /// 1. elle est convertie en objet [File]
  /// 2. elle est envoyée au serveur via [CityProvider.uploadImage]
  /// 3. l’URL retournée est transmise au widget parent
  /// 4. l’interface est mise à jour pour afficher l’image.
  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        _deviceImage = File(pickedFile.path);
        final url = await Provider.of<CityProvider>(
          context,
          listen: false,
        ).uploadImage(_deviceImage!);
        widget.updateUrl(url);
        setState(() {});
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  /// Construit l’interface utilisateur du sélecteur d’image.
  ///
  /// L’interface comprend :
  /// - un bouton pour sélectionner une image depuis la galerie
  /// - un bouton pour prendre une photo avec la caméra
  /// - un aperçu de l’image sélectionnée.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.photo),

              /// Ouvre la galerie pour sélectionner une image.
              label: const Text('Galerie'),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            TextButton.icon(
              icon: const Icon(Icons.photo_camera),

              /// Ouvre la caméra pour prendre une photo.
              label: const Text('Caméra'),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: _deviceImage != null
              /// Affiche l’image sélectionnée.
              ? Image.file(_deviceImage!, fit: BoxFit.cover)
              /// Texte affiché si aucune image n’a été sélectionnée.
              : const Text('Aucune image'),
        ),
      ],
    );
  }
}
