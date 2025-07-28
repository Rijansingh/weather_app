import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../services/firebase_service.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Obx(() {
        final user = authController.user.value;
        if (user == null) {
          return const Center(child: Text('Please log in to view favorites'));
        }
        return FutureBuilder<List<String>>(
          future: firebaseService.getFavorites(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading favorites'));
            }
            final favorites = snapshot.data ?? [];
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final city = favorites[index];
                return ListTile(
                  title: Text(city),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        firebaseService.removeFavorite(user.uid, city),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
