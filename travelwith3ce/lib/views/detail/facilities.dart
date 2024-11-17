import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:travelwith3ce/views/detail/facility_item.dart';
import 'package:travelwith3ce/views/detail/section_title.dart';

import '../../dummy.dart';

class Facilities extends StatelessWidget {
  final List<String> amenities;
  const Facilities({
    Key? key,
    required this.amenities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map ánh xạ tên amenities với index của facilities
    Map<String, int> amenitiesMap = {
      "wifi": 0,
      "thể dục": 1,
      "lễ tân 24h": 2,
      "điều hoà": 3,
      "nhà hàng": 4,
      "chỗ đậu xe": 5,
      "hồ bơi": 6,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Facilities'),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
          child: FadeInUp(
            duration: const Duration(milliseconds: 1100),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 2 cột trong gridview
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0, // Điều chỉnh tỉ lệ ô
              ),
              itemCount: amenities.length,
              itemBuilder: (context, index) {
                String currentAmenity = amenities[index].trim().toLowerCase();

                // Lấy index từ map, nếu không tìm thấy thì mặc định là 0
                int facilitiesIndex = amenitiesMap[currentAmenity] ?? 0;

                // Debug: In giá trị ra để kiểm tra
                print("Amenity: $currentAmenity, Index: $facilitiesIndex");

                return FacilityItem(
                  amenitiesName: amenities[index],
                  svgPath: facilities[facilitiesIndex],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
