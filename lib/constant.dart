// STRINGS
import 'package:flutter/material.dart';

// URL dasar untuk API, digunakan sebagai awalan untuk semua endpoint lainnya
const baseURL = 'http://127.0.0.1:8000/api';

// Endpoint untuk registrasi pengguna, digunakan untuk mendaftar pengguna baru
const registerURL = '$baseURL/register';

// Endpoint untuk login pengguna, digunakan untuk proses autentikasi pengguna
const loginURL = '$baseURL/login';

// Endpoint untuk logout pengguna, digunakan untuk menghapus sesi pengguna yang sedang aktif
const logoutURL = '$baseURL/logout';

// Endpoint untuk mendapatkan data pengguna, digunakan untuk mengambil informasi pengguna yang sudah login
const userURL = '$baseURL/user';

// Endpoint untuk mendapatkan semua postingan, digunakan untuk menampilkan daftar postingan di halaman utama
const postsURL = '$baseURL/posts';

// Endpoint untuk membuat postingan, digunakan untuk membuat postingan baru
const createPostURL = '$baseURL/posts';

// Endpoint untuk mendapatkan postingan berdasarkan ID, digunakan untuk menampilkan detail postingan tertentu
const postByIdURL = '$baseURL/posts/'; // Gunakan ini dengan menambahkan ID di akhir URL, seperti 'http://localhost:8000/api/posts/1'

// Endpoint untuk mendapatkan komentar, digunakan untuk mengambil daftar komentar dari sebuah postingan
const commentsURL = '$baseURL/posts/'; // Ditambahkan endpoint ini hanya jika Anda perlu mengambil komentar untuk setiap postingan


// ERROR
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, please try again!';

// Input Decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: EdgeInsets.all(10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(width: 1, color: Colors.black),
    ),
  );
}

// Button
TextButton kTextButton(String label, VoidCallback onPressed) {
  return TextButton(
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith(
        (states) => Colors.blue,
      ),
      padding: MaterialStateProperty.resolveWith(
        (states) => EdgeInsets.symmetric(vertical: 10),
      ),
    ),
    onPressed: onPressed, // Sudah langsung dipanggil
  );
}

// LoginRegisterHint
Row kLoginRegisterHint(String text, String label, VoidCallback onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(
          label,
          style: TextStyle(color: Colors.blue),
        ),
        onTap: onTap, // Dipanggil di sini
      ),
    ],
  );
}
