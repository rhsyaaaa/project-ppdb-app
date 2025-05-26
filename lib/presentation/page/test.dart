import 'package:flutter/material.dart';
import 'package:ppdb_app/service/siswa_service.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final Color primaryColor = const Color(0xFF0F5F3E);

  final PageController _pageController = PageController();
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();

  final SiswaService _siswaService = SiswaService();

  bool _isLoading = false;

  Future<void> _validateAndProceed() async {
    final nis = _nisController.text.trim();
    final nisn = _nisnController.text.trim();
    final nik = _nikController.text.trim();

    if (nis.isEmpty || nisn.isEmpty || nik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIS, NISN, dan NIK tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _siswaService.cekSiswa(nis: nis, nisn: nisn, nik: nik);
      print('Siswa ditemukan: ${result['siswa']}');

      setState(() => _isLoading = false);

      _pageController.jumpToPage(1);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memverifikasi data siswa: $e')),
      );
    }
  }

  Widget _buildLoginPage() {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/smkmq.png', height: 80),
              const SizedBox(height: 16),
              const Text(
                'Masukan untuk Mengerjakan Test !',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nisController,
                decoration: const InputDecoration(
                  hintText: 'Masukan NIS siswa',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nisnController,
                decoration: const InputDecoration(
                  hintText: 'Masukan NISN siswa',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nikController,
                decoration: const InputDecoration(
                  hintText: 'Masukan NIK siswa',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton(
                      onPressed: _validateAndProceed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                      ),
                      child: const Text('Mulai Test'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestListPage() {
    final List<Map<String, dynamic>> tests = [
      {'title': 'Bahasa Inggris', 'color': Colors.blue},
      {'title': 'Diniyyah', 'color': Colors.green},
      {'title': 'Matematika', 'color': Colors.red},
      {'title': 'IPA', 'color': Colors.teal},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: 80),
              const SizedBox(height: 8),
              const Text('Test',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
            ],
          ),
        ),
        ...tests.map((test) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Image.asset('assets/skill.png', width: 60),
              title: Text(test['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('3 Soal'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: test['color'],
                ),
                onPressed: () {
                  // TODO: Action saat tekan tombol kerjakan
                },
                child: const Text('Kerjakan'),
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildLoginPage(),
          _buildTestListPage(),
        ],
      ),
    );
  }
}
