import 'package:example_cpl/blocs/do_planet_search.dart';
import '../database/planet.dart';

class PlanetSearchHelper {
  List<Planet> planets;
  SearchStatus status;

  PlanetSearchHelper({required this.planets, required this.status});
}