import 'package:dio/dio.dart';
import 'package:weather_app/core/params/forecast_param.dart';
import 'package:weather_app/core/utils/constant.dart';

class ApiProvider {
  // ignore: unused_field
  final Dio _dio = Dio();

  String apiKey = Constants.apiKeys1;
  Future<dynamic> callCurrentWeather(String cityName) async {
    final response = await _dio.get('${Constants.baseUrl}/data/2.5/weather',
        queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric',},);
    return response;
  }

  //? 7 days forecast api
  Future<dynamic> sendRequest7DaysForecast(ForecastParams params) async {
    final response = await _dio
        .get("${Constants.baseUrl}/data/2.5/onecall", queryParameters: {
      'lat': params.lat,
      'lon': params.lon,
      'exclude': 'minutely,hourly',
      'appid': apiKey,
      'units': 'metric',
    },);
    return response;
  }

  Future<dynamic> sendRequestCitySuggestion(String prefix) async {
    final response = await _dio.get(
        'http://geodb-free-service.wirefreethought.com/v1/geo/cities',
        queryParameters: {'limit': 7, 'offset': 0, 'namePrefix': prefix},);
    return response;
  }
}
