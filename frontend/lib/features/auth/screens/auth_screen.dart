import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/custom_textfield.dart';
import 'package:frontend/features/auth/services/auth_services.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/constants/enums.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;

  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  // Creating instance of AuthService class
  final AuthService authService = AuthService();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  // Focus Nodes
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    // Dispose all the TextEditingController
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();

    // Dispose all the FocusNodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),

              ListTile(
                title: const Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: secondaryColor,
                  value: Auth.signup,
                  groupValue: _auth,
                  onChanged: (Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.signup)
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Enter name',
                        focusNode: _nameFocusNode,
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter email',
                        focusNode: _emailFocusNode,
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Enter password',
                        focusNode: _passwordFocusNode,
                      ),
                      SizedBox(height: 25),
                      // SignUp Button
                      CustomElevatedButton(
                        text: "Sign Up ",
                        onPressed: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            signUpUser();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ListTile(
                title: const Text(
                  ' Sign in',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: secondaryColor,
                  value: Auth.signin,
                  groupValue: _auth,
                  onChanged: (Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.signin)
                Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter email',
                        focusNode: _emailFocusNode,
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Enter password',
                        focusNode: _passwordFocusNode,
                      ),
                      SizedBox(height: 25),
                      CustomElevatedButton(
                        text: "Login",
                        onPressed: () {
                          if (_signInFormKey.currentState!.validate()) {
                            signInUser();
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
