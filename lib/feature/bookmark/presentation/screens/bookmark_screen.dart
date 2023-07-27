import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/feature/bookmark/domain/entities/city_entity.dart';
import 'package:weather_app/feature/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather_app/feature/bookmark/presentation/bloc/get_all_city_status.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_bloc.dart';

class BookmarkScreen extends StatefulWidget {
  final PageController pageController;

  const BookmarkScreen({super.key, required this.pageController});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<BookmarkBloc>(context).add(GetAllCityEvent());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        buildWhen: (previous, current) {
          /// rebuild UI just when allCityStatus Changed
          if (current.getAllCityStatus == previous.getAllCityStatus) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          /// show Loading for AllCityStatus
          if (state.getAllCityStatus is GetAllCityLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// show Completed for AllCityStatus
          if (state.getAllCityStatus is GetAllCityCompleted) {
            /// casting for getting cities
            final GetAllCityCompleted getAllCityCompleted =
                state.getAllCityStatus as GetAllCityCompleted;
            final List<City> cities = getAllCityCompleted.cities;

            return SafeArea(
              child: Column(
                children: [
                  const Text(
                    'WatchList',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    /// show text in center if there is no city bookmarked
                    child: (cities.isEmpty)
                        ? const Center(
                            child: Text(
                              'there is no bookmark city',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            itemCount: cities.length,
                            itemBuilder: (context, index) {
                              final City city = cities[index];
                              return GestureDetector(
                                onTap: () {
                                  /// call for getting bookmarked city Data
                                  BlocProvider.of<WeatherBloc>(context)
                                      .add(LoadCwEvent(city.name));

                                  /// animate to HomeScreen for showing Data
                                  widget.pageController.animateToPage(
                                    0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5.0,
                                        sigmaY: 5.0,
                                      ),
                                      child: Container(
                                        width: width,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Colors.grey.withOpacity(0.1),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                city.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<BookmarkBloc>(
                                                    context,
                                                  ).add(
                                                    DeleteCityEvent(
                                                      city.name,
                                                    ),
                                                  );
                                                  BlocProvider.of<BookmarkBloc>(
                                                    context,
                                                  ).add(GetAllCityEvent());
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          /// show Error for AllCityStatus
          if (state.getAllCityStatus is GetAllCityError) {
            /// casting for getting Error
            final GetAllCityError getAllCityError =
                state.getAllCityStatus as GetAllCityError;

            return Center(
              child: Text(getAllCityError.message!),
            );
          }

          /// show Default value
          return Container();
        },
      ),
    );
  }
}
