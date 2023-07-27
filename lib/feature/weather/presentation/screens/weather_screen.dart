import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/core/params/forecast_param.dart';
import 'package:weather_app/core/utils/date_converter.dart';
import 'package:weather_app/core/widgets/app_background.dart';
import 'package:weather_app/core/widgets/loading_dot_triangle.dart';
import 'package:weather_app/feature/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather_app/feature/weather/data/models/forecast_days_model.dart';
import 'package:weather_app/feature/weather/data/models/suggest_city_model.dart';
import 'package:weather_app/feature/weather/domain/entities/current_city_entity.dart';
import 'package:weather_app/feature/weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_app/feature/weather/domain/use_cases/get_suggest_city.dart';
import 'package:weather_app/feature/weather/presentation/bloc/cw_status.dart';
import 'package:weather_app/feature/weather/presentation/bloc/fw_status.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/feature/weather/presentation/widgets/bookmark_icon.dart';
import 'package:weather_app/feature/weather/presentation/widgets/day_weather_view.dart';
import 'package:weather_app/locator.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with AutomaticKeepAliveClientMixin {
  String cityName = 'Darab';
  final PageController _pageController = PageController();
  TextEditingController textEditingController = TextEditingController();
  GetSuggestionCityUseCase getSuggestionCityUseCase =
      GetSuggestionCityUseCase(locator());
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WeatherBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: Row(
              children: [
                /// Search Box
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      onSubmitted: (String prefix) {
                        textEditingController.text = prefix;
                        BlocProvider.of<WeatherBloc>(context)
                            .add(LoadCwEvent(prefix));
                      },
                      controller: textEditingController,
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: size.height * 0.02,
                            color: Colors.white,
                          ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                          20,
                          size.height * 0.02,
                          0,
                          size.height * 0.02,
                        ),
                        hintText: "Enter a City...",
                        hintStyle: const TextStyle(color: Colors.white),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    suggestionsCallback: (String prefix) async {
                      return getSuggestionCityUseCase(prefix);
                    },
                    itemBuilder: (context, Data model) {
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(model.name!),
                        subtitle: Text("${model.region!}, ${model.country!}"),
                      );
                    },
                    onSuggestionSelected: (Data model) {
                      textEditingController.text = model.name!;
                      BlocProvider.of<WeatherBloc>(context)
                          .add(LoadCwEvent(model.name!));
                    },
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                /// bookmark Icon
                BlocBuilder<WeatherBloc, WeatherState>(
                  buildWhen: (previous, current) {
                    if (previous.cwStatus == current.cwStatus) {
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    /// show Loading State for Cw
                    if (state.cwStatus is CwLoading) {
                      return const CircularProgressIndicator();
                    }

                    /// show Error State for Cw
                    if (state.cwStatus is CwError) {
                      return IconButton(
                        onPressed: () {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text("please load a city!"),
                          //   behavior: SnackBarBehavior.floating, // Add this line
                          // ));
                        },
                        icon: const Icon(
                          Icons.error,
                          color: Colors.white,
                          size: 35,
                        ),
                      );
                    }

                    /// show Completed State for Cw
                    if (state.cwStatus is CwCompleted) {
                      final CwCompleted cwComplete =
                          state.cwStatus as CwCompleted;
                      BlocProvider.of<BookmarkBloc>(context).add(
                        GetCityByNameEvent(
                          cwComplete.currentCityEntity.name!,
                        ),
                      );
                      return BookMarkIcon(
                        name: cwComplete.currentCityEntity.name!,
                      );
                    }

                    /// show Default value
                    return Container();
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<WeatherBloc, WeatherState>(
            buildWhen: (previous, current) {
              if (previous.cwStatus == current.cwStatus) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state.cwStatus is CwLoading) {
                return const Expanded(
                  child: LoadingDotTriangle(),
                );
              }
              if (state.cwStatus is CwCompleted) {
                final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
                final CurrentCityEntity currentCityEntity =
                    cwCompleted.currentCityEntity;
                //? create params for api call
                final ForecastParams forecastParams = ForecastParams(
                  currentCityEntity.coord!.lat!,
                  currentCityEntity.coord!.lon!,
                );
                BlocProvider.of<WeatherBloc>(context)
                    .add(LoadFwEvent(forecastParams));

                /// change Times to Hour --5:55 AM/PM----
                final sunrise = DateConverter.changeDtToDateTimeHour(
                  currentCityEntity.sys!.sunrise,
                  currentCityEntity.timezone,
                );
                final sunset = DateConverter.changeDtToDateTimeHour(
                  currentCityEntity.sys!.sunset,
                  currentCityEntity.timezone,
                );
                return Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        child: SizedBox(
                          width: double.infinity,
                          height: 400,
                          child: PageView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            allowImplicitScrolling: true,
                            controller: _pageController,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: Text(
                                        currentCityEntity.name!,
                                        style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        currentCityEntity
                                            .weather![0].description!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: AppBackground.setIconForMain(
                                        currentCityEntity
                                            .weather![0].description!,
                                        60.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        "${currentCityEntity.main!.temp!.round()}\u00B0",
                                        style: const TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //? max temp
                                        Column(
                                          children: [
                                            const Text(
                                              'Max',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${currentCityEntity.main!.tempMax!.round()}\u00B0",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),

                                        //? divider
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          color: Colors.grey,
                                          width: 2,
                                          height: 40,
                                        ),

                                        //? min temp
                                        Column(
                                          children: [
                                            const Text(
                                              'Min',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${currentCityEntity.main!.tempMin!.round()}\u00B0",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              } else {
                                return Container(
                                  color: Colors.amber,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //? page view indicator
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: 2,
                          effect: const ExpandingDotsEffect(
                            dotWidth: 10,
                            dotHeight: 10,
                            spacing: 5,
                            activeDotColor: Colors.white,
                          ),
                          onDotClicked: (index) =>
                              _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          ),
                        ),
                      ),

                      /// divider
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          color: Colors.white24,
                          height: 2,
                          width: double.infinity,
                        ),
                      ),

                      SizedBox(
                        height: size.height * 0.01,
                      ),

                      /// forecast weather 7 days
                      SizedBox(
                        width: double.infinity,
                        height: size.height * 0.13,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Center(
                            child: BlocBuilder<WeatherBloc, WeatherState>(
                              builder: (BuildContext context, state) {
                                /// show Loading State for Fw
                                if (state.fwStatus is FwLoading) {
                                  return const LoadingDotTriangle();
                                }

                                /// show Completed State for Fw
                                if (state.fwStatus is FwCompleted) {
                                  /// casting
                                  final FwCompleted fwCompleted =
                                      state.fwStatus as FwCompleted;
                                  final ForecastDaysEntity forecastDaysEntity =
                                      fwCompleted.forecastDaysEntity;
                                  final List<Daily> mainDaily =
                                      forecastDaysEntity.daily!;

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 8,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      return DaysWeatherView(
                                        daily: mainDaily[index],
                                      );
                                    },
                                  );
                                }

                                /// show Error State for Fw
                                if (state.fwStatus is FwError) {
                                  final FwError fwError =
                                      state.fwStatus as FwError;
                                  return Center(
                                    child: Text(fwError.message!),
                                  );
                                }

                                /// show Default State for Fw
                                return Container();
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          color: Colors.white24,
                          height: 2,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "wind speed",
                                  style: TextStyle(
                                    fontSize: size.height * 0.017,
                                    color: Colors.amber,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "${currentCityEntity.wind!.speed!} m/s",
                                    style: TextStyle(
                                      fontSize: size.height * 0.016,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                color: Colors.white24,
                                height: 30,
                                width: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "sunrise",
                                    style: TextStyle(
                                      fontSize: size.height * 0.017,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      sunrise,
                                      style: TextStyle(
                                        fontSize: size.height * 0.016,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                color: Colors.white24,
                                height: 30,
                                width: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "sunset",
                                    style: TextStyle(
                                      fontSize: size.height * 0.017,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      sunset,
                                      style: TextStyle(
                                        fontSize: size.height * 0.016,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                color: Colors.white24,
                                height: 30,
                                width: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "humidity",
                                    style: TextStyle(
                                      fontSize: size.height * 0.017,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "${currentCityEntity.main!.humidity!}%",
                                      style: TextStyle(
                                        fontSize: size.height * 0.016,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state.cwStatus is CwError) {
                return const SizedBox(
                  child: Center(
                    child: Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
