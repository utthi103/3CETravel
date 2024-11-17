import 'dart:math';
import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/userController.dart'; // Import UserController
import 'package:travelwith3ce/views/verifycode.dart'; // Import màn hình xác minh OTP

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  // Hàm tạo mã OTP ngẫu nhiên
  String generateOtpCode() {
    var random = Random();
    return (1000 + random.nextInt(9000)).toString(); // Mã OTP 4 chữ số
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Vui lòng nhập địa chỉ email của bạn để nhận hướng dẫn đặt lại mật khẩu.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email của bạn';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Kiểm tra xem email có tồn tại không
                    UserController userController = UserController();
                    bool emailExists = await userController
                        .checkEmailExists(emailController.text);

                    if (emailExists) {
                      // Tạo mã OTP ngẫu nhiên
                      String otpCode = generateOtpCode();

                      // Gửi mã OTP vào email người dùng
                      await userController.sendOtpCode(
                          emailController.text, otpCode);

                      // Chuyển đến màn hình OTP và truyền mã OTP
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtpVerificationScreen(
                            otpCode: otpCode, // Truyền otpCode vào constructor
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email không tồn tại trong hệ thống'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text('Gửi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
