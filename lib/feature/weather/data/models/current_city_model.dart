// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:weather_app/feature/weather/domain/entities/current_city_entity.dart';

class CurrentCityModel extends CurrentCityEntity {
  const CurrentCityModel({
    Coord? coord,
    List<Weather>? weather,
    String? base,
    Main? main,
    int? visibility,
    Wind? wind,
    Rain? rain,
    Clouds? clouds,
    int? dt,
    Sys? sys,
    int? timezone,
    int? id,
    String? name,
    int? cod,
  }) : super(
          coord: coord,
          weather: weather,
          base: base,
          main: main,
          visibility: visibility,
          wind: wind,
          rain: rain,
          clouds: clouds,
          dt: dt,
          sys: sys,
          timezone: timezone,
          id: id,
          name: name,
          cod: cod,
        );

  factory CurrentCityModel.fromJson(Map<String, dynamic> json) {
    final List<Weather> weather = [];
    if (json["weather"] != null) {
      json["weather"].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }

    return CurrentCityModel(
      coord: json["coord"] == null ? null : Coord.fromJson(json["coord"]),
      weather: weather,
      base: json["base"],
      main: json["main"] == null ? null : Main.fromJson(json["main"]),
      visibility: json["visibility"],
      wind: json["wind"] == null ? null : Wind.fromJson(json["wind"]),
      rain: json["rain"] == null ? null : Rain.fromJson(json["rain"]),
      clouds: json["clouds"] == null ? null : Clouds.fromJson(json["clouds"]),
      dt: json["dt"],
      sys: json["sys"] == null ? null : Sys.fromJson(json["sys"]),
      timezone: json["timezone"],
      id: json["id"],
      name: json["name"],
      cod: json["cod"],
    );
  }
}

class Sys {
  int? type;
  int? id;
  String? country;
  int? sunrise;
  int? sunset;

  Sys({this.type, this.id, this.country, this.sunrise, this.sunset});

  Sys.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    id = json["id"];
    country = json["country"];
    sunrise = json["sunrise"];
    sunset = json["sunset"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["type"] = type;
    _data["id"] = id;
    _data["country"] = country;
    _data["sunrise"] = sunrise;
    _data["sunset"] = sunset;
    return _data;
  }
}

class Clouds {
  int? all;

  Clouds({this.all});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = json["all"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["all"] = all;
    return _data;
  }
}

class Rain {
  double? h1;

  Rain({this.h1});

  Rain.fromJson(Map<String, dynamic> json) {
    h1 = json["1h"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["1h"] = h1;
    return _data;
  }
}

class Wind {
  double? speed;
  int? deg;
  double? gust;

  Wind({this.speed, this.deg, this.gust});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json["speed"];
    deg = json["deg"];
    gust = json["gust"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["speed"] = speed;
    _data["deg"] = deg;
    _data["gust"] = gust;
    return _data;
  }
}

class Main {
  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? pressure;
  int? humidity;
  int? seaLevel;
  int? grndLevel;

  Main(
      {this.temp,
      this.feelsLike,
      this.tempMin,
      this.tempMax,
      this.pressure,
      this.humidity,
      this.seaLevel,
      this.grndLevel});

  Main.fromJson(Map<String, dynamic> json) {
    temp = json["temp"];
    feelsLike = json["feels_like"];
    tempMin = json["temp_min"];
    tempMax = json["temp_max"];
    pressure = json["pressure"];
    humidity = json["humidity"];
    seaLevel = json["sea_level"];
    grndLevel = json["grnd_level"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["temp"] = temp;
    _data["feels_like"] = feelsLike;
    _data["temp_min"] = tempMin;
    _data["temp_max"] = tempMax;
    _data["pressure"] = pressure;
    _data["humidity"] = humidity;
    _data["sea_level"] = seaLevel;
    _data["grnd_level"] = grndLevel;
    return _data;
  }
}

class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    main = json["main"];
    description = json["description"];
    icon = json["icon"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["main"] = main;
    _data["description"] = description;
    _data["icon"] = icon;
    return _data;
  }
}

class Coord {
  double? lon;
  double? lat;

  Coord({this.lon, this.lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json["lon"];
    lat = json["lat"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["lon"] = lon;
    _data["lat"] = lat;
    return _data;
  }
}
