import 'dart:convert';
import 'dart:io';
import 'package:flutter_laravel_blog/constant.dart';
import 'package:flutter_laravel_blog/models/api_response.dart';
import 'package:flutter_laravel_blog/models/content.dart';
import 'package:flutter_laravel_blog/models/post.dart';
import 'package:flutter_laravel_blog/services/user_services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import untuk pengaturan mime type

// Fungsi untuk mengambil daftar post dari API
Future<List<Content>> fetchPosts() async {
  try {
    final response = await http.get(Uri.parse(postsURL));

    print('Status Code: ${response.statusCode}'); // Log status code
    print('Response Body: ${response.body}'); // Log isi response

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((post) => Content.fromJson(post)).toList();
    } else {
      throw Exception(
          'Failed to load posts, Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e'); // Log error
    throw Exception('Failed to load posts');
  }
}

// Fungsi untuk membuat post baru dengan konten dan gambar
Future<ApiResponse> createPost(String body, File? imageFile) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Ambil token untuk autentikasi
    String token = await getToken();

    if (token.isEmpty) {
      apiResponse.error = 'Unauthorized. Please log in.';
      return apiResponse;
    }

    // Jika ada file gambar, ubah ke base64
    String? imageBase64;
    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();
      imageBase64 = base64Encode(imageBytes);
    }

    // Kirim request ke server
    final response = await http.post(
      Uri.parse(postsURL),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // JSON request
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'body': body,
        'image': imageBase64, // Base64 string untuk gambar (nullable)
      }),
    );

    // Tangani response
    switch (response.statusCode) {
      case 201: // Created
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401: // Unauthorized
        apiResponse.error = 'Unauthorized. Please log in.';
        break;
      default: // Error lainnya
        apiResponse.error = 'Error: ${response.statusCode} - ${response.body}';
    }
  } catch (e) {
    apiResponse.error = 'An error occurred: $e';
  }

  return apiResponse;
}

// Fungsi untuk menambahkan post baru dengan autentikasi token
Future<ApiResponse> addPost(String content, String imagePath) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Ambil token dari layanan user
    String token = await getToken();
    if (token.isEmpty) {
      apiResponse.error =
          'Token tidak ditemukan. Silakan login terlebih dahulu.';
      return apiResponse;
    }

    // Persiapkan permintaan HTTP multipart untuk mengirim data
    var request = http.MultipartRequest('POST', Uri.parse(postsURL));
    request.fields['content'] = content; // Tambahkan konten
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imagePath,
      contentType: MediaType('image', 'jpeg'), // Pastikan tipe media sesuai
    ));
    request.headers['Authorization'] =
        'Bearer $token'; // Tambahkan header token

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Proses respons dari server
    switch (response.statusCode) {
      case 200:
      case 201:
        apiResponse.data =
            jsonDecode(response.body); // Jika sukses, parsing data
        break;
      default:
        apiResponse.error = 'Error: ${response.statusCode} - ${response.body}';
    }
  } catch (e) {
    apiResponse.error = 'An error occurred: $e'; // Tangani error
  }
  return apiResponse;
}

// Fungsi untuk mengambil daftar post dengan autentikasi
Future<ApiResponse> getPosts() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    if (token.isEmpty) {
      apiResponse.error =
          'Token tidak ditemukan. Silakan login terlebih dahulu.';
      return apiResponse;
    }

    // Kirim request ke API dengan header authorization
    final response = await http.get(
      Uri.parse(postsURL),
      headers: {
        'accept': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    // Proses status kode respons
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('posts')) {
          List posts = jsonResponse['posts'];
          apiResponse.data = posts.map((p) => Post.fromJson(p)).toList();
        } else {
          apiResponse.error = 'Format response tidak sesuai';
        }
        break;
      case 401:
        apiResponse.error = 'Unauthorized. Silakan login terlebih dahulu.';
        break;
      default:
        apiResponse.error = 'Error: ${response.statusCode} - ${response.body}';
    }
  } catch (e) {
    apiResponse.error = 'An error occurred: $e';
  }
  return apiResponse;
}
