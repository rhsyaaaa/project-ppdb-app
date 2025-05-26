// ignore_for_file: unused_import

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:ppdb_app/core/models/pendaftaran_model.dart';
import 'package:ppdb_app/service/upload_service.dart';
import 'package:go_router/go_router.dart';

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

  // Controllers siswa
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

  // Controllers orang tua
  final namaAyahController = TextEditingController();
  final namaIbuController = TextEditingController();
  final pekerjaanAyahController = TextEditingController();
  final pekerjaanIbuController = TextEditingController();
  final alamatOrtuController = TextEditingController();
  final noTelpOrtuController = TextEditingController();

  final tahunAjaranController = TextEditingController();
  bool sudahVerifikasi = false;
  bool sudahWawancara = false;
  bool uploadBerkas = false;
  Uint8List? fileBytes;
  String? fileUrl;

  Future<void> pickFile() async {
    final pickedFile = await ImagePickerWeb.getImageAsBytes();
    if (pickedFile != null) {
      setState(() => fileBytes = pickedFile);
      final url = await UploadService().uploadImage(fileBytes!);
      if (url != null) {
        setState(() {
          uploadBerkas = true;
          fileUrl = url;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload gagal')));
      }
    }
  }

  void nextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() => currentPage++);
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
      nama: namaController.text,
      nis: nisController.text,
      nisn: nisnController.text,
      nik: nikController.text,
      tempatLahir: tempatLahirController.text,
      tanggalLahir: tanggalLahirController.text,
      jenisKelamin: jenisKelamin ?? '',
      asalSekolah: asalSekolahController.text,
      noTelpSiswa: noTelpSiswaController.text,
      alamatSiswa: alamatSiswaController.text,
      namaAyah: namaAyahController.text,
      namaIbu: namaIbuController.text,
      pekerjaanAyah: pekerjaanAyahController.text,
      pekerjaanIbu: pekerjaanIbuController.text,
      noTelpOrtu: noTelpOrtuController.text,
      alamatOrtu: alamatOrtuController.text,
      tahunAjaran: tahunAjaranController.text,
      sudahVerifikasi: sudahVerifikasi,
      sudahWawancara: sudahWawancara,
      uploadBerkas: fileUrl != null,
    );

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://172.30.176.1:2025/pendaftar/daftar-siswa'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pendaftar.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Berhasil mendaftarkan siswa!')));
        return true;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal: ${response.body}')));
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return false;
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator:
            (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildPageContent({required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: currentPage == 0 ? null : previousPage,
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        Center(child: Image.asset('assets/images/smkmq.png', height: 100)),
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
        Expanded(child: SingleChildScrollView(child: child)),
      ],
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
              Padding(
                padding: const EdgeInsets.all(24),
                child: buildPageContent(
                  child: Column(
                    children: [
                      buildTextField("Masukkan nama siswa", namaController),
                      buildTextField("Masukkan NIS siswa", nisController),
                      buildTextField("Masukkan NISN siswa", nisnController),
                      buildTextField("Masukkan NIK siswa", nikController),
                      buildTextField("Tempat lahir", tempatLahirController),
                      buildTextField("Tanggal lahir", tanggalLahirController),
                      buildTextField("Asal sekolah", asalSekolahController),
                      DropdownButtonFormField<String>(
                        value: jenisKelamin,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: Text("Jenis kelamin"),
                        items:
                            ['Laki-laki', 'Perempuan']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => jenisKelamin = val),
                        validator:
                            (val) => val == null ? 'Harus dipilih' : null,
                      ),
                      buildTextField("Alamat rumah", alamatSiswaController),
                      buildTextField(
                        "No tlpn",
                        noTelpSiswaController,
                        isNumber: true,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: nextPage,
                        child: Text('Lanjutkan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: buildPageContent(
                  child: Column(
                    children: [
                      buildTextField("Masukan nama Ayah", namaAyahController),
                      buildTextField("Masukan nama Ibu", namaIbuController),
                      buildTextField(
                        "Masukan pekerjaan Ayah",
                        pekerjaanAyahController,
                      ),
                      buildTextField(
                        "Masukan pekerjaan Ibu",
                        pekerjaanIbuController,
                      ),
                      buildTextField("Alamat Orang Tua", alamatOrtuController),
                      buildTextField(
                        "No telpon Orang Tua",
                        noTelpOrtuController,
                        isNumber: true,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: nextPage,
                        child: Text('Upload berkas'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: buildPageContent(
                  child: Column(
                    children: [
                      buildTextField(
                        "Tahun ajaran (Misal : 2024/2025)",
                        tahunAjaranController,
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: pickFile,
                          child: Text(
                            fileUrl != null
                                ? 'Berkas terunggah'
                                : 'Upload Berkas',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CheckboxListTile(
                          value: sudahVerifikasi,
                          onChanged:
                              (val) => setState(
                                () => sudahVerifikasi = val ?? false,
                              ),
                          title: Text(
                            'Sudah Verifikasi',
                            style: TextStyle(color: Colors.black),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CheckboxListTile(
                          value: sudahWawancara,
                          onChanged:
                              (val) =>
                                  setState(() => sudahWawancara = val ?? false),
                          title: Text(
                            'Sudah Wawancara',
                            style: TextStyle(color: Colors.black),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  final success = await submitForm();
                                  if (mounted && success) {
                                    GoRouter.of(context).go('/home');
                                  }
                                },

                        child:
                            isLoading
                                ? CircularProgressIndicator()
                                : Text('Daftar'),
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
      ),
    );
  }
}
