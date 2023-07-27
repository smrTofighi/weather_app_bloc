import 'package:weather_app/core/params/forecast_param.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/core/usecase/use_case.dart';
import 'package:weather_app/feature/weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_app/feature/weather/domain/repository/weather_repository.dart';

class GetForecastWeatherUseCase implements UseCase<DataState<ForecastDaysEntity>, ForecastParams>{
  final WeatherRepository _weatherRepository;
  GetForecastWeatherUseCase(this._weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call(ForecastParams params) {
    return _weatherRepository.fetchForecastWeatherData(params);
  }

}
