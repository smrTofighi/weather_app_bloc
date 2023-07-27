import 'package:flutter/material.dart';
import 'package:weather_app/core/widgets/app_background.dart';
import 'package:weather_app/core/widgets/bottom_nav.dart';
import 'package:weather_app/feature/bookmark/presentation/screens/bookmark_screen.dart';
import 'package:weather_app/feature/weather/presentation/screens/weather_screen.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final List<Widget> pageViewWidgets = [
      const WeatherScreen(),
      BookmarkScreen(
        pageController: pageController,
      )
    ];
    final Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AppBackground.getBackGroundImage(),
              fit: BoxFit.cover,
            ),
          ),
          height: size.height,
          child: PageView(
            controller: pageController,
            children: pageViewWidgets,
          ),
        ),
        extendBody: true,
        bottomNavigationBar: BottomNav(pageController: pageController),
      ),
    );
  }
}
