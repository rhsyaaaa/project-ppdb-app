
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF0F5F3E); // warna hijau gelap

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Sekolah
              SizedBox(height: 20),
              Image.asset(
                'assets/images/logoMQ-1.png', // Ganti dengan path logo sekolah
                height: 120,
              ),

              SizedBox(height: 24),

              // Judul
              Text(
                'Register Your Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Select method to register',
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

              // Input Username
              TextField(
                decoration: InputDecoration(
                  hintText: 'Username',
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

              SizedBox(height: 24),

              // Tombol Register
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
                    // Aksi register
                  },
                  child: Text('Register', style: TextStyle(color: Colors.white),),
                ),
              ),

              SizedBox(height: 16),

              // Punya akun?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already an account? "),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman login
                      context.go('/login');
                    },
                    child: Text(
                      'Login here',
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Atau login dengan Google
              Text('or register with'),

              SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  // Google sign-in
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