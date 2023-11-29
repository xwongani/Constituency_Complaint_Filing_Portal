class UserModel {
  final String? userId;
  final String fullname;
  final String nrc;
  final String phone;
  final String age;
  final String gender;
  final String region;
  final String constituency;
  final String email;
  final String role;
  final String password;

  const UserModel({
    this.userId,
    required this.fullname,
    required this.nrc,
    required this.phone,
    required this.age,
    required this.gender,
    required this.region,
    required this.constituency,
    required this.email,
    required this.role,
    required this.password,
  });

  toJson() {
    return {
      "userId": userId,
      "FullName": fullname,
      "Nrc": nrc,
      "Phone": phone,
      "Age": age,
      "Gender": gender,
      "Region": region,
      "Constituency": constituency,
      "Email": email,
      "Role": role,
      "Password": password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      fullname: json['FullName'] ?? '',
      nrc: json['Nrc'] ?? '',
      phone: json['Phone'] ?? '',
      age: json['Age'] ?? '',
      gender: json['Gender'] ?? '',
      region: json['Region'] ?? '',
      constituency: json['Constituency'] ?? '',
      email: json['Email'] ?? '',
      role: json['Role'] ?? '',
      password: json['Password'] ?? '',
    );
  }
}
