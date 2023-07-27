part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class LoadCwEvent extends WeatherEvent {
  final String cityName;

  const LoadCwEvent(this.cityName);
}

class LoadFwEvent extends WeatherEvent {
  final ForecastParams forecastParams;
  const LoadFwEvent(this.forecastParams);
}
