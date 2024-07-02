import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';
import 'package:stocksapp/features/auth/presentation/widgets/buildButton.dart';

import '../widgets/buildTextField.dart';
import 'loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthServiceProvider authProvider =
        Provider.of<AuthServiceProvider>(context);
    return (authProvider.isLoading)
        ? Dialog(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
            backgroundColor: Colors.transparent,
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 200,
                    ),
                    buildTextField(
                        controller: _nameController,
                        title: 'Name',
                        icon: Icons.person_2_outlined),
                    buildTextField(
                        controller: _emailController,
                        title: 'Email',
                        icon: Icons.alternate_email),
                    buildTextField(
                        controller: _passwordController,
                        title: 'Password',
                        icon: Icons.lock),
                    buildButton(
                        title: 'Create Account',
                        callback: () {
                          UserModel user = UserModel(
                              uid: '',
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              dob: DateTime.now());
                          authProvider.registerUser(
                              context: context,
                              user: user,
                              password: _passwordController.text.trim());
                        }),
                    buildButton(
                        title: 'SignOut',
                        callback: () {
                          authProvider.signOut();
                        }),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: RichText(
                        text: TextSpan(
                            text: 'Already have an account?? ',
                            style: GoogleFonts.poppins(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: 'Login',
                                  style:
                                      GoogleFonts.poppins(color: Colors.green))
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
