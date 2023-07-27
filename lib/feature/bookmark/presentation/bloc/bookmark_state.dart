part of 'bookmark_bloc.dart';

class BookmarkState extends Equatable{
  final GetAllCityStatus getAllCityStatus;
  final GetCityStatus getCityStatus;
  final SaveCityStatus saveCityStatus;
  final DeleteCityStatus deleteCityStatus;

  const BookmarkState({
    required this.getAllCityStatus,
    required this.getCityStatus,
    required this.saveCityStatus,
    required this.deleteCityStatus,
  });

  BookmarkState copyWith({
    GetAllCityStatus? newAllCityStatus,
    GetCityStatus? newCityStatus,
    SaveCityStatus? newSaveStatus,
    DeleteCityStatus? newDeleteStatus,
  }){
    return BookmarkState(
        getAllCityStatus: newAllCityStatus ?? getAllCityStatus,
        getCityStatus: newCityStatus ?? getCityStatus,
        saveCityStatus: newSaveStatus ?? saveCityStatus,
        deleteCityStatus: newDeleteStatus ?? deleteCityStatus,
    );
  }

  @override
  List<Object?> get props => [
    getAllCityStatus,
    getCityStatus,
    saveCityStatus,
    deleteCityStatus,
  ];
}
