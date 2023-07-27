import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      color: primaryColor,
      child: SizedBox(
        height: 63,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              icon: const Icon(Icons.home),
            ),
            const SizedBox(),
            IconButton(
              onPressed: () {
                pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              icon: const Icon(Icons.bookmark),
            ),
          ],
        ),
      ),
    );
  }
}
