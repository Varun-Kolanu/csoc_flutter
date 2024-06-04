import 'package:csoc_flutter/models/user_model.dart';

class UserRepository {
  Future<UserModel> createUser(
      String userId, Map<String, dynamic> userMap) async {
    final userRef = await UserModel().firebaseCollection.add(userMap);
    final docSnapshot = await userRef.get();
    return UserModel.fromJson(docSnapshot.data()!);
  }

  Future getUser(String userId) async {
    final snapshot = await UserModel().firebaseCollection.doc(userId).get();
    if (snapshot.exists) {
      return snapshot;
    } else {
      return Future.error("Document not found");
    }
  }
}
