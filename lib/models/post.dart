import 'user.dart';

/// Model Post yang merepresentasikan data postingan.
class Post {
  int? id; // ID postingan
  String? body; // Isi postingan
  String? image; // URL gambar postingan
  int likesCount; // Jumlah likes
  int commentsCount; // Jumlah komentar
  bool selfLiked; // Apakah user telah menyukai postingan
  User? user; // Informasi user yang membuat postingan

  /// Constructor dengan nilai default untuk likesCount dan commentsCount.
  Post({
    this.id,
    this.body,
    this.image,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.selfLiked = false,
    this.user,
  });

  /// Factory untuk mapping JSON ke model Post.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      body: json['body'],
      image: json['image'],
      likesCount: json['likes_count'] ?? 0, // Nilai default 0
      commentsCount: json['comments_count'] ?? 0, // Nilai default 0
      selfLiked: json['selfLiked'] ?? false, // Pastikan boolean, fallback false
      user: json['user'] != null // Jika user ada, parse
          ? User.fromJson(json['user']) // Parse hanya bagian user
          : null, // Jika tidak ada user, beri null
    );
  }
}
