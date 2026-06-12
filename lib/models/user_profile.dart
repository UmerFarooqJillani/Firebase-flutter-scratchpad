class UserProfileModel {
  final String id;
  final String name;
  final String email;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email};
  }

  factory UserProfileModel.fromMap(String id, Map<String, dynamic> map) {
    return UserProfileModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
