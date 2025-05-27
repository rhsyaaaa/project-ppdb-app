import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:ppdb_app/core/models/pendaftaran_models.dart';
import 'package:ppdb_app/service/siswa_service.dart';
import 'package:ppdb_app/service/upload_service.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendaftaranPage extends StatefulWidget {
  @override
  State<PendaftaranPage> createState() => _PendaftaranPageState();
}

class _PendaftaranPageState extends State<PendaftaranPage> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int currentPage = 0;

  final Color primaryColor = Color(0xFF0F5F3E);
  bool isLoading = false;

  // Controllers data siswa
  final namaController = TextEditingController();
  final nisController = TextEditingController();
  final nisnController = TextEditingController();
  final nikController = TextEditingController();
  final tempatLahirController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final asalSekolahController = TextEditingController();
  final alamatSiswaController = TextEditingController();
  final noTelpSiswaController = TextEditingController();
  String? jenisKelamin;

  // Controllers data orang tua
  final namaAyahController = TextEditingController();
  final namaIbuController = TextEditingController();
  final pekerjaanAyahController = TextEditingController();
  final pekerjaanIbuController = TextEditingController();
  final alamatOrtuController = TextEditingController();
  final noTelpOrtuController = TextEditingController();

  // Data tambahan
  final tahunAjaranController = TextEditingController();
  bool sudahVerifikasi = false;
  bool sudahWawancara = false;
  Uint8List? fileBytes;
  String? fileUrl;

  Future<void> pickFile() async {
    final pickedFile = await ImagePickerWeb.getImageAsBytes();
    if (pickedFile != null) {
      setState(() => fileBytes = pickedFile);
      final url = await UploadService().uploadImage(fileBytes!);
      if (url != null) {
        setState(() => fileUrl = url);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload berkas berhasil')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload gagal')));
      }
    }
  }

  void nextPage() {
    if (_formKey.currentState!.validate()) {
      if (currentPage < 2) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
        setState(() => currentPage++);
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mohon isi data dengan benar')));
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() => currentPage--);
    }
  }

  Future<bool> submitForm() async {
    if (!_formKey.currentState!.validate()) return false;

    if (fileUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan unggah berkas terlebih dahulu')),
      );
      return false;
    }

    final pendaftar = Pendaftar(
      nama: namaController.text.trim(),
      nis: nisController.text.trim(),
      nisn: nisnController.text.trim(),
      nik: nikController.text.trim(),
      tempatLahir: tempatLahirController.text.trim(),
      tanggalLahir: tanggalLahirController.text.trim(),
      jenisKelamin: jenisKelamin ?? '',
      asalSekolah: asalSekolahController.text.trim(),
      noTelpSiswa: noTelpSiswaController.text.trim(),
      alamatSiswa: alamatSiswaController.text.trim(),
      namaAyah: namaAyahController.text.trim(),
      namaIbu: namaIbuController.text.trim(),
      pekerjaanAyah: pekerjaanAyahController.text.trim(),
      pekerjaanIbu: pekerjaanIbuController.text.trim(),
      noTelpOrtu: noTelpOrtuController.text.trim(),
      alamatOrtu: alamatOrtuController.text.trim(),
      sudahVerifikasi: false,
      sudahWawancara: false,
      uploadBerkas: true,
      tahunAjaran: tahunAjaranController.text.trim(),
      statusTest: '', // kosong dulu, nanti diupdate kalau ada status
    );

    setState(() => isLoading = true);
    final service = SiswaService();

    final result = await service.daftarSiswa(pendaftar);
    setState(() => isLoading = false);

    if (!mounted) return false;

    if (result != null && result.idSiswa != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('idSiswa', result.idSiswa!);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pendaftaran berhasil!')));

      // Navigasi langsung ke halaman tes
      GoRouter.of(context).go('/test?id=${result.idSiswa}');

      return true;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mendaftarkan siswa.')));
      return false;
    }
  }

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) return 'Wajib diisi';
              return null;
            },
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              // Halaman 1: Data siswa
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          if (currentPage == 0) {
                            GoRouter.of(context).go('/home');
                          } else {
                            previousPage();
                          }
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    // Logo di atas tengah
                    Center(
                      child: Image.asset(
                        'assets/images/smkmq.png',
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Pendaftaran',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Silahkan masukkan data',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildTextField(
                              "Masukkan nama siswa",
                              namaController,
                            ),
                            buildTextField(
                              "Masukkan NIS siswa",
                              nisController,
                              isNumber: true,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Wajib diisi';
                                if (!RegExp(r'^\d+$').hasMatch(val))
                                  return 'Harus angka';
                                return null;
                              },
                            ),
                            buildTextField(
                              "Masukkan NISN siswa",
                              nisnController,
                              isNumber: true,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Wajib diisi';
                                if (!RegExp(r'^\d+$').hasMatch(val))
                                  return 'Harus angka';
                                return null;
                              },
                            ),
                            buildTextField(
                              "Masukkan NIK siswa",
                              nikController,
                              isNumber: true,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Wajib diisi';
                                if (!RegExp(r'^\d{16}$').hasMatch(val))
                                  return 'NIK harus 16 digit angka';
                                return null;
                              },
                            ),
                            buildTextField(
                              "Tempat lahir siswa",
                              tempatLahirController,
                            ),
                            buildTextField(
                              "Tanggal lahir siswa (YYYY-MM-DD)",
                              tanggalLahirController,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Wajib diisi';
                                if (!RegExp(
                                  r'^\d{4}-\d{2}-\d{2}$',
                                ).hasMatch(val))
                                  return 'Format tanggal tidak valid';
                                return null;
                              },
                            ),
                            DropdownButtonFormField<String>(
                              value: jenisKelamin,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              hint: Text('Pilih jenis kelamin'),
                              items: [
                                DropdownMenuItem(
                                  child: Text('Laki-Laki'),
                                  value: 'Laki-Laki',
                                ),
                                DropdownMenuItem(
                                  child: Text('Perempuan'),
                                  value: 'Perempuan',
                                ),
                              ],
                              validator:
                                  (val) =>
                                      val == null
                                          ? 'Pilih jenis kelamin'
                                          : null,
                              onChanged:
                                  (val) => setState(() => jenisKelamin = val),
                            ),
                            buildTextField(
                              "Asal sekolah",
                              asalSekolahController,
                            ),
                            buildTextField(
                              "Nomor telepon siswa",
                              noTelpSiswaController,
                              isNumber: true,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Wajib diisi';
                                if (!RegExp(r'^\d+$').hasMatch(val))
                                  return 'Harus angka';
                                return null;
                              },
                            ),
                            buildTextField(
                              "Alamat siswa",
                              alamatSiswaController,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: nextPage,
                              child: Text('Lanjutkan'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: primaryColor,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Halaman 2: Data orang tua
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: previousPage,
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    // Logo di atas tengah
                    Center(
                      child: Image.asset(
                        'assets/images/smkmq.png',
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Data Orang Tua',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildTextField("Nama Ayah", namaAyahController),
                            buildTextField("Nama Ibu", namaIbuController),
                            buildTextField(
                              "Pekerjaan Ayah",
                              pekerjaanAyahController,
                            ),
                            buildTextField(
                              "Pekerjaan Ibu",
                              pekerjaanIbuController,
                            ),
                            buildTextField(
                              "Alamat Orang Tua",
                              alamatOrtuController,
                            ),
                            buildTextField(
                              "Nomor Telepon Orang Tua",
                              noTelpOrtuController,
                              isNumber: true,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Wajib diisi';
                                if (!RegExp(r'^\d+$').hasMatch(val))
                                  return 'Harus angka';
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: nextPage,
                              child: Text('Lanjutkan'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: primaryColor,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Halaman 3: Upload & submit
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: previousPage,
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    // Logo di atas tengah
                    Center(
                      child: Image.asset(
                        'assets/images/smkmq.png',
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 10),

                    buildTextField("Tahun Ajaran", tahunAjaranController),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: pickFile,
                      child: Text('Unggah Berkas'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: primaryColor,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    fileUrl != null
                        ? Text(
                          'Berkas berhasil diunggah',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                        : Container(),
                    SizedBox(height: 16),
                    isLoading
                        ? Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : ElevatedButton(
                          onPressed: submitForm,
                          child: Text('Submit Pendaftaran'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: primaryColor,
                            backgroundColor: Colors.white,
                          ),
                        ),

                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: pickFile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: primaryColor,
                              ),
                              child: Text('Unggah Berkas'),
                            ),
                            if (fileBytes != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Image.memory(fileBytes!, height: 250),
                              ),
                            SizedBox(height: 20),
                            isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : ElevatedButton(
                                  onPressed: () async {
                                    final berhasil = await submitForm();
                                    if (berhasil && mounted) {
                                      GoRouter.of(context).go('/home');
                                    }
                                  },
                                  child: Text('Daftar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: primaryColor,
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
