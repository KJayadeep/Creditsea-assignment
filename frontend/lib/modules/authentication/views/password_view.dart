import 'package:flutter/material.dart';
import 'signup_view.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignupView(initialStep: 2);
  }
}
