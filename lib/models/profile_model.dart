class ProfileModel {
  final int id;
  final String fullName;
  final String email;
  final String weight;
  final String height;
  final String phone;
  final String role;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.weight,
    required this.height,
    required this.phone,
    required this.role,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      weight: json['weight'],
      height: json['height'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'weight': weight,
      'height': height,
      'phone': phone,
      'role': role,
    };
  }
}