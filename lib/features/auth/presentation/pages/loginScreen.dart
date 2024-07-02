import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/auth/presentation/pages/registerScreen.dart';
import '../widgets/buildButton.dart';
import '../../domain/manager/authProvider.dart';
import '../widgets/buildTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthServiceProvider authProvider =
        Provider.of<AuthServiceProvider>(context);
    return (authProvider.isLoading)
        ? Dialog(
            surfaceTintColor: Colors.transparent,
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
                        controller: _emailController,
                        title: 'Email',
                        icon: Icons.alternate_email),
                    buildTextField(
                        controller: _passwordController,
                        title: 'Password',
                        icon: Icons.lock),
                    buildButton(
                        title: 'Login',
                        callback: () {
                          authProvider.loginUser(
                              context: context,
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim());
                        }),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: RichText(
                        text: TextSpan(
                            text: "Don\'t have an account?? ",
                            style: GoogleFonts.poppins(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: 'Register',
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
