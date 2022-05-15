import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/planet.dart';

// todo: Can multiple classes be put in the same file?
class PlanetRowHeader extends StatelessWidget {
  final Planet planet;
  const PlanetRowHeader({required this.planet, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class PlanetChildren extends StatelessWidget {
  final Planet planet;
  const PlanetChildren({required this.planet, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String status = planet.planetStatus;
    String radius = planet.planetRadius.toString();
    String distanceFromStar = planet.distanceFromStar;
    String planetTemperature = planet.planetTemperature;

    Widget planetStatusWidget = Text("Status: $status");
    Widget planetRadiusWidget = Text("Radius: $radius RE");
    Widget distanceFromStarWidget = Text("Distance from star: $distanceFromStar pc");
    Widget planetTemperatureWidget = Text("Temperature: $planetTemperature K");

    Widget alignColumnWidget = Align(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              planetStatusWidget,
              planetRadiusWidget,
              distanceFromStarWidget,
              planetTemperatureWidget
            ]
        ),
        alignment: Alignment.topLeft
    );

    return alignColumnWidget;
  }
}

class PlanetRow extends StatelessWidget {
  final Planet planet;
  const PlanetRow({required this.planet, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: PlanetRowHeader(planet: planet),
        childrenPadding: const EdgeInsets.all(10.0),
        children: [PlanetChildren(planet: planet)],
      ),
    );
  }
}
