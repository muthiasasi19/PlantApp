import 'package:flutter/material.dart';
import 'package:plant_app/screens/details/details_screen.dart';

import '../../../constants.dart';

class RecomendsPlants extends StatelessWidget {
  const RecomendsPlants({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          RecomendPlantCard(
            image: "assets/images/image_1.png",
            title: "Samantha",
            country: "Russia",
            price: 440,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsScreen()),
              );
            },
          ),
          RecomendPlantCard(
            image: "assets/images/image_2.png",
            title: "Angelica",
            country: "Russia",
            price: 440,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsScreen()),
              );
            },
          ),
          RecomendPlantCard(
            image: "assets/images/image_3.png",
            title: "Samantha",
            country: "Russia",
            price: 440,
            press: () {},
          ),
        ],
      ),
    );
  }
}
