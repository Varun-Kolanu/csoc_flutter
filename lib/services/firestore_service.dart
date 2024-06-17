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
      print('Fetched subjects: $subjects');
      return subjects;
    } catch (e) {
      print('Error fetching subjects: $e');
      throw Exception('Error fetching subjects: $e');
    }
  }

  Future<void> addSubject(
      // To add the subject a user wishes to add in the database.
      String userId,
      Map<String, dynamic> subjectData) async {
    try {
      QuerySnapshot userSnapshot =
          await _db.collection('User').where('id', isEqualTo: userId).get();
      if (userSnapshot.docs.isEmpty) {
        throw Exception('User document not found for ID: $userId');
      }
      DocumentSnapshot userDocument = userSnapshot.docs.first;
      await userDocument.reference.collection('subjects').add(subjectData);
    } catch (e) {
      throw Exception('Error adding subject: $e');
    }
  }

  Future<void> editSubject(
      String subjectId, Map<String, dynamic> updatedSubjectData) async {
    // to edit the subject
    try {
      // Reference to the subject document
      DocumentReference subjectDocRef =
          _db.collection('subjects').doc(subjectId);
      // Update the document for the particular subject
      await subjectDocRef.update(updatedSubjectData);
    } catch (e) {
      throw Exception('Error updating subject: $e');
    }
  }
}
