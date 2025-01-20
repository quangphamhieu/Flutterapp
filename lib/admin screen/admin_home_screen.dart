import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../screen/sign_in_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  void _signOut(BuildContext context) async {
    await AuthService().signOut();

    if (!context.mounted) return; // ✅ Kiểm tra widget có còn tồn tại không

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: const Center(child: Text('Chào mừng Admin!')),
    );
  }
}
