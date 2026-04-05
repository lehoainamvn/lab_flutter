import 'dart:io';

const String ansiEscapeLiteral = '\x1B';

/// Tách chuỗi theo ký tự xuống dòng `\n`, sau đó in từng dòng ra console.
/// [duration] định nghĩa số mili-giây delay giữa mỗi dòng được in (tạo hiệu ứng gõ chữ).
Future<void> write(String text, {int duration = 50}) async {
  final List<String> lines = text.split('\n');
  for (final String l in lines) {
    await _delayedPrint('$l \n', duration: duration);
  }
}

/// In từng dòng có độ trễ
Future<void> _delayedPrint(String text, {int duration = 0}) async {
  return Future<void>.delayed(
    Duration(milliseconds: duration),
    () => stdout.write(text),
  );
}

/// Enum nâng cao chứa mã màu RGB để style cho terminal
enum ConsoleColor {
  /// Sky blue - #b8eafe
  lightBlue(184, 234, 254),

  /// Warm red - #F25D50
  red(242, 93, 80),

  /// Light yellow - #F9F8C4
  yellow(249, 248, 196),

  /// Light grey, good for text, #F8F9FA
  grey(240, 240, 240),

  /// White
  white(255, 255, 255);

  const ConsoleColor(this.r, this.g, this.b);

  final int r;
  final int g;
  final int b;

  /// Đổi màu chữ cho toàn bộ output tiếp theo
  String get enableForeground => '$ansiEscapeLiteral[38;2;$r;$g;${b}m';

  /// Đổi màu nền cho toàn bộ output tiếp theo
  String get enableBackground => '$ansiEscapeLiteral[48;2;$r;$g;${b}m';

  /// Reset màu chữ và nền về mặc định của terminal
  static String get reset => '$ansiEscapeLiteral[0m';

  /// Gắn mã màu chữ vào trước chuỗi và tự động reset ở cuối
  String applyForeground(String text) {
    return '$ansiEscapeLiteral[38;2;$r;$g;${b}m$text$reset';
  }

  /// Gắn mã màu nền vào trước chuỗi và tự động reset ở cuối
  String applyBackground(String text) {
    return '$ansiEscapeLiteral[48;2;$r;$g;${b}m$text$ansiEscapeLiteral[0m';
  }
}

/// Task 2: Extension mở rộng tính năng cho kiểu dữ liệu String mặc định
extension TextRenderUtils on String {
  String get errorText => ConsoleColor.red.applyForeground(this);
  String get instructionText => ConsoleColor.yellow.applyForeground(this);
  String get titleText => ConsoleColor.lightBlue.applyForeground(this);

  /// Cắt một chuỗi dài thành các dòng nhỏ không vượt quá số lượng ký tự [length]
  List<String> splitLinesByLength(int length) {
    final List<String> words = split(' ');
    final List<String> output = <String>[];
    final StringBuffer strBuffer = StringBuffer();
    for (int i = 0; i < words.length; i++) {
      final String word = words[i];
      if (strBuffer.length + word.length <= length) {
        strBuffer.write(word.trim());
        if (strBuffer.length + 1 <= length) {
          strBuffer.write(' ');
        }
      }
      if (i + 1 < words.length &&
          words[i + 1].length + strBuffer.length + 1 > length) {
        output.add(strBuffer.toString().trim());
        strBuffer.clear();
      }
    }
    output.add(strBuffer.toString().trim());
    return output;
  }
}