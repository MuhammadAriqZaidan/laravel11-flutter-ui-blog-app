import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_laravel_blog/constant.dart';
import 'package:flutter_laravel_blog/models/api_response.dart';
import 'package:flutter_laravel_blog/models/user.dart';
import 'package:flutter_laravel_blog/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel_blog/pages/register_blog_page.dart';
import 'package:flutter_laravel_blog/services/user_services.dart';

class LoginBlogPage extends StatefulWidget {
  const LoginBlogPage({super.key});

  @override
  State<LoginBlogPage> createState() => _LoginBlogPageState();
}

class _LoginBlogPageState extends State<LoginBlogPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    try {
      ApiResponse response = await login(txtEmail.text, txtPassword.text);
      if (response.error == null) {
        _saveAndRedirectToHome(response.data as User);
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${response.error}")),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: ${e.toString()}")),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", user.token ?? '');
    await pref.setInt("userId", user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formkey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: txtEmail,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Invalid Email Address';
                    }
                    // Validasi format email dengan regex
                    String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(val)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: kInputDecoration("Email"),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: txtPassword,
                  validator: (val) =>
                      val!.length < 6 ? 'Required at least 6 chars' : null,
                  obscureText: true,
                  decoration: kInputDecoration("Password"),
                ),
                const SizedBox(height: 20),
                loading
                    ? Center(child: CircularProgressIndicator())
                    : kTextButton("Login", () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          _loginUser();
                        }
                      }),
                SizedBox(height: 10),
                kLoginRegisterHint("Don't have an Account? ", "Register", () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => RegisterBlogPage()),
                      (route) => false);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
