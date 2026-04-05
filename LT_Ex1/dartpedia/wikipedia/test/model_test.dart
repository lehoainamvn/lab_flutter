import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:wikipedia/src/model/article.dart';
import 'package:wikipedia/src/model/search_results.dart';
import 'package:wikipedia/src/model/summary.dart';

// Khai báo đường dẫn trỏ tới các file dữ liệu mẫu
const String dartLangSummaryJson = './test/test_data/dart_lang_summary.json';
const String catExtractJson = './test/test_data/cat_extract.json';
const String openSearchResponse = './test/test_data/open_search_response.json';

void main() {
  group('deserialize example JSON responses from wikipedia API', () {
    
    // 1. Test cho Model Summary
    test('deserialize Dart Programming Language page summary example data from '
        'json file into a Summary object', () async {
      final String pageSummaryInput = await File(dartLangSummaryJson).readAsString();
      final Map<String, Object?> pageSummaryMap = jsonDecode(pageSummaryInput) as Map<String, Object?>;
      
      final Summary summary = Summary.fromJson(pageSummaryMap);
      
      expect(summary.titles.canonical, 'Dart_(programming_language)');
    });

    // 2. Test cho Model Article (Đoạn này đã sửa lỗi subtype cho bạn)
   // 2. Test cho Model Article (Đã sửa lại để không bị lỗi String cast)
    test('deserialize Cat article example data from json file into '
        'an Article object', () async {
      final String articleJson = await File(catExtractJson).readAsString();
      
      final Map<String, Object?> articleMap = jsonDecode(articleJson) as Map<String, Object?>;
      
      // Gọi thẳng hàm static listFromJson mà chúng ta đã viết cực chuẩn ở Chapter 9
      final List<Article> articles = Article.listFromJson(articleMap);

      expect(articles.first.title.toLowerCase(), 'cat');
    });
    // 3. Test cho Model SearchResults
    test('deserialize Open Search results example data from json file '
        'into an SearchResults object', () async {
      final String resultsString = await File(openSearchResponse).readAsString();
      final List<Object?> resultsAsList = jsonDecode(resultsString) as List<Object?>;
      
      final SearchResults results = SearchResults.fromJson(resultsAsList);
      
      expect(results.results.length, greaterThan(1));
    });
    
  });
}