import 'package:flutter/material.dart';
import 'package:plant_app/theme_constants.dart';
import 'package:plant_app/screens/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.kBackgroundColor,
        primaryColor: AppColors.kPrimaryColor,
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: AppColors.kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
