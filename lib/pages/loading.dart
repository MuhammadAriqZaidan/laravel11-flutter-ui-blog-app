import 'package:flutter/material.dart';
import 'package:flutter_laravel_blog/constant.dart';
import 'package:flutter_laravel_blog/models/api_response.dart';
import 'package:flutter_laravel_blog/pages/home_page.dart';
import 'package:flutter_laravel_blog/pages/login_blog_page.dart';
import 'package:flutter_laravel_blog/services/user_services.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _loadUserInfo() async {
    try {
      String token = await getToken();
      if (token == '') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginBlogPage()),
          (route) => false,
        );
      } else {
        ApiResponse response = await getUserDetail();
        if (response.error == null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
        } else if (response.error == unauthorized) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginBlogPage()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${response.error}')),
          );
        }
      }
    } catch (e) {
      // Tangani jika ada exception saat mengambil detail user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
