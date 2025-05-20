class Pendaftar {
  final String nama;
  final String nis;
  final String nisn;
  final String nik;
  final String tempatLahir;
  final String tanggalLahir;
  final String jenisKelamin;
  final String asalSekolah;
  final String noTelpSiswa;
  final String alamatSiswa;
  final String namaAyah;
  final String namaIbu;
  final String pekerjaanAyah;
  final String pekerjaanIbu;
  final String noTelpOrtu;
  final String alamatOrtu;
  final String tahunAjaran;
  final bool sudahVerifikasi;
  final bool sudahWawancara;
  final bool uploadBerkas;

  Pendaftar({
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
    required this.tahunAjaran,
    this.sudahVerifikasi = false,
    this.sudahWawancara = false,
    this.uploadBerkas = false,
  });

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "nis": nis,
        "nisn": nisn,
        "nik": nik,
        "tempatLahir": tempatLahir,
        "tanggalLahir": tanggalLahir,
        "jenisKelamin": jenisKelamin,
        "asalSekolah": asalSekolah,
        "noTelpSiswa": noTelpSiswa,
        "alamatSiswa": alamatSiswa,
        "namaAyah": namaAyah,
        "namaIbu": namaIbu,
        "pekerjaanAyah": pekerjaanAyah,
        "pekerjaanIbu": pekerjaanIbu,
        "noTelpOrtu": noTelpOrtu,
        "alamatOrtu": alamatOrtu,
        "tahunAjaran": tahunAjaran,
        "sudahVerifikasi": sudahVerifikasi,
        "sudahWawancara": sudahWawancara,
        "uploadBerkas": uploadBerkas,
      };
}
