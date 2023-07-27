import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/params/forecast_param.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/feature/weather/domain/use_cases/get_current_weather.dart';
import 'package:weather_app/feature/weather/domain/use_cases/get_forecast_weather.dart';
import 'package:weather_app/feature/weather/presentation/bloc/cw_status.dart';
import 'package:weather_app/feature/weather/presentation/bloc/fw_status.dart';
part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetForecastWeatherUseCase getForecastWeatherUseCase;
  WeatherBloc(this.getCurrentWeatherUseCase, this.getForecastWeatherUseCase)
      : super(WeatherState(cwStatus: CwLoading(), fwStatus: FwLoading())) {
    on<LoadCwEvent>((event, emit) async {
      emit(state.copyWith(newCwStatus: CwLoading()));
      final DataState dataState = await getCurrentWeatherUseCase(event.cityName);

      if (dataState is DataSuccess) {
        emit(state.copyWith(newCwStatus: CwCompleted(dataState.data)));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newCwStatus: CwError(dataState.error!)));
      }
    });

    /// load 7 days Forecast weather for city Event
    on<LoadFwEvent>((event, emit) async {
      /// emit State to Loading for just Fw
      emit(state.copyWith(newFwStatus: FwLoading()));

      final DataState dataState =
          await getForecastWeatherUseCase(event.forecastParams);

      /// emit State to Completed for just Fw
      if (dataState is DataSuccess) {
        emit(state.copyWith(newFwStatus: FwCompleted(dataState.data)));
      }

      /// emit State to Error for just Fw
      if (dataState is DataFailed) {
        emit(state.copyWith(newFwStatus: FwError(dataState.error)));
      }
    });
  }
}
