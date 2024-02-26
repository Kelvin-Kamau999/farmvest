import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofarmer/common/custom_dropdown.dart';
import 'package:cofarmer/common/custom_textfield.dart';
import 'package:cofarmer/common/initial_loading.dart';
import 'package:cofarmer/common/primary_button.dart';
import 'package:cofarmer/models/user_model.dart';
import 'package:cofarmer/providers/auth_provider.dart';
import 'package:cofarmer/screens/auth/forgot_password.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.isSignUp = false});
  final bool isSignUp;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isSignUp = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    setState(() {
      isSignUp = widget.isSignUp;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false;
  String selectedUserType = '';
  List<String> userTypes = ['Farmer', 'Investor'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: isSignUp ? 40 : 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: isSignUp ? 25 : 50,
            ),
            Text(isSignUp ? 'Create an account' : 'Hi, Welcome Back! 👋',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(
              isSignUp
                  ? 'Grow your agri-investment porfolio today!'
                  : 'Hello again, you have been missed!',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (isSignUp)
              const Text(
                'Legal name',
                style: TextStyle(color: kPrimaryColor),
              ),
            if (isSignUp)
              const SizedBox(
                height: 8,
              ),
            if (isSignUp)
              CustomTextField(
                  controller: nameController, hintText: 'Enter your name'),
            if (isSignUp)
              const SizedBox(
                height: 16,
              ),
            const Text(
              'Email address',
              style: TextStyle(color: kPrimaryColor),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
                controller: emailController, hintText: 'Enter your email'),
            const SizedBox(
              height: 16,
            ),
            if (isSignUp)
              const Text(
                'Phone number',
                style: TextStyle(color: kPrimaryColor),
              ),
            if (isSignUp)
              const SizedBox(
                height: 8,
              ),
            if (isSignUp)
              CustomTextField(
                  controller: phoneController,
                  hintText: 'Enter your phone number'),
            if (isSignUp)
              const SizedBox(
                height: 16,
              ),
            const Text(
              'Password',
              style: TextStyle(color: kPrimaryColor),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
                controller: passwordController,
                isPassword: true,
                hintText: 'Enter your password'),
            const SizedBox(
              height: 10,
            ),
            if (isSignUp)
              const Text(
                'Register as',
                style: TextStyle(color: kPrimaryColor),
              ),
            if (isSignUp)
              CustomDropdown(
                  selectedOption: (val) {
                    setState(() {
                      selectedUserType = val;
                    });
                  },
                  options: userTypes,
                  hintText: 'Select your role'),
            if (isSignUp)
              const SizedBox(
                height: 14,
              ),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (val) {},
                  activeColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                const Text('Remember me'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Get.to(() => const ForgotPasswordScreen());
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: isSignUp ? 'Create an account' : 'Login',
              isLoading: isLoading,
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  if (!isSignUp) {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .login(emailController.text, passwordController.text);
                  } else {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        selectedUserType.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill in all fields'),
                        backgroundColor: Colors.red,
                      ));
                    }

                    final user = UserModel(
                        name: nameController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                        userType: selectedUserType.toLowerCase(),
                        password: passwordController.text,
                        createdAt: Timestamp.now());
                    await Provider.of<AuthProvider>(context, listen: false)
                        .signUp(user);
                  }

                  setState(() {
                    isLoading = false;
                  });
                  Get.offAll(() => const InitialLoadingScreen());
                } catch (e) {
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ));
                }
              },
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isSignUp
                      ? 'Already have an account?'
                      : 'Don\'t have an account?',
                  style: const TextStyle(color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        isSignUp = !isSignUp;
                      });
                    },
                    child: Text(
                      isSignUp ? "Login" : 'Create an account',
                      style: const TextStyle(
                          color: kPrimaryColor,
                          decoration: TextDecoration.underline),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
