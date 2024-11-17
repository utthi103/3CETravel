import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:travelwith3ce/models/roomModel.dart';
import 'package:travelwith3ce/views/home/popular_item.dart';
import 'package:travelwith3ce/views/home/section_title.dart';

class PopularList extends StatelessWidget {
  final List<RoomModel> items;

  const PopularList({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("list in popular : ${items}");
    return FadeInUp(
      duration: const Duration(milliseconds: 1100),
      child: Column(
        children: [
          const SectionTitle(title: 'Most Popular'),
          Container(
            height: 239,
            margin: const EdgeInsets.only(bottom: 25),
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  var item = items[index];

                  return PopularItem(
                    imageUrl: item.roomImages[0],
                    name: item.roomName,
                    price: item.roomPrice.toString(),
                    rating: '4.5',
                    amenities: item.roomAmenities,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
