class Pendaftar {
  String? idSiswa; // nullable, karena dibuat backend
  String nama;
  String nis;
  String nisn;
  String nik;
  String tempatLahir;
  String tanggalLahir; // simpan sebagai String (ISO 8601)
  String jenisKelamin; // 'Laki-laki' | 'Perempuan'
  String asalSekolah;
  String noTelpSiswa;
  String alamatSiswa;
  String namaAyah;
  String namaIbu;
  String pekerjaanAyah;
  String pekerjaanIbu;
  String noTelpOrtu;
  String alamatOrtu;
  bool sudahVerifikasi;
  bool sudahWawancara;
  bool uploadBerkas;
  String tahunAjaran;
  String statusTest;
  String? statusKelulusan;
  double? nilai;

  Pendaftar({
    this.idSiswa,
    required this.nama,
    required this.nis,
    required this.nisn,
    required this.nik,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.asalSekolah,
    required this.noTelpSiswa,
    required this.alamatSiswa,
    required this.namaAyah,
    required this.namaIbu,
    required this.pekerjaanAyah,
    required this.pekerjaanIbu,
    required this.noTelpOrtu,
    required this.alamatOrtu,
    required this.sudahVerifikasi,
    required this.sudahWawancara,
    required this.uploadBerkas,
    required this.tahunAjaran,
    required this.statusTest,
    this.statusKelulusan,
    this.nilai, String? fileUrl,
  });

  // JSON dari model ke map (kirim ke backend)
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nis': nis,
      'nisn': nisn,
      'nik': nik,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir,
      'jenisKelamin': jenisKelamin,
      'asalSekolah': asalSekolah,
      'noTelpSiswa': noTelpSiswa,
      'alamatSiswa': alamatSiswa,
      'namaAyah': namaAyah,
      'namaIbu': namaIbu,
      'pekerjaanAyah': pekerjaanAyah,
      'pekerjaanIbu': pekerjaanIbu,
      'noTelpOrtu': noTelpOrtu,
      'alamatOrtu': alamatOrtu,
      'sudahVerifikasi': sudahVerifikasi,
      'sudahWawancara': sudahWawancara,
      'uploadBerkas': uploadBerkas,
      'tahunAjaran': tahunAjaran,
      'statusTest': statusTest,
      if (statusKelulusan != null) 'statusKelulusan': statusKelulusan,
      if (nilai != null) 'nilai': nilai,
      // Jangan kirim id, backend yang buat
    };
  }

  // Dari JSON response backend ke model
  factory Pendaftar.fromJson(Map<String, dynamic> json) {
    return Pendaftar(
      idSiswa: json['id'],
      nama: json['nama'],
      nis: json['nis'],
      nisn: json['nisn'],
      nik: json['nik'],
      tempatLahir: json['tempatLahir'],
      tanggalLahir: json['tanggalLahir'],
      jenisKelamin: json['jenisKelamin'],
      asalSekolah: json['asalSekolah'],
      noTelpSiswa: json['noTelpSiswa'],
      alamatSiswa: json['alamatSiswa'],
      namaAyah: json['namaAyah'],
      namaIbu: json['namaIbu'],
      pekerjaanAyah: json['pekerjaanAyah'],
      pekerjaanIbu: json['pekerjaanIbu'],
      noTelpOrtu: json['noTelpOrtu'],
      alamatOrtu: json['alamatOrtu'],
      sudahVerifikasi: json['sudahVerifikasi'] ?? false,
      sudahWawancara: json['sudahWawancara'] ?? false,
      uploadBerkas: json['uploadBerkas'] ?? false,
      tahunAjaran: json['tahunAjaran'],
      statusTest: json['statusTest'],
      statusKelulusan: json['statusKelulusan'],
      nilai: (json['nilai'] != null) ? (json['nilai'] as num).toDouble() : null,
    );
  }
}
