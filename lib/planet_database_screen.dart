import 'package:example_cpl/blocs/kepler_bloc.dart';
import 'package:example_cpl/helpers/planet_search_helper.dart';
import 'package:example_cpl/widgets/loading_widget.dart';
import 'package:example_cpl/widgets/planet_row.dart';
import 'package:example_cpl/widgets/search_text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/do_planet_search.dart';
import 'database/planet.dart';

class PlanetDatabase extends StatefulWidget {
  const PlanetDatabase({Key? key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const PlanetDatabase());
  }
  @override
  State<StatefulWidget> createState() {
    return _PlanetDatabase();
  }
}

class _PlanetDatabase extends State<PlanetDatabase> {

  bool loadingPlanetData = true;
  final TextEditingController _searchController = TextEditingController();
  final KeplerBloc _keplerBloc = KeplerBloc();
  List<Planet> fullPlanetsList = [];

  _PlanetDatabase();

  retrievePlanetData() async {
    DoPlanetSearch doPlanetSearch = DoPlanetSearch(searchTerm: "", planets: []);
    _keplerBloc.add(doPlanetSearch);
  }

  doKeywordPlanetSearch(String searchKey) async {
    DoPlanetSearch doPlanetSearch = DoPlanetSearch(searchTerm: searchKey, planets: fullPlanetsList);
    _keplerBloc.add(doPlanetSearch);
  }

  Widget planetSeparatorBuilder(BuildContext context, pos) {
    return const Divider(color: Colors.grey,);
  }

  Widget buildPlanetDataList(List<Planet> planets) {
    if (planets.isEmpty) {
      return const Center(child: Text("No results"),);
    } else {
      return ListView.separated(
        // putting itemBuilder function in here. No other way to show really.
        itemBuilder: (context, pos) {
          return PlanetRow(planet: planets[pos],);
        },
        separatorBuilder: planetSeparatorBuilder,
        itemCount: planets.length
      );
    }
  }

  Widget buildLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(child: CircularProgressIndicator(),),
      ],
    );
  }

  // todo: see if there is a builder class I can use
  Widget buildPlanetSearchChildren(BuildContext context, PlanetSearchHelper helper) {
    SearchStatus status = helper.status;
    List<Planet> planets = helper.planets;

    Widget centerChild;
    if (status == SearchStatus.complete) {
      centerChild = buildPlanetDataList(planets);
    } else {
      centerChild = const LoadingWidget();
    }
    return Center(
        child: centerChild,
      );
  }

  // todo: boolean checks could be something like this?
  bool searchResultsChanged(List<Planet> newPlanetsList) {
    return newPlanetsList.length > fullPlanetsList.length;
  }

  updatePlanetListIfNeeded(BuildContext context, PlanetSearchHelper helper) {
    List<Planet> newPlanetsList = helper.planets;

    if (searchResultsChanged(newPlanetsList)) {
      fullPlanetsList = List.from(newPlanetsList);
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      title: SearchTextBox(doKeywordPlanetSearch: doKeywordPlanetSearch, searchController: _searchController),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  @override
  void initState() {
    retrievePlanetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(),
      body: BlocListener<KeplerBloc, PlanetSearchHelper>(
        listener: updatePlanetListIfNeeded ,
        bloc: _keplerBloc,
        child: BlocBuilder<KeplerBloc, PlanetSearchHelper>(
          builder: buildPlanetSearchChildren,
          bloc: _keplerBloc,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keplerBloc.close();
    super.dispose();
  }

}
