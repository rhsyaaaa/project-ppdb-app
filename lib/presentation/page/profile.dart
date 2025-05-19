import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    String userName= user?.displayName ?? 'Your account';
    String email = user?.email ?? 'your@email.com';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0F5F3E)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'), // Ganti dengan logo kamu
              radius: 18,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // Profile Picture
          CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFF0F5F3E),
            child: Icon(Icons.person, color: Colors.white, size: 70),
          ),

          const SizedBox(height: 32),

          // Info Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(label: "Nama:", value: userName),
                const SizedBox(height: 12),
                InfoRow(label: "Email:", value: email),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Logout Button
          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            icon: Icon(Icons.logout),
            label: Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0F5F3E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
