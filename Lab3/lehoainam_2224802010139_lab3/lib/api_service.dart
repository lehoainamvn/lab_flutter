import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();
  // Thay baseUrl bằng URL dự án của bạn từ mockapi.io
  final String baseUrl = "https://69dde38c410caa3d47ba2290.mockapi.io"; 

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      final response = await dio.post("$baseUrl/user", data: data);
      print("Tạo tài khoản thành công: ${response.data}"); 
      return true;
    } catch (e) {
      if (e is DioException) {
        print("Chi tiết lỗi MockAPI: ${e.response?.data}"); 
      }
      print("Dio error: $e"); 
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.get("$baseUrl/user");
      List users = response.data;

      // Tìm user có email và password khớp với dữ liệu nhập vào
      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'].toString() == password,
        orElse: () => null,
      );

      return user != null; // Trả về true nếu tìm thấy, false nếu không thấy
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return false;
    }
  }
}