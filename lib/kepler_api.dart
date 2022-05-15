import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database/planet.dart';

class KeplerApi {

  final String _baseAddress = "exoplanetarchive.ipac.caltech.edu";
  final String _unencodedPath = "/cgi-bin/nstedAPI/nph-nstedAPI";
  final Map<String, String> _headers = {"Content-Type" : "application/json"};

  KeplerApi();

  Future<List<Planet>> _doHttpsRequest(Map<String, String> params) async {

    Uri url = Uri.https(_baseAddress, _unencodedPath, params);
    http.Response requestResults = await http.get(url, headers: _headers);
    List<Planet> planets = [];

    String data = requestResults.body;
    List<dynamic> rawDataList = jsonDecode(data);
    for (dynamic rawData in rawDataList) {
      Planet planet = Planet.fromJson(rawData);
      planets.add(planet);
    }
    return planets;
  }

  Future<List<Planet>> getDataOfAllPlanets() async {

    /*
      params to search in API
      kepid: unique id of the planet.
      kepler_name: name of planet.
      koi_prad: the radius of the planet in Earth Radii.
      koi_dor: distance of planet from its star.
      koi_pdisposition: status of planet (FALSE POSITIVE, NOT DISPOSITIONED, and CANDIDATE).
      koi_teq: temperature of the planet in kelvin.
    */

    Map<String, String> params = {
      "table" : "cumulative",
      "format" : "json",
      "select" : "kepid,kepler_name,koi_prad,koi_dor,koi_pdisposition,koi_teq",
      "where" : "kepler_name is not null"
    };

    List<Planet> planets = await _doHttpsRequest(params);
    return planets;
  }

  Future<List<Planet>> getDataOfLocalPlanets(String searchKey, List<Planet> planets) async {
    List<Planet> newPlanets = [];

    for (Planet planet in planets) {
      String name = planet.keplerName.toLowerCase();
      if (name.contains(searchKey)) {
        newPlanets.add(planet);
      }
    }

    return newPlanets;
  }
}