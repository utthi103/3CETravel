import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import '../../constant.dart';

class SearchBarr extends StatelessWidget {
  final Function(String) onSearchChanged; // Tham số callback

  const SearchBarr({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          kPrimaryColor.withOpacity(0.8),
                          kSecondaryColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: TextField(
                      style: TextStyle(color: kAccentColor),
                      onChanged: onSearchChanged, // Gọi hàm lọc khi thay đổi
                      decoration: InputDecoration(
                        hintText: 'Search Hotel',
                        hintStyle:
                            TextStyle(color: kAccentColor.withOpacity(0.7)),
                        icon: SvgPicture.asset('assets/icons/search.svg',
                            color: kAccentColor),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: kAccentColor),
                          onPressed: () {
                            onSearchChanged(''); // Xóa tìm kiếm
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 17),
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset('assets/icons/option.svg',
                      color: kAccentColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
