import 'dart:developer';

import 'package:bmsp/controller.dart';
import 'package:bmsp/home_page.dart';
import 'package:bmsp/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 113, 177, 250),
              Color.fromARGB(255, 125, 179, 245),
              Color.fromARGB(255, 30, 132, 248),
              Color.fromARGB(255, 2, 91, 199),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _renderHeader(size),
              const SizedBox(height: 70),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _renderForm(context),
              _renderloginIcon(context),
              const SizedBox(height: 20.0),
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return RegisterPage();
                  }));
                },
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Made by Nam',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _renderloginIcon(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => signInWithGoogle(context),
          child: _buildSocialLoginButton(
            context,
            FontAwesomeIcons.google,
            'Sign in with Google',
            const Color(0xFFDB4437),
            () {
              // Add your Google sign-in logic here
            },
          ),
        ),
        const SizedBox(width: 20.0),
        _buildSocialLoginButton(
          context,
          FontAwesomeIcons.apple,
          'Sign in with Apple',
          const Color(0xFF000000),
          () {
            // Add your Apple sign-in logic here
          },
        ),
      ],
    );
  }

  Padding _renderForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 500),
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          _buildTextField('Username', _usernameController),
          const SizedBox(height: 20.0),
          _buildTextField('Password', _passwordController, obscureText: true),
          const SizedBox(height: 30.0),
          _buildLoginButton(context),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Padding _renderHeader(Size size) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo_ute.png',
              height: 100,
              filterQuality: FilterQuality.high,
            ),
          ),
          SizedBox(
            width: size.width * 0.168,
          ),
          Column(
            children: [
              const Text(
                'TRƯỜNG ĐẠI HỌC SƯ PHẠM KỸ THUẬT TP.HỒ CHÍ MINH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.alternative(0)],
                ),
              ),
              const SizedBox(
                  height: 10.0), // Add some space between text and the line
              Container(
                width: size.width * 0.51747312,
                height: 1.0,
                color: Colors.white,
              ),
              const Text(
                'Địa chỉ: 1 Võ Văn Ngân, Phường Linh Chiểu, Thành phố Thủ Đức, Thành phố Hồ Chí Minh.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  fontFeatures: [FontFeature.alternative(0)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Image.asset('asset/images/logo_ute.png'),
    );
  }

  Widget _buildTextField(
      String hintText, TextEditingController? textEditingController,
      {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: textEditingController,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            obscureText ? Icons.lock : Icons.person,
            color: const Color(0xFF6CA8F1),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black38),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            spreadRadius: -10,
            blurRadius: 15,
            offset: const Offset(-5, -5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          _signInWithUsernamePassword(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(BuildContext context, IconData icon,
      String text, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FaIcon(icon, color: Colors.white),
      ),
    );
  }

  void _signInWithUsernamePassword(BuildContext context) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Kiểm tra thông tin người dùng từ Realtime Database
      final DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users');
      final DatabaseEvent event =
          await userRef.orderByChild('username').equalTo(username).once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        final Map<String, dynamic> userData =
            Map<String, dynamic>.from((snapshot.value as Map).values.first);
        final String savedPassword = userData['password'];
        log(userData['password']);
        if (savedPassword == password) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const MyHomePage()));
        } else {
          _dialogBuilder(context, () {}, 'invalid username or password');
        }
      } else {
        _dialogBuilder(context, () {}, "User not found.");
      }
    } catch (e) {
      _dialogBuilder(context, () {}, "Failed to sign in: $e");
    }
  }

  Future<void> _dialogBuilder(
      BuildContext context, VoidCallback? onTapConfirm, String errorText) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Phone Error'),
          content: Text(errorText),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
              onPressed: onTapConfirm,
            ),
          ],
        );
      },
    );
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    User? user;
    // Khởi tạo đối tượng GoogleSignIn
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  } catch (e) {
    // Xử lý lỗi nếu có
    log('Sign in with Google failed: $e');
    return;
  }
}
