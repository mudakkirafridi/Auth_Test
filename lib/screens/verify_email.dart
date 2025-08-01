import 'package:auth/auth_provider/auth_provider.dart';
import 'package:auth/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final codeController = TextEditingController();

  void verify() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await provider.verifyEmail(
        email: widget.email,
        code: codeController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email verified successfully!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void resendCode() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await provider.sendVerificationEmail(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification code sent again to ${widget.email}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to resend code: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(title: Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Enter the code sent to ${widget.email}"),
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: "Verification Code"),
            ),
            const SizedBox(height: 16),
            loading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: verify,
                        child: Text("Verify Email"),
                      ),
                      TextButton(
                        onPressed: resendCode,
                        child: Text("Resend Code"),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
