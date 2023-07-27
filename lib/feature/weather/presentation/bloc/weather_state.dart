part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final FwStatus fwStatus;
  final CwStatus cwStatus;
  const WeatherState({required this.cwStatus, required this.fwStatus});
  WeatherState copyWith({CwStatus? newCwStatus, FwStatus? newFwStatus}) {
    return WeatherState(cwStatus: newCwStatus ?? cwStatus, fwStatus: newFwStatus?? fwStatus);
  }

  @override
  List<Object?> get props => [cwStatus, fwStatus];
}
