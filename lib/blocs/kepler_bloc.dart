import 'package:example_cpl/helpers/planet_search_helper.dart';
import 'package:example_cpl/kepler_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/planet.dart';
import 'bloc_event.dart';
import 'do_planet_search.dart';

class KeplerBloc extends Bloc<BlocEvent, PlanetSearchHelper> {
  KeplerBloc() : super(PlanetSearchHelper(planets: [], status: SearchStatus.unknown)) {
    on<DoPlanetSearch>((event, emit) async {
      KeplerApi keplerApi = KeplerApi();
      String searchTerm = event.searchTerm;
      List<Planet> planetsToSearch = List.from(event.planets);

      // if planets are not stored locally yet then retrieve them
      if (planetsToSearch.isEmpty) {
        PlanetSearchHelper initialSearchHelper = PlanetSearchHelper(planets: [], status: SearchStatus.loading);
        emit(initialSearchHelper);

        List<Planet> planets = await keplerApi.getDataOfAllPlanets();

        PlanetSearchHelper planetSearchHelper = PlanetSearchHelper(
            planets: planets,
            status: SearchStatus.complete
        );

        emit(planetSearchHelper);
      } else {
        PlanetSearchHelper initialSearchHelper = PlanetSearchHelper(planets: [], status: SearchStatus.loading);
        emit(initialSearchHelper);

        List<Planet> planets = await keplerApi.getDataOfLocalPlanets(searchTerm, event.planets);

        PlanetSearchHelper planetSearchHelper = PlanetSearchHelper(
            planets: planets,
            status: SearchStatus.complete
        );

        emit(planetSearchHelper);
      }

    });
  }
}