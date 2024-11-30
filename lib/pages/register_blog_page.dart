import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_laravel_blog/constant.dart';
import 'package:flutter_laravel_blog/models/api_response.dart';
import 'package:flutter_laravel_blog/models/user.dart';
import 'package:flutter_laravel_blog/pages/home_page.dart';
import 'package:flutter_laravel_blog/services/user_services.dart';

class RegisterBlogPage extends StatefulWidget {
  const RegisterBlogPage({super.key});

  @override
  State<RegisterBlogPage> createState() => _RegisterBlogPageState();
}

class _RegisterBlogPageState extends State<RegisterBlogPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmControler = TextEditingController();

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
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
                // icon atau image yang menandakan halaman login
                TextFormField(
                    controller: nameController,
                    validator: (val) => val!.isEmpty ? 'Invalid name' : null,
                    decoration: kInputDecoration("Name")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (val) =>
                        val!.isEmpty ? 'Invalid Email Address' : null,
                    decoration: kInputDecoration("Email")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: passwordController,
                    validator: (val) =>
                        val!.length < 6 ? 'Required at least 6 chars' : null,
                    obscureText: true,
                    decoration: kInputDecoration("Password")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: passwordConfirmControler,
                    validator: (val) => val != passwordController.text
                        ? 'Confirm password does not match'
                        : null,
                    obscureText: true,
                    decoration: kInputDecoration("Confirm Password")),
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : kTextButton("Login", () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                            _registerUser();
                          });
                        }
                      }),
                SizedBox(
                  height: 10,
                ),
                kLoginRegisterHint("Don't have an Account? ", "Register", () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => RegisterBlogPage()),
                      (route) => false);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
