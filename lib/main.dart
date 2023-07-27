import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/presentation/main_wrapper.dart';
import 'package:weather_app/feature/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/locator.dart';

void main() async {
  //* init locator
  await setup();
  runApp(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => locator<WeatherBloc>(),
          ),
          BlocProvider(
            create: (context) => locator<BookmarkBloc>(),
          ),
        ],
        child: MainWrapper(),
      ),
    ),
  );
}
