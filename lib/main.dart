import 'package:flutter_laravel_blog/pages/home_page.dart';
import 'package:flutter_laravel_blog/pages/login_blog_page.dart';
import 'package:flutter_laravel_blog/pages/profile_blog.dart';

import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginBlogPage(), 
    );
  }
}