import 'package:flutter/material.dart';
import 'widgets/activity_form.dart';
import '../../widgets/dyma_drawer.dart';

/// Vue représentant l’écran permettant d’ajouter une nouvelle activité.
///
/// Cette page affiche un formulaire permettant à l’utilisateur
/// de saisir les informations nécessaires pour créer une activité
/// associée à une ville.
///
/// La ville concernée est transmise via les arguments de la route.
class ActivityFormView extends StatelessWidget {
  /// Nom de la route utilisée pour accéder à cette vue.
  ///
  /// Cette constante permet de faciliter la navigation
  /// dans l’application avec le système de routes Flutter.
  static const String routeName = '/activity-form';

  /// Constructeur du widget [ActivityFormView].
  const ActivityFormView({super.key});

  /// Construit l’interface utilisateur de la page.
  ///
  /// Cette méthode :
  /// - récupère le nom de la ville passé en argument de navigation
  /// - affiche une barre d’application avec un titre
  /// - affiche un menu latéral (drawer)
  /// - affiche le formulaire de création d’activité.
  @override
  Widget build(BuildContext context) {
    /// Récupération du nom de la ville transmis lors de la navigation.
    String cityName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      /// Barre supérieure de l’application.
      appBar: AppBar(title: const Text('Ajouter une activité')),

      /// Menu latéral de navigation de l’application.
      drawer: const DymaDrawer(),

      /// Corps de la page contenant le formulaire.
      ///
      /// Le [SingleChildScrollView] permet d’éviter les
      /// problèmes d’affichage lorsque le clavier apparaît
      /// sur mobile.
      body: SingleChildScrollView(child: ActivityForm(cityName: cityName)),
    );
  }
}
