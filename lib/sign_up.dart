import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  User? user;
  String? _verificationId;
  bool _isCodeSent = false;
  bool _isVerified = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 113, 177, 250),
      ),
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
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: size.width < 490 ? 16 : 500),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: const Color.fromARGB(255, 118, 144, 250),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Create Account',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          controller: _userNameController,
                          name: 'username',
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0), // Set border color and width
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0), // Set border color and width
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(4),
                          ]),
                        ),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          controller: _phoneController,
                          name: 'number',
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            prefixText: '+84 ',
                            suffix: _isVerified
                                ? const Icon(Icons.check)
                                : Material(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    clipBehavior: Clip.hardEdge,
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () => _verifyPhoneNumber(),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text('Send OTP'),
                                      ),
                                    )),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0), // Set border color and width
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0), // Set border color and width
                            ),
                            labelText: 'Number',
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.match(r'^\+[1-9]\d{1,14}$',
                                errorText:
                                    'Invalid phone number format. Please include country code (+84 for Vietnam).'),
                          ]),
                        ),
                        _isCodeSent
                            ? Column(
                                children: [
                                  const SizedBox(height: 20),
                                  FormBuilderTextField(
                                    controller: _codeController,
                                    name: 'otp',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      suffix: Material(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          clipBehavior: Clip.hardEdge,
                                          color: Colors.white,
                                          child: InkWell(
                                            onTap: () =>
                                                _signInWithPhoneNumber(),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text('Verify'),
                                            ),
                                          )),
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white,
                                            width:
                                                2.0), // Set border color and width
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white,
                                            width:
                                                2.0), // Set border color and width
                                      ),
                                      labelText: 'OTP',
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          controller: _passwordController,
                          name: 'password',
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0), // Set border color and width
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0), // Set border color and width
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0)),
                          ),
                          obscureText: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(6),
                          ]),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (!_isVerified) {
                              _dialogBuilder(context, () {},
                                  'Số điện thoại chưa được xác nhận');
                              return;
                            }
                            final isSaved = await _saveUserDataToDatabase(
                                user?.uid ?? '',
                                _phoneController.text,
                                _userNameController.text,
                                _passwordController.text);
                            if (isSaved) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    log(_phoneController.text);
    await _auth.verifyPhoneNumber(
      phoneNumber: '+84${_phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        log('Phone number automatically verified and user signed in: ${credential.smsCode}');
      },
      verificationFailed: (FirebaseAuthException e) {
        _dialogBuilder(context, () {}, e.message ?? '');
        log('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        setState(() {
          _isCodeSent = true;
          _verificationId = verificationId;
        });
        log('Please check your phone for the verification code.');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
        log('verification code: "timeout"');
      },
    );
  }

  void _signInWithPhoneNumber() async {
    final code = _codeController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: code);

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      user = userCredential.user;
      setState(() {
        _isCodeSent = false;
        _isVerified = true;
      });
    } catch (e) {
      _dialogBuilder(context, () {}, '$e');
    }
  }

  Future<bool> _saveUserDataToDatabase(
      String uid, String phoneNumber, String username, String password) async {
    try {
      await FirebaseDatabase.instance.ref().child('users').child(username).set({
        'phoneNumber': phoneNumber,
        'username': username,
        'password': password,
      });
      return true;
    } catch (e) {
      log('Failed to save user data: $e');
      _dialogBuilder(context, () {}, e.toString());
      return false;
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
