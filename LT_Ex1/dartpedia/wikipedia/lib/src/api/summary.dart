import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/summary.dart';

Future<Summary> getRandomArticleSummary() async {
  final http.Client client = http.Client();
  try {
    final Uri url = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    
    // SỬA Ở ĐÂY: Thêm headers cho hàm lấy bài viết ngẫu nhiên
    final http.Response response = await client.get(
      url,
      headers: {
        'User-Agent': 'DartpediaApp/1.0 (helo@gmail.com) Dart/3.0',
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, Object?> jsonData =
          jsonDecode(response.body) as Map<String, Object?>;
      return Summary.fromJson(jsonData);
    } else {
      throw HttpException(
        '[WikipediaDart.getRandomArticle] statusCode=${response.statusCode}, body=${response.body}',
      );
    }
  } on FormatException {
    rethrow;
  } finally {
    client.close(); // Đảm bảo luôn đóng client để giải phóng tài nguyên
  }
}

Future<Summary> getArticleSummaryByTitle(String articleTitle) async {
  final http.Client client = http.Client();
  try {
    final Uri url = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/summary/$articleTitle',
    );
    
    // SỬA Ở ĐÂY: Thêm headers cho hàm lấy bài viết theo tiêu đề
    final http.Response response = await client.get(
      url,
      headers: {
        'User-Agent': 'DartpediaApp/1.0 (your-email@example.com) Dart/3.0',
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, Object?> jsonData =
          jsonDecode(response.body) as Map<String, Object?>;
      return Summary.fromJson(jsonData);
    } else {
      throw HttpException(
        '[WikipediaDart.getArticleSummary] statusCode=${response.statusCode}, body=${response.body}',
      );
    }
  } on FormatException {
    rethrow;
  } finally {
    client.close();
  }
}