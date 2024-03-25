import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesFirebase {
  final util = FirebaseFirestore.instance;
  CollectionReference? _favoritesCollection;

  FavoritesFirebase() {
    _favoritesCollection = util.collection('favorites');
  }

  Stream<QuerySnapshot> consultar() {
    return _favoritesCollection!.snapshots();
  }

  Future<void> insertar(Map<String, dynamic> data) async {
    return _favoritesCollection!.doc().set(data);
  }

  Future<void> actualizar(Map<String, dynamic> data, String id) async {
    return _favoritesCollection!.doc(id).update(data);
  }

  Future<void> eliminar(String id) async {
    return _favoritesCollection!.doc(id).delete();
  }

  Future<void> eliminarnombre(String title) async {
  final QuerySnapshot snapshot = await _favoritesCollection!.where('title', isEqualTo: title).get();
  if (snapshot.docs.isNotEmpty) {
    final docId = snapshot.docs.first.id;
    return _favoritesCollection!.doc(docId).delete();
  } else {
    throw Exception('No se encontró ningún documento con el título proporcionado: $title');
  }
}
}

