class Planet {

  int kepId;
  String keplerName;
  String planetRadius;
  String distanceFromStar;

  Planet(this.kepId, this.keplerName, this.planetRadius, this.distanceFromStar);

  factory Planet.fromJson(dynamic json) {

    int kepId = json["kepid"];
    String keplerName = json["kepler_name"];
    String planetRadius = json["koi_prad"].toString();
    String distanceFromStar = json["koi_dor"].toString();

    Planet planet = Planet(kepId, keplerName, planetRadius, distanceFromStar);
    return planet;
  }
}