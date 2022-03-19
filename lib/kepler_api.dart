import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'database/planet.dart';
class KeplerApi {

  final String _baseAddress = "exoplanetarchive.ipac.caltech.edu";
  final String _unencodedPath = "/cgi-bin/nstedAPI/nph-nstedAPI";
  final Map<String, String> _headers = {"Content-Type" : "application/json"};

  KeplerApi();

  Future<List<Planet>> _doHttpsRequest(Map<String, String> params) async {

    // doing request
    Uri url = Uri.https(_baseAddress, _unencodedPath, params);
    http.Response requestResults = await http.get(url, headers: _headers);

    List<Planet> planets = [];

    // parsing results to json
    String data = requestResults.body;
    List<dynamic> rawDataList = jsonDecode(data);
    for (dynamic rawData in rawDataList) {
      Planet planet = Planet.fromJson(rawData);
      planets.add(planet);
    }
    return planets;
  }

  Future<List<Planet>> getDataOfAllPlanets() async {

    // params to search in API
    Map<String, String> params = {
      "table" : "cumulative",
      "format" : "json",
      "select" : "kepid,kepler_name,koi_prad,koi_dor,koi_pdisposition",
      "where" : "kepler_name is not null"
    };

    List<Planet> planets = await _doHttpsRequest(params);
    return planets;
  }

  Future<List<Planet>> getDataOfSinglePlanet(String planetName) async {

    // params to search in API
    Map<String, String> params = {
      "table" : "cumulative",
      "where" : "kepler_name like '$planetName'",
      "format" : "json",
    };

    List<Planet> planets = await _doHttpsRequest(params);
    return planets;
  }

}