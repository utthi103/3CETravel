import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:travelwith3ce/views/detail/section_title.dart';

import '../../constant.dart';

class Description extends StatelessWidget {
  final String description;  // Nhận mô tả qua constructor

  const Description({
    Key? key,
    required this.description,  // Chắc chắn rằng mô tả được truyền vào
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Description',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FadeInUp(
            duration: const Duration(milliseconds: 1300),
            child: Text(
              description,  // Hiển thị mô tả từ dữ liệu
              style: nunito14.copyWith(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
