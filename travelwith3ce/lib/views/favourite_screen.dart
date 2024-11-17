import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late Future<List<Map<String, dynamic>>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorites yet!'));
          }

          final favorites = snapshot.data!;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return ListTile(
                leading: Image.memory(base64Decode(item['imageUrl'])),
                title: Text(item['name']),
                subtitle: Text('${item['price']} VNĐ'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, item['name']);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    List<String>? favorites = prefs.getStringList('favorites_$userId');

    if (favorites == null) return [];

    return favorites.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  void _showDeleteConfirmationDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text(
              "Are you sure you want to remove this item from favorites?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _removeFromFavorites(name);
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeFromFavorites(String name) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      List<String>? favorites = prefs.getStringList('favorites_$userId');
      if (favorites != null) {
        favorites.removeWhere((item) => jsonDecode(item)['name'] == name);
        await prefs.setStringList('favorites_$userId', favorites);

        // Update the state to refresh the list
        setState(() {
          _favoritesFuture = _loadFavorites();
        });

        // Show a SnackBar confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name removed from favorites!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
