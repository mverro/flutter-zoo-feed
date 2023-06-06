import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zoo_feed/common/utils/coloors.dart';
import 'package:zoo_feed/common/widgets/custom_elevated_button.dart';
import 'package:zoo_feed/common/widgets/custom_passwordfield.dart';
import 'package:zoo_feed/common/widgets/custom_textfield.dart';
import 'package:zoo_feed/features/auth/pages/sign_up_page.dart';
import 'package:zoo_feed/features/auth/widgets/footer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_feed/features/page_controller.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = RegExp(p);

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    final data = {'email': emailC.text, 'password': passwordC.text};
    final response = await http.post(
        Uri.parse('http://13.55.144.244:3000/api/users/login'),
        body: data);
    if (response.statusCode == 200) {
      final Map<String, dynamic> dataResponse = json.decode(response.body);

      final pref = await SharedPreferences.getInstance();
      pref.setString('access_token', dataResponse['access_token']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
      setState(() {});
    } else {
      throw Exception('Failed to login');
    }
  }

  void vaildation() async {
    if (emailC.text.isEmpty && passwordC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Both Flied Are Empty"),
        ),
      );
    } else if (emailC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(emailC.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Try Vaild Email"),
        ),
      );
    } else if (passwordC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else {
      setState(() {
        isLoading = true;
      });
      login();
    }
  }

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return const Text(
        'Log In',
        style: TextStyle(
            color: Colors.black, fontSize: 40, fontWeight: FontWeight.w500),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title(),
            const SizedBox(height: 30),
            CustomTextField(
              image: 'assets/icon/Mail.png',
              controller: emailC,
              hintText: 'Email',
              keyBoardType: TextInputType.emailAddress,
              read: false,
            ),
            CustomPasswordField(controller: passwordC),
            const SizedBox(height: 30),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomElevatedButton(
                    onPressed: vaildation,
                    text: 'Log In',
                    isOutline: false,
                  ),
            Footer(
              text: 'Don’t have an account?',
              title: 'Sign Up',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpPage(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
