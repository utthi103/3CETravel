import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travelwith3ce/controllers/roomController.dart';
import 'package:travelwith3ce/models/roomModel.dart';
import 'package:travelwith3ce/views/home/searchPage.dart';
import '../../constant.dart';

class SearchBarr extends StatefulWidget {
  const SearchBarr({Key? key}) : super(key: key);

  @override
  _SearchBarrState createState() => _SearchBarrState();
}

class _SearchBarrState extends State<SearchBarr> {
  // Tạo TextEditingController để lấy giá trị từ TextField
  final TextEditingController _searchController = TextEditingController();

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
                    height: 44,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      border: Border.all(color: kShadeColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller:
                          _searchController, // Đưa controller vào TextField
                      style: TextStyle(color: kAccentColor),
                      decoration: InputDecoration(
                        hintText: 'Search Hotel',
                        icon: SvgPicture.asset('assets/icons/search.svg'),
                        border: InputBorder.none,
                        hintStyle:
                            nunitoRegular12.copyWith(color: kAccentColor),
                      ),
                      onSubmitted: (query) {
                        // Gọi hàm tìm kiếm khi người dùng nhấn Enter
                        _search(query);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 17),
                Container(
                  height: 44,
                  width: 44,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: SvgPicture.asset('assets/icons/option.svg'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Hàm thực hiện tìm kiếm
  void _search(String query) async {
    // Hàm này sẽ được gọi khi nhấn Enter, truyền giá trị nhập vào
    print('Searching for: $query');

    // Khởi tạo RoomController và gọi phương thức fetchRoomByName
    RoomController roomController = RoomController();

    try {
      // Chờ fetchRoomByName để trả về kết quả trước khi gán vào listRoom
      List<RoomModel> SearchRooms = await roomController.fetchRoomByName(query);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(
            rooms: SearchRooms,
          ),
        ),
      );
    } catch (e) {
      // Xử lý lỗi nếu fetchRoomByName gặp sự cố
      print('Error fetching rooms: $e');
    }
  }
}
