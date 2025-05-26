import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class UploadService {
  Future<String?> uploadImage(Uint8List imageBytes) async {
    Uri url = Uri.parse("https://api.cloudinary.com/v1_1/dpts4wnpv/image/upload");

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'simple_app_preset'
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'file.jpg',
        ),
      );

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);
      return jsonResponse['secure_url'];
    } else {
      return null;
    }
  }
}

