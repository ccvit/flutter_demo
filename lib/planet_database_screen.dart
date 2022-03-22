import 'package:example_cpl/blocs/kepler_bloc.dart';
import 'package:example_cpl/helpers/planet_search_helper.dart';
import 'package:example_cpl/kepler_api.dart';
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
    // ignore: no_logic_in_create_state
    return _PlanetDatabase();
  }
}

class _PlanetDatabase extends State<PlanetDatabase> {

  bool loadingPlanetData = true;
  // Full list of planets
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

  Widget buildSearchTextBox() {
    return TextField(
      autofocus: false,
        controller: _searchController,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: "Search ...",
        ),
      onSubmitted: doKeywordPlanetSearch,
    );
  }

  Widget buildPlanetRowHeader(Planet planet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(planet.planetImage, height: 50.0),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(planet.keplerName),
        ),
      ]
    );
  }

  Widget buildPlanetChildren(Planet planet) {
    String status = planet.planetStatus;
    String radius = planet.planetRadius.toString();
    String distanceFromStar = planet.distanceFromStar;
    String planetTemperature = planet.planetTemperature;

    Widget planetStatusWidget = Text("Status: $status");
    Widget planetRadiusWidget = Text("Radius: $radius RE");
    Widget distanceFromStarWidget = Text("Distance from star: $distanceFromStar pc");
    Widget planetTemperatureWidget = Text("Temperature: $planetTemperature K");

    // I want the children to start at the left, so adding cross Axis Alignment
    Widget columnForChildren = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        planetStatusWidget,
        planetRadiusWidget,
        distanceFromStarWidget,
        planetTemperatureWidget
      ]
    );

    Widget alignColumnWidget = Align(
      child: columnForChildren,
      alignment: Alignment.topLeft
    );

    return alignColumnWidget;
  }

  Widget buildPlanetRow(Planet planet) {
    // added theme to removed expanded divider.
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: buildPlanetRowHeader(planet),
        childrenPadding: const EdgeInsets.all(10.0),
        children: [buildPlanetChildren(planet)],

      ),
    );
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
          return buildPlanetRow(planets[pos]);
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

  Widget buildPlanetSearchChildren(BuildContext context, PlanetSearchHelper helper) {
    SearchStatus status = helper.status;
    List<Planet> planets = helper.planets;

    Widget centerChild;
    if (status == SearchStatus.complete) {
      centerChild = buildPlanetDataList(planets);
    } else {
      centerChild = buildLoadingWidget();
    }
    return Center(
        child: centerChild,
      );
    }

  updatePlanetListIfNeeded(BuildContext context, PlanetSearchHelper helper) {
    List<Planet> newPlanetsList = helper.planets;

    // Only change the list if it is a new and different list than previously
    if (newPlanetsList.length > fullPlanetsList.length) {
      // I want to make a copy not just reassign.
      fullPlanetsList = List.from(newPlanetsList);
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      title: buildSearchTextBox(),
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
        listener:updatePlanetListIfNeeded ,
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
