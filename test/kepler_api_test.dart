import 'package:example_cpl/database/planet.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:example_cpl/kepler_api.dart';

void main() {
  test("testing doGetDataOfLocalPlanetsTest", () async {
    final KeplerApi keplerApi = KeplerApi();

    const String searchKey = "kepler-227 b";
    List<Planet> planets = await keplerApi.getDataOfAllPlanets();

    List<Planet> searchResult = await keplerApi.getDataOfLocalPlanets(searchKey, planets);
    if (kDebugMode) {
      print(searchResult[0].keplerName);
    }

    expect(searchResult[0].keplerName, "Kepler-227 b");
    expect(searchResult.length, 1);
  });
}