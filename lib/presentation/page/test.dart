// ignore_for_file: empty_statements

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_app/core/routing/app_route.dart';
import 'package:ppdb_app/service/siswa_service.dart';

class TestPage extends StatefulWidget {
  final String? idSiswa;

  const TestPage({super.key, required this.idSiswa});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool _authorized = false;
  bool _loading = true;

  final List<Map<String, dynamic>> testList = [
    {'title': 'Bahasa Inggris', 'questions': 3, 'buttonColor': Colors.blue},
    {'title': 'Diniyyah', 'questions': 3, 'buttonColor': Colors.green},
    {'title': 'Matematika', 'questions': 3, 'buttonColor': Colors.red},
    {'title': 'IPA', 'questions': 3, 'buttonColor': Colors.teal},
  ];

  @override
  void initState() {
    super.initState();

    if (widget.idSiswa == null || widget.idSiswa!.isEmpty) {
      // Kalau idSiswa null atau kosong, langsung tampil dialog akses ditolak
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAccessDeniedDialog("ID siswa tidak boleh kosong.");
      });
      setState(() {
        _loading = false;
        _authorized = false;
      });
    } else {
      _checkAccess();
    }
  }

  Future<void> _checkAccess() async {
    final idSiswa = widget.idSiswa!;
    print("ID dari route: $idSiswa");

    final siswaService = SiswaService();
    final terdaftar = await siswaService.cekSiswaTerdaftar(idSiswa);
    print("Hasil pengecekan: $terdaftar");

    if (!mounted) return;

    if (terdaftar) {
      setState(() {
        _authorized = true;
        _loading = false;
      });
    } else {
      _showAccessDeniedDialog("ID siswa tidak terdaftar di sistem.");
      setState(() {
        _loading = false;
        _authorized = false;
      });
    }
  }

  void _showAccessDeniedDialog(String pesan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Akses Ditolak"),
        content: Text(pesan),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.goNamed(Routes.home);
            },
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_authorized) {
      return Scaffold(
        body: Center(
          child: Text(
            "Akses Ditolak",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    // Jika authorized, tampilkan daftar test
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.goNamed(Routes.home);
                },
              ),
            ),
            Center(
              child: Column(
                children: [
                  Image.asset('assets/images/smkmq2.png', height: 80),
                  const SizedBox(height: 62),
                  const Text(
                    'Test',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F5F3E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ...testList.map((test) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                    color: Colors.white,
                    child: Column(
                    children: [
                      Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        left: 12,
                        right: 12,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                        'assets/images/skillbanner.png',
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        ),
                      ),
                      ),
                      Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                        Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            test['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            const SizedBox(height: 4),
                            Text('${test['questions']} Soal'),
                          ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          backgroundColor: test['buttonColor'],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          ),
                          onPressed: () {
                          // Contoh navigasi ke halaman soal
                          // context.goNamed(
                          //   Routes.soal,
                          //   pathParameters: {
                          //     'id': widget.idSiswa!,
                          //     'judul': test['title'],
                          //   },
                          // );
                          },
                          child: const Text(
                          'Kerjakan',
                          style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ],
                      ),
                      ),
                    ],
                    ),
                  ),                
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
