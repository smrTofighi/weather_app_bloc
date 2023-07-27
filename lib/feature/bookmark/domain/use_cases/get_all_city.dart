import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/core/usecase/use_case.dart';
import 'package:weather_app/feature/bookmark/domain/entities/city_entity.dart';
import 'package:weather_app/feature/bookmark/domain/repository/city_repository.dart';

class GetAllCityUseCase implements UseCase<DataState<List<City>>, NoParams> {
  final CityRepository _cityRepository;
  GetAllCityUseCase(this._cityRepository);

  @override
  Future<DataState<List<City>>> call(NoParams params) {
    return _cityRepository.getAllCityFromDB();
  }
}
