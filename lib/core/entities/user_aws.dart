class User {
  final String email;
  final String phone;
  late final String nickname;
  final String familyName;
  final String givenName;
  final String address;
  final String gender;
  final String birthdate;
  final String? imagePath;

  User(
    this.email,
    this.phone,
    this.nickname,
    this.familyName,
    this.givenName,
    this.address,
    this.gender,
    this.birthdate,
    this.imagePath,
  );
}
