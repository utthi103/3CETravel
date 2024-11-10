import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/userController.dart';
import 'package:travelwith3ce/models/userModel.dart';
import 'package:travelwith3ce/views/forgot_password.dart';
import 'package:travelwith3ce/views/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserController userController = UserController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Thêm key cho form
  bool _obscureText = true; // Trạng thái của mật khẩu (ẩn/hiển)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 232, 236),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo và Tên ứng dụng
                Column(
                  children: [
                    Image.asset(
                      'assets/images/3ce.jpg',
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                // Thêm Form widget để áp dụng validator
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Trường nhập Email
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Tên đăng nhập',
                          hintText: 'Tên đăng nhập',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Bạn chưa điền tên đăng nhập";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Trường nhập Password với nút hiển thị mật khẩu
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          hintText: 'Mật khẩu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText; // Đổi trạng thái
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Bạn chưa điền mật khẩu";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Đường dẫn "Đăng ký" và "Quên mật khẩu"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Bạn chưa có tài khoản?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ForgotPasswordScreen(), // Đổi trang đích nếu cần
                          ),
                        );
                      },
                      child: const Text(
                        'Quên mật khẩu',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Nút "Đăng nhập"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Nếu form hợp lệ, gọi hàm loginUser từ UserController và kiểm tra kết quả
                        Map<String, dynamic>? loginResult =
                            await userController.loginUser(
                          username: usernameController.text,
                          password: passwordController.text,
                        );

                        if (loginResult != null) {
                          // Lấy userId và user từ kết quả trả về
                          String userId = loginResult['id'];
                          User user = loginResult['user'];
                          print("hehehehehhe Id User" + userId);

                          // Lưu userId vào SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('userId', userId);

                          // Chuyển đến trang chính (ví dụ: HomeScreen) khi đăng nhập thành công
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RegisterScreen(), // Đổi trang đích nếu cần
                            ),
                          );
                        } else {
                          // Hiển thị thông báo lỗi khi đăng nhập thất bại
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Tên đăng nhập hoặc mật khẩu không đúng.'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
