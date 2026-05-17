import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/universidad.dart';

class UniversidadService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('universidades');

  // Crear
  Future<void> crear(Universidad universidad) async {
    await _collection.add(universidad.toMap());
  }

  // Listar en tiempo real (Stream)
  Stream<List<Universidad>> listar() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Universidad.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}