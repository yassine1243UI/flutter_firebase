import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Collection de codes dans Firestore
  final CollectionReference codes = FirebaseFirestore.instance.collection('codes');

  /// Crée un nouveau document dans la collection 'codes' avec le code fourni.
  /// 
  /// Retourne une référence au document créé.
  Future<DocumentReference> createCode(String code) async {
    // Ajoute le code à la collection et récupère la référence du document
    final DocumentReference documentReference = await codes.add({
      'code': code,
    });
    return documentReference;
  }

  /// Récupère un flux de tous les documents de la collection 'codes'.
  /// 
  /// Utilisé pour écouter les changements en temps réel.
  Stream<QuerySnapshot> getCodes() {
    return codes.snapshots();
  }
}
