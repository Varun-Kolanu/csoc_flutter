import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<List<Map<String, dynamic>>> fetchSubjects(String userId) async {
    try {
      QuerySnapshot userSnapshot =
          await _db.collection('User').where('id', isEqualTo: userId).get();
      if (userSnapshot.docs.isEmpty) {
        throw Exception('User document not found for ID: $userId');
      }
      DocumentSnapshot userDocument = userSnapshot.docs.first;
      QuerySnapshot subjectSnapshot =
          await userDocument.reference.collection('subjects').get();
      List<Map<String, dynamic>> subjects = subjectSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return subjects;
    } catch (e) {
      throw Exception('Error fetching subjects: $e');
    }
  }
}
