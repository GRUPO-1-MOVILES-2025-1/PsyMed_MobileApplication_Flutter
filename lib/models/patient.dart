class Patient {
  final String name;
  final int age;
  final String phone;
  final String email;

  Patient({
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['name'],
      age: json['age'],
      phone: json['phone'],
      email: json['email'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'phone': phone,
      'email': email,
    };
  }
}
