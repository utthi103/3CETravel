import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/storeController.dart';

class StoreManagementScreen extends StatefulWidget {
  const StoreManagementScreen({Key? key}) : super(key: key);

  @override
  _StoreManagementScreenState createState() => _StoreManagementScreenState();
}

class _StoreManagementScreenState extends State<StoreManagementScreen> {
  late Future<List<Map<String, dynamic>>> _storesFuture;

  @override
  void initState() {
    super.initState();
    _storesFuture =
        StoreController().fetchStores(); // Gọi hàm fetch từ StoreController
  }

  void refreshStores() {
    setState(() {
      _storesFuture = StoreController().fetchStores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý cửa hàng'),
      ),
      body: Center(
        child: Container(
          width: 1200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _storesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Lỗi khi tải dữ liệu');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Không có dữ liệu');
              } else {
                return PaginatedDataTable(
                  header: const Text('Danh sách cửa hàng'),
                  rowsPerPage: 5,
                  columns: const [
                    DataColumn(label: Text('STT')),
                    DataColumn(label: Text('Tên cửa hàng')),
                    DataColumn(label: Text('Tên đăng nhập')),
                    DataColumn(label: Text('Số điện thoại')),
                    DataColumn(label: Text('Địa chỉ')),
                    DataColumn(label: Text('Thao tác')),
                  ],
                  source:
                      StoreDataSource(snapshot.data!, refreshStores, context),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class StoreDataSource extends DataTableSource {
  final List<Map<String, dynamic>> stores;
  final Function refreshStores;
  final BuildContext context; // Thêm context

  StoreDataSource(this.stores, this.refreshStores, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= stores.length) return null;

    final store = stores[index];
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(store['name_store'] ?? 'N/A')),
        DataCell(Text(store['username_store'] ?? 'N/A')),
        DataCell(Text(store['phone_store'] ?? 'N/A')),
        DataCell(Text(store['address_store'] ?? 'N/A')),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final storeKey = store['id_store'];
                if (storeKey != null && storeKey.isNotEmpty) {
                  // Hiển thị hộp thoại xác nhận
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Xác nhận xóa'),
                        content: const Text(
                            'Bạn có chắc chắn muốn xóa cửa hàng này không?'),
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
                    // Gọi controller để xóa store
                    await StoreController().deleteStore(storeKey);
                    refreshStores();
                  } else {
                    print('Người dùng đã hủy hành động xóa');
                  }
                } else {
                  print('Không tìm thấy storeKey hợp lệ để xóa');
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
  int get rowCount => stores.length;

  @override
  int get selectedRowCount => 0;
}
