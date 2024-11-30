class User {
  final int id; // ID user (wajib ada)
  final String name; // Nama user (wajib ada)
  final String? image; // URL gambar profil user (opsional)
  final String? email; // Email user (opsional)
  final String? token; // Token autentikasi (opsional)

  User({
    required this.id,
    required this.name,
    this.image,
    this.email,
    this.token,
  });

  /// Factory untuk mapping JSON ke model User.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']?['id'] ?? 0, // Default ke 0 jika id tidak ada
      name: json['user']?['name'] ?? 'Unknown', // Default 'Unknown' jika name tidak ada
      image: json['user']?['image'], // Bisa null jika image tidak ada
      email: json['user']?['email'], // Bisa null jika email tidak ada
      token: json['token'], // Bisa null jika token tidak ada
    );
  }
}
