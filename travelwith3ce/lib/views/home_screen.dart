import 'package:flutter/material.dart';
import 'package:travelwith3ce/models/home/home_header.dart';
import 'package:travelwith3ce/models/home/search_bar.dart';
import 'package:travelwith3ce/models/home/chips.dart';
import 'package:travelwith3ce/models/home/popular_list.dart';
import 'package:travelwith3ce/models/home/nearby_grid.dart';

import '../dummy.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const HomeHeader(),
            // const SearchBar(),
            const Chips(),
            PopularList(items: popular),
            NearbyGrid(data: nearby),
          ],
        ),
      ),
    );
  }
}