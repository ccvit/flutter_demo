import 'package:example_cpl/kepler_api.dart';
import 'package:flutter/material.dart';

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
  List<Planet> planetsList = [];
  // List of planets to display.
  List<Planet> planetsListToDisplay = [];
  final TextEditingController _searchController = TextEditingController();
  _PlanetDatabase();

  retrievePlanetData() async {
    KeplerApi keplerApi = KeplerApi();
    planetsList = await keplerApi.getDataOfAllPlanets();
    planetsListToDisplay = List.from(planetsList);
    loadingPlanetData = false;
    setState((){});
  }

  initKeywordPlanetSearch(String searchKey) {
    setState(() {
      loadingPlanetData = true;
      doKeywordPlanetSearch(searchKey);
    });
  }

  doKeywordPlanetSearch(String searchKey) async {
    planetsListToDisplay.clear();
    for (Planet planet in planetsList) {
      String planetName = planet.keplerName.toLowerCase();
      if (planetName.contains(searchKey.toLowerCase())) {
        planetsListToDisplay.add(planet);
      }
    }
    setState(() {
      loadingPlanetData = false;
    });
  }

  Widget buildSearchTextBox() {
    return TextField(
      autofocus: false,
        controller: _searchController,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: "Search ...",
        ),
      onSubmitted: initKeywordPlanetSearch,
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

  Widget planetItemBuilder(BuildContext context, pos) {
    return buildPlanetRow(planetsListToDisplay[pos]);
  }

  Widget planetSeparatorBuilder(BuildContext context, pos) {
    return const Divider(color: Colors.grey,);
  }

  Widget buildPlanetDataList() {
    if (planetsListToDisplay.isEmpty) {
      return const Center(child: Text("No results"),);
    } else {
      return ListView.separated(
          itemBuilder: planetItemBuilder,
          separatorBuilder: planetSeparatorBuilder,
          itemCount: planetsListToDisplay.length
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

    Widget centerChild;
    if (loadingPlanetData) {
      centerChild = buildLoadingWidget();
    } else {
      centerChild = buildPlanetDataList();
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
        child: centerChild,
      ),
    );
  }

}
