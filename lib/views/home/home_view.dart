import 'package:flutter/material.dart';
import 'package:my_first_app/widgets/dyma.loader.dart';
import 'package:provider/provider.dart';
//import '../../datas/data.dart';
import '../../providers/city_provider.dart';
import '../../views/home/widgets/city_card.dart';
import '../../widgets/dyma_drawer.dart';

import '../../models/city_model.dart';

/// Page d'accueil de l'application Dymatrip.
///
/// Cette vue affiche la liste des villes disponibles.
/// L'utilisateur peut :
/// - rechercher une ville grâce à une barre de recherche
/// - rafraîchir la liste des villes
/// - accéder à la page d'organisation du voyage d'une ville
class HomeView extends StatefulWidget {
  /// Route principale de l'application.
  static const String routeName = '/';

  const HomeView({super.key});

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

/// État interne de la page d'accueil.
///
/// Cette classe gère :
/// - la recherche de villes
/// - l'affichage de la liste
/// - le rafraîchissement des données
class _HomeState extends State<HomeView> {
  /// Contrôleur du champ de recherche.
  ///
  /// Il permet de récupérer le texte saisi
  /// par l'utilisateur dans la barre de recherche.
  TextEditingController searchController = TextEditingController();

  // Initialisation du widget.
  ///
  /// Un listener est ajouté au contrôleur de recherche
  /// afin de mettre à jour l'interface lorsque
  /// le texte change.
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  /// Libération des ressources utilisées
  /// par le contrôleur lorsque le widget est détruit.
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Construction de l'interface utilisateur.
  ///
  /// Cette page contient :
  /// - une barre de recherche
  /// - une liste de villes
  /// - un rafraîchissement par glissement
  @override
  Widget build(BuildContext context) {
    /// Récupération du provider des villes.
    CityProvider cityProvider = Provider.of<CityProvider>(context);

    /// Filtrage des villes selon le texte de recherche.
    List<City> filteredCities = cityProvider.getFilteredCities(
      searchController.text,
    );
    return Scaffold(
      /// Barre supérieure de l'application.
      appBar: AppBar(
        title: const Text('Dymatrip'),
        actions: const <Widget>[Icon(Icons.more_vert)],
      ),

      /// Menu latéral de navigation.
      drawer: const DymaDrawer(),

      /// Corps principal de la page.
      body: Column(
        children: <Widget>[
          /// Barre de recherche permettant
          /// de filtrer les villes.
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: <Widget>[
                /// Champ de texte pour rechercher une ville.
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher une ville',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                /// Bouton permettant d'effacer la recherche.
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => searchController.clear()),
                ),
              ],
            ),
          ),

          /// Zone contenant la liste des villes.
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),

              /// Widget permettant le rafraîchissement
              /// de la liste par glissement vers le bas.
              child: RefreshIndicator(
                /// Distance de déclenchement du rafraîchissement.
                displacement: 100.0,

                /// Fonction appelée lors du rafraîchissement.
                onRefresh: Provider.of<CityProvider>(
                  context,
                  listen: false,
                ).fetchData,

                /// Affichage conditionnel selon l'état du chargement.
                child: cityProvider.isLoading
                    /// Loader pendant le chargement des données.
                    ? const DymaLoader()
                    /// Si des villes correspondent à la recherche.
                    : filteredCities.isNotEmpty
                    /// Liste des villes.
                    ? ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (_, i) =>
                            CityCard(city: filteredCities[i]),
                      )
                    /// Message si aucun résultat.
                    : const Text('Aucun résultat'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
