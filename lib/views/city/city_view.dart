import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city_model.dart';
import '../../providers/city_provider.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/dyma_drawer.dart';
import '../activity_form/activity_form_view.dart';
import '../home/home_view.dart';
import './widgets/trip_activity_list.dart';

import './widgets/activity_list.dart';
import './widgets/trip_overview.dart';

import '../../models/activity_model.dart';
import '../../models/trip_model.dart';

/// Vue principale permettant d’organiser un voyage dans une ville.
///
/// Cette page permet à l’utilisateur :
/// - de consulter les activités disponibles dans une ville
/// - de sélectionner ses activités préférées
/// - de choisir une date pour son voyage
/// - de voir le montant total par personne
/// - d’enregistrer le voyage.
class CityView extends StatefulWidget {
  /// Nom de la route utilisée pour accéder à cette vue.
  static const String routeName = '/city';

  /// Permet d’adapter l’interface selon l’orientation de l’écran.
  ///
  /// - En mode portrait : les éléments sont affichés verticalement.
  /// - En mode paysage : les éléments sont affichés horizontalement.
  Widget showContext({
    required BuildContext context,
    required List<Widget> children,
  }) {
    var orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    } else {
      return Column(children: children);
    }
  }

  @override
  State<CityView> createState() => _CityState();
}

/// État interne de la vue [CityView].
///
/// Cette classe gère :
/// - la sélection des activités
/// - la date du voyage
/// - le calcul du prix total
/// - la sauvegarde du voyage.
class _CityState extends State<CityView> with WidgetsBindingObserver {
  /// Objet représentant le voyage en cours de création.
  late Trip mytrip;

  /// Index utilisé pour la navigation entre les onglets.
  ///
  /// 0 → liste des activités disponibles
  /// 1 → liste des activités sélectionnées
  late int index;

  /// Initialisation de l’état du widget.
  @override
  void initState() {
    super.initState();
    index = 0;

    /// Création d’un voyage vide.
    mytrip = Trip(activities: [], date: null, city: '');
  }

  /// Ouvre un sélecteur de date pour choisir la date du voyage.
  void setDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((newDate) {
      if (newDate != null) {
        setState(() {
          mytrip.date = newDate;
        });
      }
    });
  }

  /// Change l’onglet affiché dans la barre de navigation.
  void switchIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  /// Ajoute ou retire une activité du voyage.
  void toggleActivity(Activity activity) {
    setState(() {
      mytrip.activities.contains(activity)
          ? mytrip.activities.remove(activity)
          : mytrip.activities.add(activity);
    });
  }

  /// Supprime une activité de la liste des activités sélectionnées.
  void deleteTripActivity(Activity activity) {
    setState(() {
      mytrip.activities.remove(activity);
    });
  }

  /// Sauvegarde le voyage dans le provider.
  ///
  /// Cette méthode :
  /// - demande confirmation à l’utilisateur
  /// - vérifie que la date est définie
  /// - enregistre le voyage dans [TripProvider]
  /// - redirige vers la page d’accueil.
  void saveTrip(String cityName) async {
    final result = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Voulez-vous sauvegarder ?'),
        contentPadding: const EdgeInsets.all(20),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context, 'save');
                },
                child: const Text(
                  'Sauvegarder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 60),
              ElevatedButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.pop(context, 'cancel');
                },
              ),
            ],
          ),
        ],
      ),
    );

    /// Vérifie si une date a été sélectionnée.
    if (mytrip.date == null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Attention !'),
            content: const Text('Vous n\'avez pas entré de date'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }

      /// Sauvegarde le voyage si l’utilisateur confirme.
    } else if (result == 'save') {
      if (mounted) {
        mytrip.city = cityName;
        Provider.of<TripProvider>(context, listen: false).addTrip(mytrip);
        Navigator.pushNamed(context, HomeView.routeName);
      }
    }
  }

  /// Calcule le montant total par personne.
  ///
  /// Le montant est la somme du prix de toutes
  /// les activités sélectionnées.
  double get amount {
    return mytrip.activities.fold(0.0, (acc, cur) {
      return acc + cur.price;
    });
  }

  /// Construit l’interface utilisateur principale.
  @override
  Widget build(BuildContext context) {
    /// Récupération du nom de la ville via la navigation.
    String cityName = ModalRoute.of(context)!.settings.arguments as String;

    /// Récupération des données de la ville via le provider.
    City city = Provider.of<CityProvider>(context).getCityByName(cityName);

    return Scaffold(
      /// Barre supérieure de l’application.
      appBar: AppBar(
        title: const Text('Organisation du voyage'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),

            /// Navigation vers le formulaire d’ajout d’activité.
            onPressed: () => Navigator.pushNamed(
              context,
              ActivityFormView.routeName,
              arguments: cityName,
            ),
          ),
        ],
      ),

      /// Menu latéral de navigation.
      drawer: const DymaDrawer(),

      /// Corps de la page.
      body: widget.showContext(
        context: context,
        children: [
          /// Résumé du voyage.
          TripOverview(
            cityName: city.name,
            trip: mytrip,
            setDate: setDate,
            amount: amount,
            cityImage: city.image,
          ),

          /// Affichage conditionnel selon l’onglet sélectionné.
          Expanded(
            child: index == 0
                ? ActivityList(
                    activities: city.activities,
                    selectedActivities: mytrip.activities,
                    toggleActivity: toggleActivity,
                  )
                : TripActivityList(
                    activities: mytrip.activities,
                    deleteTripActivity: deleteTripActivity,
                  ),
          ),
        ],
      ),

      /// Bouton flottant pour sauvegarder le voyage.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveTrip(city.name);
        },
        child: const Icon(Icons.forward),
      ),

      /// Barre de navigation en bas de l’écran.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: switchIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Découverte'),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: 'Mes favoris',
          ),
        ],
      ),
    );
  }
}
