import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_app/service/auth_service.dart';

class LoginPage extends StatefulWidget {
 LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color primaryColor = Color(0xFF0F5F3E);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("Email dan password tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    AuthService().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      context,
    );

    setState(() => _isLoading = false);
  }

  void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    await AuthService().sign_with_google(context);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               SizedBox(height: 20),
                Image.asset('assets/images/logoMQ-1.png', height: 120),

               SizedBox(height: 24),
               Text(
                  'Login to Your Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
               SizedBox(height: 8),
                Text(
                  'Select method to Login',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
               SizedBox(height: 24),

                // Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Gmail',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
               SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

               SizedBox(height: 10),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      AuthService().forgotPassword(context);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),

               SizedBox(height: 10),

                // Tombol Login
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                ),

               SizedBox(height: 16),

                // Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        context.go('/register');
                      },
                      child: Text(
                        'Register Here',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

               SizedBox(height: 20),
               Text('or login with'),
               SizedBox(height: 10),

                // Google Sign In
                GestureDetector(
                  onTap: _handleGoogleLogin,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Google Logo.png',
                          height: 20,
                        ),
                       SizedBox(width: 10),
                       Text('Sign In with Google'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
