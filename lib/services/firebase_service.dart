import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference favorites =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> addFavorite(String userId, String city) async {
    await favorites.doc(userId).set({
      'cities': FieldValue.arrayUnion([city]),
    }, SetOptions(merge: true));
  }

  Future<List<String>> getFavorites(String userId) async {
    final doc = await favorites.doc(userId).get();
    return List<String>.from(doc.get('cities') ?? []);
  }

  Future<void> removeFavorite(String userId, String city) async {
    await favorites.doc(userId).update({
      'cities': FieldValue.arrayRemove([city]),
    });
  }
}
