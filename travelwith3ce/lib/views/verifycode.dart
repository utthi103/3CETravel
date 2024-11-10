import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String otpCode; // Nhận mã OTP từ màn hình trước
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());

  // Constructor nhận mã OTP
  OtpVerificationScreen({required this.otpCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon or image at the top
            Icon(Icons.message, size: 100, color: Colors.green),
            SizedBox(height: 20),
            // OTP Verification Text
            Text(
              "Mã xác nhận",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Welcome message
            Text(
              "Chúng tôi đã gửi mã xác nhận cho bạn qua email. Mã OTP: $otpCode", // Hiển thị OTP đã gửi
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 24),
            // OTP input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 50,
                  child: TextField(
                    controller: _otpControllers[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context)
                            .nextFocus(); // Tự động chuyển sang ô tiếp theo
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            // Resend OTP logic (currently not functional, but you can implement it)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print("Resend OTP");
                    // Add logic to resend OTP here (call API, etc.)
                  },
                  child: Text(
                    "Gửi lại mã OTP",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String otpEntered = _otpControllers.map((c) => c.text).join();
                  print("Mã OTP đã nhập: $otpEntered");

                  if (otpEntered == otpCode) {
                    // Thực hiện xác minh mã OTP
                    print("OTP hợp lệ");
                    // Thực hiện hành động khi OTP đúng
                  } else {
                    // Thông báo lỗi nếu OTP không khớp
                    print("OTP không hợp lệ");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mã OTP không hợp lệ'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Gửi",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
