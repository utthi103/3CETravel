import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/userController.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserController userController = UserController();
  // fullname_user username email phone address password
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController comfirmPasswordController =
      TextEditingController();
  bool _agreeToTerms = false;
  bool _obscurePassword = true; // Biến để kiểm soát việc hiển thị mật khẩu
  bool _obscureConfirmPassword =
      true; // Biến để kiểm soát việc hiển thị mật khẩu xác nhận

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tạo tài khoản mới",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Trường họ và tên
                TextFormField(
                    controller: fullnameController,
                    decoration: InputDecoration(
                      labelText: 'Họ và tên',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bạn chưa điền họ và tên";
                      }
                      return null;
                    }),
                SizedBox(height: 15),
                // Trường tên đăng nhập
                TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Tên đăng nhập',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bạn chưa điền Tên đăng nhập";
                      }
                      return null;
                    }),

                SizedBox(height: 15),
                // Trường email
                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bạn chưa điền Email";
                      } else if (phoneController.text.length != 10) {
                        return "Sai định dạng số điện thoại";
                      }
                    }),
                SizedBox(height: 15),
                // Trường số điện thoại
                TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.phone, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bạn chưa điền SĐT";
                      }
                      return null;
                    }),
                SizedBox(height: 15),
                // Trường địa chỉ
                TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bạn chưa điền địa chỉ";
                      }
                      return null;
                    }),
                SizedBox(height: 15),
                // Trường mật khẩu
                TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword =
                                !_obscurePassword; // Chuyển đổi trạng thái
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bạn chưa điền mật khẩu";
                      } else if (passwordController.text.length < 6) {
                        return "Mật khẩu phải từ 6 kí tự";
                      }
                    }),
                SizedBox(height: 15),
                // Trường xác nhận mật khẩu
                TextFormField(
                    controller: comfirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Xác nhận mật khẩu',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                                !_obscureConfirmPassword; // Chuyển đổi trạng thái
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bạn chưa xác nhận mật khẩu";
                      } else if (passwordController.text !=
                          comfirmPasswordController.text) {
                        return "Mật khẩu không đúng";
                      }
                    }),
                SizedBox(height: 15),
                // Checkbox đồng ý với chính sách bảo mật
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value!; // Cập nhật trạng thái đồng ý
                        });
                      },
                    ),
                    Expanded(
                      child: Text("Tôi đồng ý với chính sách bảo mật"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
// Nút tạo tài khoản
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _agreeToTerms
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              // Gọi hàm đăng ký từ UserController
                              try {
                                await userController.registerUser(
                                  fullnameUser: fullnameController.text,
                                  username: usernameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  address: addressController.text,
                                  password: passwordController.text,
                                );

                                // Hiển thị thông báo đăng ký thành công
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Đăng ký thành công!')),
                                );

                                // Điều hướng đến trang khác nếu cần, ví dụ: trang đăng nhập
                                // Navigator.pushReplacementNamed(context, '/login');
                              } catch (e) {
                                // Hiển thị thông báo lỗi nếu đăng ký thất bại
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Đăng ký thất bại: $e')),
                                );
                              }
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Tạo tài khoản',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Center(
                  child: Text("Hoặc đăng ký với"),
                ),
                SizedBox(height: 10),
                // Nút đăng ký với Google và Facebook
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Xử lý đăng ký bằng Google
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'images/google.png',
                            fit: BoxFit.contain,
                            width: 20.0,
                            height: 20.0,
                          ),
                          SizedBox(
                              width:
                                  10), // Khoảng cách giữa biểu tượng và văn bản
                          Text(
                            'Google',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20), // Khoảng cách giữa Google và Facebook
                    GestureDetector(
                      onTap: () {
                        // Xử lý đăng ký bằng Facebook
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'images/facebook.png', // Đảm bảo có hình ảnh Facebook
                            fit: BoxFit.contain,
                            width: 20.0,
                            height: 20.0,
                          ),
                          SizedBox(
                              width:
                                  10), // Khoảng cách giữa biểu tượng và văn bản
                          Text(
                            'Facebook',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
