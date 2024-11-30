import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_laravel_blog/models/api_response.dart';
import 'package:flutter_laravel_blog/models/user.dart';
import 'package:flutter_laravel_blog/pages/login_blog_page.dart';
import 'package:flutter_laravel_blog/services/user_services.dart';
import 'package:image_picker/image_picker.dart';
import '../constant.dart';
import 'package:http/http.dart' as http;

class ProfileBlog extends StatefulWidget {
  const ProfileBlog({super.key});

  @override
  State<ProfileBlog> createState() => _ProfileBlogState();
}

class _ProfileBlogState extends State<ProfileBlog> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();

  String? getStringImage(File? file) {
    if (file == null) return null;
    return base64Encode(file.readAsBytesSync());
  }

  Future<ApiResponse> updateUser(String name, String? image) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Token autentikasi
      String token = await getToken(); // Pastikan fungsi getToken() sudah ada

      // Body request
      Map<String, dynamic> body = {'name': name};
      if (image != null) {
        body['image'] = image;
      }

      // Permintaan HTTP PUT
      final response = await http.put(
        Uri.parse(
            '$baseURL/user'), // Pastikan $baseURL sudah diatur di constant.dart
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = jsonDecode(response.body)['error'];
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginBlogPage()),
              (route) => false,
            )
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  // Update profile
  void updateProfile() async {
    ApiResponse response =
        await updateUser(txtNameController.text, getStringImage(_imageFile));
    setState(() {
      loading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.data}'),
      ));
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginBlogPage()),
              (route) => false,
            )
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: _imageFile == null
                            ? user!.image != null
                                ? DecorationImage(
                                    image: NetworkImage('${user!.image}'),
                                    fit: BoxFit.cover,
                                  )
                                : null
                            : DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              ),
                        color: Colors.amber,
                      ),
                    ),
                    onTap: () {
                      getImage();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: kInputDecoration('Name'),
                    controller: txtNameController,
                    validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                kTextButton('Update', () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    updateProfile();
                  }
                })
              ],
            ),
          );
  }
}
