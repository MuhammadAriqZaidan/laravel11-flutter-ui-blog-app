import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_laravel_blog/models/api_response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_laravel_blog/constant.dart';
import 'package:flutter_laravel_blog/pages/home_page.dart';
import 'package:flutter_laravel_blog/services/post_services.dart'; // Import service untuk pengiriman data

class PostsBlogPage extends StatefulWidget {
  const PostsBlogPage({super.key});

  @override
  State<PostsBlogPage> createState() => _PostsBlogPageState();
}

class _PostsBlogPageState extends State<PostsBlogPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _postData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        // Gantilah `createPost` dengan fungsi yang sesuai di `post_services.dart`
        ApiResponse response = await createPost(_txtControllerBody.text, _imageFile);

        if (response.error == null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.error}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Blog',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: ListView(
                children: [
                  Container(
                    color: Colors.blueGrey,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: _imageFile == null
                        ? null
                        : BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_imageFile ?? File('')),
                              fit: BoxFit.cover,
                            ),
                          ),
                    child: IconButton(
                      onPressed: () {
                        getImage();
                      },
                      icon: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _txtControllerBody,
                        decoration: InputDecoration(
                          labelText: 'Apa yang kamu Pikirkan? 🤔',
                          border: OutlineInputBorder(),
                          hintText: 'Tulis Sesuatu disini... ✏️',
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 8,
                        validator: (val) =>
                            val!.isEmpty ? "Post Body is Required" : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: kTextButton("Post", () {
                      _postData();
                    }),
                  ),
                ],
              ),
            ),
    );
  }
}
