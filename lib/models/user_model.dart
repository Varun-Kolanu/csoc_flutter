import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final firebaseCollection = FirebaseFirestore.instance.collection("User");
  final String? id;
  final String? name;
  final String? email;

  UserModel({
    this.id,
    this.name,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );
}
