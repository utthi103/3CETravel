import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constant.dart';

class FacilityItem extends StatelessWidget {
  final String amenitiesName;
  final String svgPath;

  const FacilityItem({
    Key? key,
    required this.amenitiesName,
    required this.svgPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SVG Icon
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: kShadeColor,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              svgPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 8), // Spacing
        // Amenities Name
        Text(
          amenitiesName,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 12,
        )
      ],
    );
  }
}
