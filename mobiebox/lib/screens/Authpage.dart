import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true; // Toggle between Login and Signup
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);

    // Choose endpoint based on mode
    final endpoint = isLogin ? "login.php" : "signup.php";
    final url = Uri.parse("http://localhost/movies_backend/api/$endpoint");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "username": _userController.text.trim(),
          "password": _passController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        if (isLogin) {
          Navigator.pop(context, {
            'id': data['id'],
            'username': data['username'],
            'role': data['role'],
          });
        } else {
          // If signup success, switch to login mode automatically
          setState(() => isLogin = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account created! Please login.")),
          );
        }
      } else {
        _showError(data['message']);
      }
    } catch (e) {
      _showError("Connection error. Check your server." + e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Colors.black, Color(0xFF1a1a1a), Color(0xFF330000)],
          ),
        ),
        child: Stack(
          children: [
            // 🔙 BACK BUTTON
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🎥 Logo or Icon
                  const Icon(
                    Icons.movie_filter,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isLogin ? "Welcome Back" : "Create Account",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Glassmorphic Input Field Container
                  _buildTextField(
                    _userController,
                    "Username",
                    Icons.person,
                    false,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    _passController,
                    "Password",
                    Icons.lock,
                    true,
                  ),

                  const SizedBox(height: 30),

                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.redAccent)
                      : SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: _handleAuth,
                            child: Text(
                              isLogin ? "LOGIN" : "SIGN UP",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Login",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.redAccent),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
