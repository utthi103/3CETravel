import 'dart:convert'; // Để xử lý base64
import 'dart:typed_data'; // Để xử lý dữ liệu ảnh
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Thêm thư viện để chọn ảnh
import 'package:travelwith3ce/controllers/roomController.dart';
import 'package:travelwith3ce/views/store/listRoom.dart'; // Import RoomController

class EditRoomScreen extends StatefulWidget {
  final Map<String, dynamic> roomData;

  EditRoomScreen({required this.roomData});

  @override
  _EditRoomScreenState createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _priceController;
  late TextEditingController _capacityController;
  late TextEditingController _statusController;
  late TextEditingController _descriptionController;
  late TextEditingController _amenitiesController;

  List<Uint8List> _roomImages = []; // Danh sách ảnh hiện tại

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.roomData['room_name']);
    _typeController = TextEditingController(text: widget.roomData['room_type']);
    _priceController =
        TextEditingController(text: widget.roomData['room_price']?.toString());
    _capacityController = TextEditingController(
        text: widget.roomData['room_capacity']?.toString());
    _statusController =
        TextEditingController(text: widget.roomData['room_status']);
    _descriptionController =
        TextEditingController(text: widget.roomData['room_description']);
    _amenitiesController = TextEditingController(
        text: (widget.roomData['room_amenities'] ?? []).join(', '));

    // Giải mã ảnh từ Base64
    List<String> encodedImages =
        List<String>.from(widget.roomData['room_images'] ?? []);
    _roomImages = encodedImages.map((e) => base64Decode(e)).toList();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Đọc ảnh dưới dạng Uint8List
      Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _roomImages.add(imageBytes);
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      // Cập nhật thông tin phòng
      RoomController roomController = RoomController();

      // Lấy thông tin phòng từ các trường trong form
      String roomId = widget.roomData['room_id'];
      String roomName = _nameController.text;
      String roomType = _typeController.text;
      double roomPrice = double.tryParse(_priceController.text) ?? 0.0;
      String roomStatus = _statusController.text;
      int roomCapacity = int.tryParse(_capacityController.text) ?? 1;
      String roomDescription = _descriptionController.text;
      List<String> roomAmenities =
          _amenitiesController.text.split(',').map((e) => e.trim()).toList();

      // Giải mã ảnh từ Uint8List thành base64
      List<String> roomImages = _roomImages
          .map((image) => base64Encode(image))
          .toList(); // Chuyển ảnh thành base64

      // Giữ nguyên ngày tạo (không thay đổi)
      String roomCreatedAt = widget.roomData['created_at'] ??
          DateTime.now()
              .toIso8601String(); // Nếu không có thì lấy ngày hiện tại

      // Chỉ cập nhật ngày sửa
      String roomUpdatedAt =
          DateTime.now().toIso8601String(); // Cập nhật thời gian sửa

      // Cập nhật phòng
      await roomController.updateRoom(
        roomId: roomId,
        roomName: roomName,
        roomType: roomType,
        roomPrice: roomPrice,
        roomStatus: roomStatus,
        roomCapacity: roomCapacity,
        roomImages: roomImages,
        roomDescription: roomDescription,
        roomAmenities: roomAmenities,
        hotelId: widget.roomData['hotel_id'],
        createdAt: roomCreatedAt, // Không thay đổi ngày tạo
        updatedAt: roomUpdatedAt, // Chỉ thay đổi ngày sửa
      );

      // Cập nhật lại thông tin phòng trong widget.roomData
      setState(() {
        widget.roomData['room_name'] = roomName;
        widget.roomData['room_type'] = roomType;
        widget.roomData['room_price'] = roomPrice;
        widget.roomData['room_capacity'] = roomCapacity;
        widget.roomData['room_status'] = roomStatus;
        widget.roomData['room_description'] = roomDescription;
        widget.roomData['room_amenities'] = roomAmenities;
        widget.roomData['room_images'] = roomImages;
        widget.roomData['updated_at'] = roomUpdatedAt;
      });

      // Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room updated successfully!')),
      );
      Navigator.pop(context, 'updated'); // Quay lại màn hình trước đó
    } catch (e) {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update room: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _statusController.dispose();
    _descriptionController.dispose();
    _amenitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Room'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Room Name'),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Room Type'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Room Price (VNĐ)'),
            ),
            TextField(
              controller: _capacityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Room Capacity'),
            ),
            TextField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Room Status'),
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Room Description'),
            ),
            TextField(
              controller: _amenitiesController,
              decoration: InputDecoration(
                labelText: 'Room Amenities',
                hintText: 'Separate with commas (e.g., WiFi, TV, AC)',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Room Images',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Hiển thị ảnh hiện tại
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _roomImages.map((image) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _roomImages.remove(image);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.add_photo_alternate),
              label: Text('Add Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
