import 'dart:convert';

import 'package:example_cpl/database/planet.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:example_cpl/kepler_api.dart';

void main() {
  group("Kepler API tests", () {
    test("testing getDataOfAllPlanets()", () async {
      final KeplerApi keplerApi = KeplerApi();
      int expectedLength = 2670;
      List<Planet> planets = await keplerApi.getDataOfAllPlanets();
      int returnLength = planets.length;

      expect(returnLength, expectedLength);
    });

    test("testing doGetDataOfLocalPlanetsTest", () async {
      final KeplerApi keplerApi = KeplerApi();

      const String searchKey = "kepler-227 b";
      List<Planet> planets = await keplerApi.getDataOfAllPlanets();

      List<Planet> searchResult = await keplerApi.getDataOfLocalPlanets(searchKey, planets);

      expect(searchResult[0].keplerName, "Kepler-227 b");
      expect(searchResult.length, 1);
    });
  });

  test("testing Planet.fromJson", () {
    String jsonString = '{"kepid": 10122538, "kepler_name": "Kepler-1388 e", "koi_prad": 2.25, "koi_dor": 62.8, "koi_pdisposition": "CANDIDATE", "koi_teq": 299.0}';
    dynamic jsonObject = jsonDecode(jsonString);

    String expectedName = "Kepler-1388 e";
    int expectedKepId = 10122538;
    Planet planet = Planet.fromJson(jsonObject);

    expect(planet.keplerName, expectedName);
    expect(planet.kepId, expectedKepId);
  });




}