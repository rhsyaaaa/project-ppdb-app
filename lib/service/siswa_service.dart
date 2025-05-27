import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ppdb_app/core/models/pendaftaran_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SiswaService {
  final String baseUrl = 'http://172.30.176.1:2025';

  /// Daftar siswa ke backend,
  /// lalu simpan ID siswa yang diterima dari backend ke SharedPreferences
   Future<Pendaftar?> daftarSiswa(Pendaftar pendaftar) async {
  final url = Uri.parse('$baseUrl/pendaftar/daftar-siswa');
  final body = jsonEncode(pendaftar.toJson());

  print('[DEBUG] Request URL: $url');
  print('[DEBUG] Request Body: $body');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  print('[DEBUG] Response Code: ${response.statusCode}');
  print('[DEBUG] Response Body: ${response.body}');

  if (response.statusCode == 201 || response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Pendaftar.fromJson(data);
  } else {
    return null;
  }
}


  /// Cek apakah siswa sudah terdaftar berdasarkan ID
  Future<bool> cekSiswaTerdaftar(String idSiswa) async {
  final url = Uri.parse('$baseUrl/pendaftar/cek-siswa');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': idSiswa}),  // Kirim ID di body, bukan di URL path
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['success'] == true && data['siswa'] != null && data['siswa']['id'] != null;
    } else {
      print('Siswa tidak ditemukan: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error saat cek siswa: $e');
    return false;
  }
}

  /// Ambil ID siswa yang tersimpan di SharedPreferences
  Future<String?> getCurrentIdSiswa() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idSiswa');
  }

  /// Hapus ID siswa dari SharedPreferences (misal untuk logout/reset)
  Future<void> clearIdSiswa() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('idSiswa');
  }
}
