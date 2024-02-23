class UserModel {
  final String email;
  final String name;
  final String phone;
  final String type;
  final String uid;

  UserModel(this.email, this.name, this.phone, this.type, this.uid);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['email'],
      json['name'],
      json['phone'],
      json['type'],
      json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'type': type,
      'uid': uid,
    };
  }
}
