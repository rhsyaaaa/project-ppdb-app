import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ppdb_app/core/models/pendaftaran_model.dart';

class PendaftaranPage extends StatefulWidget {
  PendaftaranPage({super.key});

  @override
  State<PendaftaranPage> createState() => _PendaftaranPageState();
}

class _PendaftaranPageState extends State<PendaftaranPage> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor =  Color(0xFF0F5F3E);

  // Controllers untuk data siswa
  final namaController = TextEditingController();
  final nisController = TextEditingController();
  final nisnController = TextEditingController();
  final nikController = TextEditingController();
  final tempatLahirController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final asalSekolahController = TextEditingController();
  final alamatSiswaController = TextEditingController();
  final noTelpSiswaController = TextEditingController();

  // Controllers untuk data orang tua
  final namaAyahController = TextEditingController();
  final namaIbuController = TextEditingController();
  final pekerjaanAyahController = TextEditingController();
  final pekerjaanIbuController = TextEditingController();
  final alamatOrtuController = TextEditingController();
  final noTelpOrtuController = TextEditingController();

  // Tahun ajaran
  final tahunAjaranController = TextEditingController();

  // Pilihan dan status
  String? jenisKelamin;
  bool sudahVerifikasi = false;
  bool sudahWawancara = false;
  bool uploadBerkas = false;

  bool isLoading = false;

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

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
      tahunAjaran: tahunAjaranController.text.trim(),
      sudahVerifikasi: sudahVerifikasi,
      sudahWawancara: sudahWawancara,
      uploadBerkas: uploadBerkas,
    );

    final url = Uri.parse('http://172.30.176.1:2025/pendaftar/daftar-siswa');

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pendaftar.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pendaftaran berhasil")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildTextField(String hint, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) =>
            value == null || value.isEmpty ? 'Wajib diisi' : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildCheckbox(String label, bool value, Function(bool?) onChanged) {
  return CheckboxListTile(
    value: value,
    onChanged: onChanged,
    title: Text(
      label,
      style: TextStyle(
        color: Colors.black, // Warna teks hitam
        fontSize: 16,
      ),
    ),
    activeColor: primaryColor,   
    checkColor: Colors.white,    
    controlAffinity: ListTileControlAffinity.leading,
    contentPadding: EdgeInsets.zero,
    tileColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/images/smkmq.png', height: 100),
                SizedBox(height: 10),
                Text(
                  'Pendaftaran',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  'Silahkan masukkan data diri Siswa & Orang tua',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 16),

                // Data siswa
                buildTextField("Nama siswa", namaController),
                buildTextField("NIS", nisController),
                buildTextField("NISN", nisnController),
                buildTextField("NIK", nikController),
                buildTextField("Tempat lahir", tempatLahirController),
                buildTextField("Tanggal lahir", tanggalLahirController),
                buildTextField("Asal sekolah", asalSekolahController),
                buildTextField("Alamat siswa", alamatSiswaController),
                buildTextField("No Telp siswa", noTelpSiswaController, isNumber: true),
                DropdownButtonFormField<String>(
                  value: jenisKelamin,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  hint:  Text("Pilih jenis kelamin"),
                  items: ['Laki-laki', 'Perempuan']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => jenisKelamin = value),
                  validator: (value) =>
                      value == null ? 'Jenis kelamin harus dipilih' : null,
                ),

                SizedBox(height: 20),

                // Data orang tua
                buildTextField("Nama Ayah", namaAyahController),
                buildTextField("Nama Ibu", namaIbuController),
                buildTextField("Pekerjaan Ayah", pekerjaanAyahController),
                buildTextField("Pekerjaan Ibu", pekerjaanIbuController),
                buildTextField("Alamat orang tua", alamatOrtuController),
                buildTextField("No Telp orang tua", noTelpOrtuController,
                    isNumber: true),

                // Tahun ajaran
                buildTextField("Tahun Ajaran (misal: 2024/2025)", tahunAjaranController),
                SizedBox(height: 12),
                // Checkbox status
                buildCheckbox("Sudah Verifikasi", sudahVerifikasi,
                    (val) => setState(() => sudahVerifikasi = val!)),
                    SizedBox(height: 12,),
                buildCheckbox("Sudah Wawancara", sudahWawancara,
                    (val) => setState(() => sudahWawancara = val!)),
                    SizedBox(height: 12,),
                buildCheckbox("Upload Berkas", uploadBerkas,
                    (val) => setState(() => uploadBerkas = val!)),

                SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submitForm,
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    padding:  EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    ),
                    child: isLoading
                      ?  CircularProgressIndicator()
                      :  Text('Daftar'),
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