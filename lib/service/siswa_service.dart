import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ppdb_app/core/models/pendaftaran_models.dart';

class SiswaService {
  final String baseUrl = 'http://172.30.176.1:2025';

   Future<bool> daftarSiswa(Pendaftar pendaftar) async {
    final url = Uri.parse('$baseUrl/pendaftar/daftar-siswa');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pendaftar.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Gagal daftar siswa: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error daftar siswa: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> cekSiswa({
    required String nis,
    required String nisn,
    required String nik,
  }) async {
    final url = Uri.parse('$baseUrl/pendaftar/cek-siswa');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nis': nis, 'nisn': nisn, 'nik': nik}),
    );
    
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal memverifikasi data siswa');
    }
  }
}
