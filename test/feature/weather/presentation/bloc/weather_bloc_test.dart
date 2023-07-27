
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/params/forecast_param.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/feature/weather/domain/entities/current_city_entity.dart';
import 'package:weather_app/feature/weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_app/feature/weather/domain/use_cases/get_current_weather.dart';
import 'package:weather_app/feature/weather/domain/use_cases/get_forecast_weather.dart';
import 'package:weather_app/feature/weather/presentation/bloc/cw_status.dart';
import 'package:weather_app/feature/weather/presentation/bloc/fw_status.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_bloc.dart';
import 'weather_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentWeatherUseCase,GetForecastWeatherUseCase])
void main(){
  late WeatherBloc weatherBloc;
  MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
  MockGetForecastWeatherUseCase mockGetForecastWeatherUseCase = MockGetForecastWeatherUseCase();

  setUp((){
    weatherBloc = WeatherBloc(mockGetCurrentWeatherUseCase, mockGetForecastWeatherUseCase);
  });

  tearDown(() {
    weatherBloc.close();
  });


  String cityName = 'Tehran';
  String error = 'error';

  group('Cw Event test', () {
    /// First Way
    when(mockGetCurrentWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(const DataSuccess(CurrentCityEntity())));

    blocTest<WeatherBloc, WeatherState>(
      'emit Loading and Completed state',
      build: () => WeatherBloc(mockGetCurrentWeatherUseCase,mockGetForecastWeatherUseCase),
      act: (bloc) {
        bloc.add(LoadCwEvent(cityName));
      },
      expect: () => <WeatherState>[
        WeatherState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        WeatherState(cwStatus: CwCompleted(const CurrentCityEntity()), fwStatus: FwLoading()),
      ],
    );


    /// Second Way
    test('emit Loading and Error state', () {
      when(mockGetCurrentWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

      final bloc = WeatherBloc(mockGetCurrentWeatherUseCase,mockGetForecastWeatherUseCase);
      bloc.add(LoadCwEvent(cityName));

      expectLater(bloc.stream,emitsInOrder([
        WeatherState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        WeatherState(cwStatus: CwError(error), fwStatus: FwLoading()),
      ]));
    });
  });


  group('Fw Event test', () {
    ForecastParams forecastParams = ForecastParams(35.715298, 51.404343);
    when(mockGetForecastWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(const DataSuccess(ForecastDaysEntity())));

    blocTest<WeatherBloc, WeatherState>(
      'emit Loading and Completed state',
      build: () => WeatherBloc(mockGetCurrentWeatherUseCase,mockGetForecastWeatherUseCase),
      act: (bloc) {
        bloc.add(LoadFwEvent(forecastParams));
      },
      expect: () => <WeatherState>[
        WeatherState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        WeatherState(cwStatus: CwLoading(), fwStatus: FwCompleted(const ForecastDaysEntity())),
      ],

    );


    test('emit Loading and Error state', () {
      when(mockGetForecastWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

      final bloc = WeatherBloc(mockGetCurrentWeatherUseCase,mockGetForecastWeatherUseCase);
      bloc.add(LoadFwEvent(forecastParams));

      expectLater(bloc.stream,emitsInOrder([
        WeatherState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        WeatherState(cwStatus: CwLoading(), fwStatus: FwError(error)),
      ]));
    });
  });
}