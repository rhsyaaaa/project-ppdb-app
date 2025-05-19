
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF0F5F3E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Sekolah
              SizedBox(height: 20),
              Image.asset(
                'assets/images/logoMQ-1.png', // Ganti dengan logo sekolah kamu
                height: 120,
              ),

              SizedBox(height: 24),

              // Judul
              Text(
                'Login in to Your Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 8),
              Text(
                'Select method to Login',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),

              SizedBox(height: 24),

              // Input Email
              TextField(
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

              // Input Password
              TextField(
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
                  onPressed: () {},
                  child: Text(
                    'ForgotPassword',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Aksi login
                  },
                  child: Text('Login', style: TextStyle(color: Colors.white),),
                ),
              ),

              SizedBox(height: 16),

              // Register Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont Have an account? "),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman Register
                      context.go('/register');
                    },
                    child: Text(
                      'Register Here',
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Text('or login with'),

              SizedBox(height: 10),

              // Tombol Google
              GestureDetector(
                onTap: () {
                  // Google login
                },
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
                        'assets/images/Google Logo.png', // Tambahkan logo Google
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
    );
  }
}