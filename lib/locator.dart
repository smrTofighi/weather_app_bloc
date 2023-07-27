import 'package:get_it/get_it.dart';
import 'package:weather_app/feature/bookmark/data/data_source/local/database.dart';
import 'package:weather_app/feature/bookmark/data/repository/city_repositoryimpl.dart';
import 'package:weather_app/feature/bookmark/domain/repository/city_repository.dart';
import 'package:weather_app/feature/bookmark/domain/use_cases/delete_city.dart';
import 'package:weather_app/feature/bookmark/domain/use_cases/get_all_city.dart';
import 'package:weather_app/feature/bookmark/domain/use_cases/get_city.dart';
import 'package:weather_app/feature/bookmark/domain/use_cases/save_city.dart';
import 'package:weather_app/feature/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather_app/feature/weather/data/data_source/remote/api_provider.dart';
import 'package:weather_app/feature/weather/data/repository/weather_repository_impl.dart';
import 'package:weather_app/feature/weather/domain/repository/weather_repository.dart';
import 'package:weather_app/feature/weather/domain/use_cases/get_current_weather.dart';
import 'package:weather_app/feature/weather/domain/use_cases/get_forecast_weather.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_bloc.dart';


GetIt locator = GetIt.instance;

Future<void> setup() async {
  locator.registerSingleton<ApiProvider>(ApiProvider());

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  locator.registerSingleton<AppDatabase>(database);

  // inject Repositories
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));
  locator.registerSingleton<CityRepository>(CityRepositoryImpl(database.cityDao));

  // inject UseCases
  locator.registerSingleton<GetCurrentWeatherUseCase>(GetCurrentWeatherUseCase(locator()));
  locator.registerSingleton<GetForecastWeatherUseCase>(GetForecastWeatherUseCase(locator()));
  locator.registerSingleton<SaveCityUseCase>(SaveCityUseCase(locator()));
  locator.registerSingleton<GetAllCityUseCase>(GetAllCityUseCase(locator()));
  locator.registerSingleton<GetCityUseCase>(GetCityUseCase(locator()));
  locator.registerSingleton<DeleteCityUseCase>(DeleteCityUseCase(locator()));

  locator.registerSingleton<BookmarkBloc>(BookmarkBloc(locator(),locator(),locator(),locator()));
  locator.registerSingleton<WeatherBloc>(WeatherBloc(locator(),locator()));
  //locator.registerSingleton<BottomIconCubit>(BottomIconCubit());
  // locator.registerLazySingleton<Dio>(() => Dio());

// Alternatively you could write it if you don't like global variables
//   GetIt.I.registerSingleton<AppModel>(AppModel());
}
