import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_feed/features/auth/pages/login_page.dart';
import 'package:zoo_feed/features/auth/widgets/footer.dart';
import 'package:http/http.dart' as http;

import '../../../common/utils/coloors.dart';
import '../../../common/widgets/custom_elevated_button.dart';
import '../../../common/widgets/custom_passwordfield.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../page_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController ageC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  bool isLoading = false;

  void signUp() async {
    final dataSignUp = {
      'name': nameC.text,
      'age': ageC.text,
      'email': emailC.text,
      'password': passwordC.text,
      'roleId': '1',
    };
    final url = Uri.parse('http://13.55.144.244:3000/api/users/create');
    final responseSignUp = await http.post(url, body: dataSignUp);

    if (responseSignUp.statusCode == 201) {
      final responseSignIn = await http.post(
        Uri.parse('http://13.55.144.244:3000/api/users/login'),
        body: {
          'email': emailC.text,
          'password': passwordC.text,
        },
      );
      if (responseSignIn.statusCode == 200) {
        final Map<String, dynamic> dataResponse =
            json.decode(responseSignIn.body);
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
    } else {
      throw Exception('Failed to Sign Up');
    }
  }

  void vaildation() async {
    if (emailC.text.isEmpty &&
        ageC.text.isEmpty &&
        passwordC.text.isEmpty &&
        nameC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Fields Are Empty"),
        ),
      );
    } else if (emailC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (ageC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Age Is Empty"),
        ),
      );
    } else if (nameC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name Is Empty"),
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
      signUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return const Text(
        'Sign Up',
        style: TextStyle(
            color: Colors.black, fontSize: 40, fontWeight: FontWeight.w500),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Coloors.green,
            weight: 50,
            size: 30,
          ),
        ),
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
              image: 'assets/icon/Name.png',
              controller: nameC,
              hintText: 'Full Name',
              keyBoardType: TextInputType.text,
              read: false,
            ),
            CustomTextField(
              image: 'assets/icon/calendar.png',
              controller: ageC,
              hintText: 'Age',
              keyBoardType: TextInputType.number,
              read: false,
            ),
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
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomElevatedButton(
                    onPressed: vaildation,
                    text: 'Sign Up',
                    isOutline: false,
                  ),
            Footer(
              text: 'Already have an account?',
              title: 'Sign In',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
