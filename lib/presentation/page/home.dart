// ignore_for_file: unused_local_variable, unused_field, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_app/service/siswa_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  final Color primaryColor = Color(0xFF0F5F3E);

  @override
  void initState() {
    super.initState();
    cekStatusSiswa();
  }

  // Fungsi cek status siswa dan redirect ke halaman /test jika sudah terdaftar
  void cekStatusSiswa() async {
  final siswaService = SiswaService();
  final idSiswa = await siswaService.getCurrentIdSiswa();

  if (idSiswa != null) {
    final terdaftar = await siswaService.cekSiswaTerdaftar(idSiswa);
    if (terdaftar) {
      if (mounted) {
        // Kirim idSiswa juga lewat query parameter
        context.go('/test?id=$idSiswa');
      }
    } else {
      print('ID siswa ditemukan tapi tidak valid/terdaftar di backend');
    }
  } else {
    print('Belum ada ID siswa tersimpan di SharedPreferences');
  }
}


  String getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@')[0] ?? 'user';
  }

  @override
  Widget build(BuildContext context) {
    final String userName = getUserName();

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          // Header dengan gambar masjid
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/masjid.png'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "PPDB",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  "SMK MADINATULQURAN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Body putih dengan tombol
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: Container(
                width: double.infinity,
                color: Color(0xFF0F5F3E),
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hai $userName !',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Selamat datang di PPDB SMK MQ 👋',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    SizedBox(height: 30),
                    CustomButton(
                      icon: Icons.edit,
                      text: 'Pendaftaran',
                      onTap: () {
                        context.go('/pendaftaran');
                      },
                    ),
                    SizedBox(height: 16),
                    CustomButton(
                      icon: Icons.article,
                      text: 'Test',
                      onTap: () async {
                        final siswaService = SiswaService();
                        final idSiswa = await siswaService.getCurrentIdSiswa();

                        if (idSiswa != null) {
                          final terdaftar = await siswaService
                              .cekSiswaTerdaftar(idSiswa);

                          if (terdaftar) {
                            // Kirim idSiswa lewat query parameter saat navigasi ke test page
                            context.go('/test?id=$idSiswa');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Siswa belum terdaftar. Silakan daftar terlebih dahulu.',
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'ID siswa tidak ditemukan. Silakan daftar terlebih dahulu.',
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    SizedBox(height: 16),
                    CustomButton(
                      icon: Icons.fact_check,
                      text: 'Hasil Test',
                      // onTap: () {
                      //   context.go('/hasil-test');
                      // },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Custom Style
      bottomNavigationBar: Container(
        height: 44,
        margin: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.image_outlined, color: Colors.black54, size: 26),
              onPressed: () {
                setState(() => _selectedIndex = 0);
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
            IconButton(
              icon: Icon(Icons.home, color: primaryColor, size: 26),
              onPressed: () {
                setState(() => _selectedIndex = 1);
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
            IconButton(
              icon: Icon(Icons.person_outline, color: Colors.black54, size: 26),
              onPressed: () {
                setState(() => _selectedIndex = 2);
                context.go('/profile');
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const CustomButton({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        padding: EdgeInsets.symmetric(vertical: 28, horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.black87),
          SizedBox(width: 28),
          Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
