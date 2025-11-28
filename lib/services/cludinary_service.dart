// services/imgbb_service.dart
import 'dart:io';
import 'package:dio/dio.dart';

class ImgBBService {
  static final Dio _dio = Dio();

  static Future<String?> uploadImage(File image) async {
    try {
      String fileName = image.path.split('/').last;

      FormData formData = FormData.fromMap({
        'key': "2687634cbf35e4097eb819abb16cb279",
        'image': await MultipartFile.fromFile(image.path, filename: fileName),
      });

      Response response = await _dio.post(
        'https://api.imgbb.com/1/upload',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data']['url'];
      } else {
        print('ImgBB Error: ${response.data}');
      }
    } catch (e) {
      print('Upload failed: $e');
    }
    return null;
  }
}