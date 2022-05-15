class Planet {

  int kepId;
  String planetStatus;
  String keplerName;
  double planetRadius;
  String distanceFromStar;
  String planetImage;
  String planetTemperature;

  Planet({
    required this.planetStatus,
    required this.kepId,
    required this.keplerName,
    required this.planetRadius,
    required this.distanceFromStar,
    required this.planetImage,
    required this.planetTemperature
  });

  factory Planet.fromJson(dynamic json) {
    String _getPlanetImage(double planetRadius) {
      if (planetRadius < 3.0) {
        return "assets/kepler_small.png";
      } else if (planetRadius < 7.0) {
        return "assets/kepler_medium.png";
      } else {
        return "assets/kepler_large.png";
      }
    }

    int kepId = json["kepid"];
    String planetStatus = json["koi_pdisposition"] ?? "UNKNOWN";
    String keplerName = json["kepler_name"];
    double planetRadius = json["koi_prad"] != null? json["koi_prad"].toDouble() : 0.0;
    String distanceFromStar = json["koi_dor"].toString();
    String planetImage = _getPlanetImage(planetRadius);
    String planetTemperature = json["koi_teq"].toString();

    Planet planet = Planet(
        kepId: kepId,
        planetStatus: planetStatus,
        keplerName: keplerName,
        planetRadius: planetRadius,
        distanceFromStar: distanceFromStar,
        planetImage: planetImage,
        planetTemperature: planetTemperature
    );

    return planet;
  }
}