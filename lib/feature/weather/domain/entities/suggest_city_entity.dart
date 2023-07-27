import 'package:equatable/equatable.dart';
import 'package:weather_app/feature/weather/data/models/suggest_city_model.dart';

class SuggestCityEntity extends Equatable{
  final List<Data>? data;
  final Metadata? metadata;


  const SuggestCityEntity({this.data, this.metadata});

  @override
  List<Object?> get props => [
    data,
    metadata,
  ];

  @override
  bool? get stringify => true;
}
