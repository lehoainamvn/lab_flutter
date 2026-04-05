import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/article.dart';

Future<List<Article>> getArticleByTitle(String title) async {
  final http.Client client = http.Client();
  try {
    final Uri url = Uri.https(
      'en.wikipedia.org',
      '/w/api.php',
      <String, Object?>{
        'action': 'query',
        'format': 'json',
        'titles': title.trim(),
        'prop': 'extracts',
        'explaintext': '', // Trả về text thuần, không lấy code HTML
      },
    );

    // SỬA Ở ĐÂY: Thêm headers để Wikipedia nhận diện
    final http.Response response = await client.get(
      url,
      headers: {
        'User-Agent': 'DartpediaApp/1.0 (helo@gmail.com) Dart/3.0',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, Object?> jsonData =
          jsonDecode(response.body) as Map<String, Object?>;
      return Article.listFromJson(jsonData);
    } else {
      throw HttpException(
        '[ApiClient.getArticleByTitle] statusCode=${response.statusCode}, body=${response.body}',
      );
    }
  } on FormatException {
    rethrow;
  } finally {
    client.close();
  }
}