class User {
  final String id;
  final String name;
  final String email;
  final String? phone;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
