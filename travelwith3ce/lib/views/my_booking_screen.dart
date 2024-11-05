// booking_history_screen.dart
import 'package:flutter/material.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: const Color(0xff262626), // kPrimaryColor
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildBookingCard(
              hotelName: 'Grand Hotel',
              bookingDate: '2023-11-01',
              status: 'Completed',
            ),
            _buildBookingCard(
              hotelName: 'Beach Resort',
              bookingDate: '2023-10-20',
              status: 'Cancelled',
            ),
            _buildBookingCard(
              hotelName: 'Mountain Lodge',
              bookingDate: '2023-09-15',
              status: 'Completed',
            ),
            // Add more booking cards as needed
          ],
        ),
      ),
    );
  }

  // Method to build a booking card
  Widget _buildBookingCard(
      {required String hotelName,
      required String bookingDate,
      required String status}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hotelName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Booking Date: $bookingDate',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Status: $status',
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
