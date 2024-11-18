import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelwith3ce/controllers/bookController.dart';
import 'package:travelwith3ce/views/detail/custom_button.dart';
import 'package:travelwith3ce/views/detail/description.dart';
import 'package:travelwith3ce/views/detail/detail_info.dart';
import 'package:travelwith3ce/views/detail/facilities.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Để sử dụng SharedPreferences

class DetailScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String rawRating;
  final String price;
  final List<String> amenities;
  final String roomId;
  final String hotelId;

  const DetailScreen({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.rawRating,
    required this.price,
    required this.amenities,
    required this.roomId,
    required this.hotelId,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  double _calculatedPrice = 0.0; // Biến lưu giá đã tính toán

  // Hàm xử lý khi nhấn Book Now
  void _handleBookNow() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      // Nếu chưa đăng nhập, yêu cầu người dùng đăng nhập
      _showLoginPrompt();
    } else {
      // Nếu đã đăng nhập, yêu cầu người dùng chọn ngày
      _showDatePickerDialog();
    }
  }

  // Hiển thị thông báo yêu cầu đăng nhập
  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: const Text("You must log in first."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.pushNamed(
                    context, '/login'); // Điều hướng đến màn hình đăng nhập
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  String formatVietnameseDate(DateTime date) {
    return DateFormat("EEEE, 'ngày' dd 'tháng' MM 'năm' yyyy", 'vi')
        .format(date);
  }

  // Hiển thị hộp thoại chọn ngày nhận phòng và ngày trả phòng
  void _showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Vui lòng chọn ngày vào và ra"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Chọn ngày nhận phòng
              ListTile(
                title: const Text("Ngày vào"),
                subtitle: Text(
                  _checkInDate == null
                      ? "Chọn ngày"
                      : formatVietnameseDate(
                          _checkInDate!), // Hiển thị ngày vào
                ),
                onTap: () async {
                  DateTime? selectedDate =
                      await _selectDate(context, _checkInDate);
                  if (selectedDate != null && selectedDate != _checkInDate) {
                    setState(() {
                      _checkInDate = selectedDate;
                      _calculatePrice(); // Cập nhật giá khi chọn ngày vào
                    });
                  }
                },
              ),
              // Chọn ngày trả phòng
              ListTile(
                title: const Text("Ngày ra"),
                subtitle: Text(
                  _checkOutDate == null
                      ? "Chọn ngày"
                      : formatVietnameseDate(
                          _checkOutDate!), // Hiển thị ngày ra
                ),
                onTap: () async {
                  DateTime? selectedDate =
                      await _selectDate(context, _checkOutDate);
                  if (selectedDate != null && selectedDate != _checkOutDate) {
                    setState(() {
                      _checkOutDate = selectedDate;
                      _calculatePrice(); // Cập nhật giá khi chọn ngày ra
                    });
                  }
                },
              ),

              // Hiển thị giá đã tính toán trong hộp thoại
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _checkInDate != null && _checkOutDate != null
                      ? "Total Price: \$${_calculatedPrice > 0 ? _calculatedPrice.toStringAsFixed(2) : '0.00'}"
                      : "Select dates to calculate price",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                if (_checkInDate != null && _checkOutDate != null) {
                  _showConfirmationDialog();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select both dates.")),
                  );
                }
              },
              child: const Text("Đồng ý"),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị thông báo xác nhận giá tiền
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận đặt phòng"),
          content: RichText(
            text: TextSpan(
              text: "Tổng tiền: ",
              style: const TextStyle(
                  fontSize: 16.0, color: Colors.black), // Phong cách chung
              children: [
                TextSpan(
                  text: "${_calculatedPrice.toStringAsFixed(2)} VNĐ",
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold, // In đậm giá tiền
                    color: Colors.black,
                  ),
                ),
                const TextSpan(
                  text: "\nBạn có muốn tiếp tục không?",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                _bookNowWithDates(_checkInDate!, _checkOutDate!);
              },
              child: const Text("Đồng ý"),
            ),
          ],
        );
      },
    );
  }

  // Hàm chọn ngày bằng `showDatePicker`
  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? currentDate) async {
    return await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
  }

  // Hàm tính toán giá phòng
  void _calculatePrice() {
    if (_checkInDate != null && _checkOutDate != null) {
      int daysStay = _checkOutDate!.difference(_checkInDate!).inDays;
      if (daysStay > 0) {
        setState(() {
          // Tính toán giá phòng = số ngày ở * giá mỗi đêm
          _calculatedPrice = daysStay * double.parse(widget.price);
        });
      } else {
        setState(() {
          _calculatedPrice = 0.0; // Nếu ngày vào nhỏ hơn ngày ra thì giá là 0
        });
      }
    }
  }

  // Hàm đặt phòng khi có ngày nhận và trả phòng
  void _bookNowWithDates(DateTime checkInDate, DateTime checkOutDate) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      if (userId != null) {
        BookingController bookingController = BookingController();

        // Gọi phương thức addBooking từ BookingController để lưu thông tin đặt phòng vào Firebase
        await bookingController.addBooking(
          idUser: userId,
          idRoom: widget.roomId,
          idStore: widget.hotelId,
          price: _calculatedPrice, // Sử dụng giá đã tính toán
          checkInDate: checkInDate,
          checkOutDate: checkOutDate,
        );

        // Hiển thị hộp thoại thông báo đặt phòng thành công
        _showBookingSuccessDialog();
      }
    } catch (e) {
      print("Error while booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking Failed! Please try again.")),
      );
    }
  }

  // Hiển thị AlertDialog khi đặt phòng thành công
  void _showBookingSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Đặt hàng thành công"),
          content: const Text(
              "Chúng tôi đã gửi mã xác nhận qua email cho bạn. Vui lòng đưa mã đã gửi khi đến nhận phòng!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn "OK"
                Navigator.of(context).pop(); // Đóng màn hình chi tiết phòng
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Image.memory(
              base64Decode(widget.imageUrl),
              scale: 4,
              fit: BoxFit.cover,
            ),
            DetailInfo(
              title: widget.title,
              rawRating: widget.rawRating,
              price: widget.price,
            ),
            Facilities(
              amenities: widget.amenities,
            ),
            const Description(),
            // Hiển thị tổng giá ở đây
            CustomButton(
              roomId: widget.roomId,
              onPressed: _handleBookNow,
            ),
          ],
        ),
      ),
    );
  }
}
