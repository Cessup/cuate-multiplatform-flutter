import '../../core/entities/user.dart';

class UserModel extends User {
  UserModel({required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(name: json['name']);
  }
}
