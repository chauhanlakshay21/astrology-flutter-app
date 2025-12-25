class UserModel {
  final String email;
  final String? name;

  UserModel({required this.email, this.name});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
    );
  }
}