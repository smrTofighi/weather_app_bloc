import 'package:dio/dio.dart';
import 'package:weather_app/core/params/forecast_param.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/feature/weather/data/data_source/remote/api_provider.dart';
import 'package:weather_app/feature/weather/data/models/current_city_model.dart';
import 'package:weather_app/feature/weather/data/models/forecast_days_model.dart';
import 'package:weather_app/feature/weather/data/models/suggest_city_model.dart';
import 'package:weather_app/feature/weather/domain/entities/current_city_entity.dart';
import 'package:weather_app/feature/weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_app/feature/weather/domain/entities/suggest_city_entity.dart';
import 'package:weather_app/feature/weather/domain/repository/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  ApiProvider apiProvider;
  WeatherRepositoryImpl(this.apiProvider);
  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(
      String cityName,) async {
    try {
      final Response response = await apiProvider.callCurrentWeather(cityName);
      if (response.statusCode == 200) {
        final CurrentCityEntity currentCityEntity =
            CurrentCityModel.fromJson(response.data);
        return DataSuccess(currentCityEntity);
      } else {
        return const DataFailed("Somthing Went Wrong! try again ...");
      }
    } catch (e) {
      return const DataFailed('Please Check Your Connection');
    }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(
      ForecastParams params,)async {
    try {
      final Response response = await apiProvider.sendRequest7DaysForecast(params);

      if (response.statusCode == 200) {
        final ForecastDaysEntity forecastDaysEntity =
            ForecastDaysModel.fromJson(response.data);
        return DataSuccess(forecastDaysEntity);
      } else {
        return const DataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      return const DataFailed("please check your connection...");
    }
  }

  @override
  Future<List<Data>> fetchSuggestData(prefix)async {
     final Response response = await apiProvider.sendRequestCitySuggestion(prefix);

    final SuggestCityEntity suggestCityEntity = SuggestCityModel.fromJson(response.data);

    return suggestCityEntity.data!;

  }
}
