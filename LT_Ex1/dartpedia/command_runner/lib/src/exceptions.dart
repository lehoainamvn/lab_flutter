class ArgumentException extends FormatException {
  /// Lệnh đã được phân tích trước khi phát hiện ra lỗi.
  final String? command;

  /// Tên của tham số gây ra lỗi khi đang phân tích.
  final String? argumentName;

  ArgumentException(
    super.message, [
    this.command,
    this.argumentName,
    super.source,
    super.offset,
  ]);

  @override
  String toString() {
    return 'ArgumentException: $message';
  }
}