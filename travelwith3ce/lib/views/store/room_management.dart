import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/controllers/roomController.dart'; // Import the RoomController class

class AddRoomScreen extends StatefulWidget {
  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  String? userId;
  // Controllers for the input fields
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomTypeController = TextEditingController();
  final TextEditingController roomPriceController = TextEditingController();
  final TextEditingController roomDescriptionController =
      TextEditingController();
  final TextEditingController roomCapacityController = TextEditingController();
  final TextEditingController roomAmenitiesController = TextEditingController();

  String roomStatus = 'Available'; // Default status
  List<String> selectedFilesBase64 =
      []; // Store base64 strings of selected images

  // Function to pick image and convert to base64
  Future<void> _pickImage() async {
    //  final result = await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    final result = 'cam';

    if (result != null) {
      // Convert the selected image to base64
      String base64Image = base64Encode(result as Uint8List);
      setState(() {
        selectedFilesBase64.add(base64Image);
      });
    }
  }

  Future<String?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userStoreId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 232, 236),
      appBar: AppBar(
        title: const Text('Add Room'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Name
                TextFormField(
                  controller: roomNameController,
                  decoration: _inputDecoration('Room Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Room Type
                TextFormField(
                  controller: roomTypeController,
                  decoration: _inputDecoration('Room Type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Room Price
                TextFormField(
                  controller: roomPriceController,
                  decoration: _inputDecoration('Room Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Room Description
                TextFormField(
                  controller: roomDescriptionController,
                  decoration: _inputDecoration('Room Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Room Capacity
                TextFormField(
                  controller: roomCapacityController,
                  decoration: _inputDecoration('Room Capacity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room capacity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Room Amenities
                TextFormField(
                  controller: roomAmenitiesController,
                  decoration:
                      _inputDecoration('Room Amenities (comma-separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room amenities';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Room Status Dropdown
                DropdownButtonFormField<String>(
                  value: roomStatus,
                  decoration: _inputDecoration('Room Status'),
                  items: ['Available', 'Unavailable', 'Under Maintenance']
                      .map((status) =>
                          DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) => setState(() => roomStatus = value!),
                ),
                const SizedBox(height: 16),

                // Pick Image Button
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Room Image'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Display Selected Images
                selectedFilesBase64.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: selectedFilesBase64.length,
                        itemBuilder: (context, index) {
                          final base64Image = selectedFilesBase64[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              base64Decode(base64Image),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )
                    : Container(),

                const SizedBox(height: 20),

                // Add Room Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Get the userId from SharedPreferences
                        userId = await _loadUserId();

                        // Call addRoom function
                        await RoomController().addRoom(
                          roomName: roomNameController.text.trim(),
                          roomType: roomTypeController.text.trim(),
                          roomPrice:
                              double.parse(roomPriceController.text.trim()),
                          roomStatus: roomStatus,
                          roomCapacity:
                              int.parse(roomCapacityController.text.trim()),
                          roomDescription:
                              roomDescriptionController.text.trim(),
                          roomAmenities:
                              roomAmenitiesController.text.split(','),
                          roomImages:
                              selectedFilesBase64, // Pass base64 strings
                          hotelId: userId!, // Pass userId as hotelId
                        );

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Room Added Successfully")),
                        );
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
                      'Add Room',
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

  // Helper function for creating InputDecoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
