class SiswaModel {
  final String nis;
  final String nisn;
  final String nik;

  SiswaModel({
    required this.nis,
    required this.nisn,
    required this.nik,
  });

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      nis: json['nis'],
      nisn: json['nisn'],
      nik: json['nik'],
    );
  }
}
