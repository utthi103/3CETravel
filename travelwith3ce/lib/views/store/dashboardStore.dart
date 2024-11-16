import 'package:flutter/material.dart';
import 'package:travelwith3ce/views/admin/createaccount.dart';
import 'package:travelwith3ce/views/admin/store_management.dart';
import 'package:travelwith3ce/views/admin/user_management.dart';
import 'package:travelwith3ce/views/store/listRoom.dart';
import 'package:travelwith3ce/views/store/room_management.dart';

void main() {
  runApp(const StoreDashboardApp());
}

class StoreDashboardApp extends StatelessWidget {
  const StoreDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const StoreDashboard(),
    );
  }
}

class StoreDashboard extends StatefulWidget {
  const StoreDashboard({Key? key}) : super(key: key);

  @override
  _StoreDashboardState createState() => _StoreDashboardState();
}

class _StoreDashboardState extends State<StoreDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.admin_panel_settings,
                      size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text('Store Panel',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Trang chủ'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Quản lý phòng'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRoomScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Danh sách phòng'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoomListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Quản lý cửa hàng'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoreManagementScreen()),
                );
                // Điều hướng đến màn hình cài đặt
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            DashboardCard(
              icon: Icons.person,
              title: 'Users',
              subtitle: 'Manage Users',
              onTap: () {
                // Chuyển đến trang quản lý người dùng
              },
            ),
            DashboardCard(
              icon: Icons.inventory,
              title: 'Products',
              subtitle: 'Manage Products',
              onTap: () {
                // Chuyển đến trang quản lý sản phẩm
              },
            ),
            DashboardCard(
              icon: Icons.analytics,
              title: 'Analytics',
              subtitle: 'View Reports',
              onTap: () {
                // Chuyển đến trang phân tích
              },
            ),
            DashboardCard(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'System Settings',
              onTap: () {
                // Chuyển đến trang cài đặt hệ thống
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blue),
              const SizedBox(height: 20),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
