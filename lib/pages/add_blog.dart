import 'package:flutter/material.dart';
import 'package:flutter_laravel_blog/services/post_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_laravel_blog/models/api_response.dart'; // Import ApiResponse

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final ImagePicker _picker = ImagePicker(); // Instance ImagePicker
  XFile? _selectedImage; // Variabel untuk menyimpan gambar yang dipilih
  final TextEditingController _contentController = TextEditingController();

  Future<void> _pickImage() async {
    // Memilih gambar dari galeri
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image; // Simpan gambar yang dipilih
      });
      print('Image selected: ${image.path}');
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Add Blog',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: _selectedImage == null
                        ? BoxDecoration(
                            color: Colors.blue, // Warna latar belakang
                          )
                        : BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(_selectedImage!.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate,
                                  size: 40, color: Colors.white),
                              SizedBox(height: 8),
                              Text(
                                'Tambahkan Foto/Video',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        : null, // Tidak ada child jika gambar dipilih
                  ),
                ),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Apa yang kamu Pikirkan? 🤔',
                  border: OutlineInputBorder(),
                  hintText: 'Tulis Sesuatu disini... ✏️',
                ),
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 8,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  String content = _contentController.text;

                  if (_selectedImage != null && content.isNotEmpty) {
                    // Panggil API untuk menambahkan post
                    String imagePath = _selectedImage!.path;
                    ApiResponse response = await addPost(content, imagePath);

                    if (response.isSuccess) {
                      // Post berhasil
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Postingan berhasil ditambahkan'),
                        ),
                      );
                      Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                    } else {
                      // Tampilkan error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response.error ?? 'Terjadi kesalahan'),
                        ),
                      );
                    }
                  } else {
                    // Validasi input kosong
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Harap isi konten dan pilih gambar')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  'Tambahkan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
