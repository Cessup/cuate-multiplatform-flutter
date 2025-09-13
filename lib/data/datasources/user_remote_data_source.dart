import '../../data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> fetchUser();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<UserModel> fetchUser() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return UserModel(name: "John Doe");
  }
}
