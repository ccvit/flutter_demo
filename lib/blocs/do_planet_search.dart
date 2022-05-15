import '../database/planet.dart';
import 'bloc_event.dart';

enum SearchStatus {loading, complete, unknown}

class DoPlanetSearch extends BlocEvent {
  String searchTerm;
  List<Planet> planets;
  DoPlanetSearch({required this.searchTerm, required this.planets});
}