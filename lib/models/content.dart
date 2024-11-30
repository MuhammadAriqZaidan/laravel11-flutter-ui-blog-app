class Content {
  final String nama;
  final String title;
  final String image;

  Content({required this.nama, required this.title, required this.image});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      nama: json['nama'],
      title: json['title'],
      image: json['image'], // Pastikan sesuai dengan data JSON dari API
    );
  }
}
