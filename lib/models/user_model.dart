class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}