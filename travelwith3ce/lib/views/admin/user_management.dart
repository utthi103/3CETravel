import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/userController.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture =
        UserController().fetchUsers(); // Gọi hàm fetch từ UserController
  }

  void refreshUsers() {
    setState(() {
      _usersFuture = UserController().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
      ),
      body: Center(
        child: Container(
          width: 1200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _usersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Lỗi khi tải dữ liệu');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Không có dữ liệu');
              } else {
                return PaginatedDataTable(
                  header: const Text('Danh sách người dùng'),
                  rowsPerPage: 5,
                  columns: const [
                    DataColumn(label: Text('STT')),
                    DataColumn(label: Text('Họ và tên')),
                    DataColumn(label: Text('Tên đăng nhập')),
                    DataColumn(label: Text('Số điện thoại')),
                    DataColumn(label: Text('Địa chỉ')),
                    DataColumn(label: Text('Thao tác')),
                  ],
                  source: UserDataSource(
                      snapshot.data!, refreshUsers, context), // Truyền context
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class UserDataSource extends DataTableSource {
  final List<Map<String, dynamic>> users;
  final Function refreshUsers;
  final UserController userController = UserController();
  final BuildContext context; // Thêm context

  UserDataSource(this.users, this.refreshUsers, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= users.length) return null;

    final user = users[index];
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/avt.jpg'),
            ),
            const SizedBox(width: 8),
            Text(user['fullname_user'] ?? 'N/A'),
          ],
        )),
        DataCell(Text(user['username'] ?? 'N/A')),
        DataCell(Text(user['phone'] ?? 'N/A')),
        DataCell(Text(user['address'] ?? 'N/A')),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final userKey = user['id'];
                if (userKey != null && userKey.isNotEmpty) {
                  // Hiển thị hộp thoại xác nhận
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Xác nhận xóa'),
                        content: const Text(
                            'Bạn có chắc chắn muốn xóa người dùng này không?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // Người dùng chọn không xóa
                            },
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // Người dùng chọn xóa
                            },
                            child: const Text('Xóa'),
                          ),
                        ],
                      );
                    },
                  );

                  // Nếu người dùng chọn xóa, thực hiện xóa
                  if (confirmDelete) {
                    await userController.deleteUser(userKey);
                    refreshUsers();
                  } else {
                    print('Người dùng đã hủy hành động xóa');
                  }
                } else {
                  print('Không tìm thấy userKey hợp lệ để xóa');
                }
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => users.length;
  @override
  int get selectedRowCount => 0;
}
