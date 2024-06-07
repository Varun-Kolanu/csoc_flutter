import 'package:csoc_flutter/models/user_model.dart';

class UserRepository {
  Future<UserModel> createUser(
      String userId, Map<String, dynamic> userMap) async {
    final userRef = await UserModel().firebaseCollection.add(userMap);
    final docSnapshot = await userRef.get();
    return UserModel.fromJson(docSnapshot.data()!);
  }

  Future getUser(String userId) async {
    final snapshot = await UserModel()
        .firebaseCollection
        .where("id", isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final documentData = snapshot.docs.first.data();
      final jsonData = Map<String, dynamic>.from(documentData);
      return jsonData;
    } else {
      return null;
    }
  }
}
