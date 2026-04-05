import 'package:cli/cli.dart';
import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) async {
  // 1. Khởi tạo Logger tập trung với tên định danh là 'errors'
  final errorLogger = initFileLogger('errors');
  
  // 2. Cấu hình CommandRunner
  final app = CommandRunner(
    onOutput: (String output) async {
      await write(output);
    },
    onError: (Object error) {
      // Nếu là lỗi hệ thống nghiêm trọng (Error)
      if (error is Error) {
        errorLogger.severe(
          '[Error] ${error.toString()}\n${error.stackTrace}',
        );
        throw error;
      }
      // Nếu là các ngoại lệ thông thường (Exception) như mất mạng, gõ sai lệnh...
      if (error is Exception) {
        errorLogger.warning(error);
      }
    },
  )
    ..addCommand(HelpCommand())
    // 3. Luồn lách (Inject) Logger vào trong các Command
    ..addCommand(SearchCommand(logger: errorLogger))
    ..addCommand(GetArticleCommand(logger: errorLogger));

  // 4. Thực thi ứng dụng với các đối số người dùng truyền vào
  app.run(arguments);
}