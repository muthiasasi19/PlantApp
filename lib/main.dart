import 'package:flutter/material.dart';
import 'package:plant_app/theme_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/screens/home/home_screen.dart';
import 'package:plant_app/bloc/camera_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CameraBloc()..add(InitializeCamera()),
      child: MaterialApp(
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
      ),
    );
  }
}
