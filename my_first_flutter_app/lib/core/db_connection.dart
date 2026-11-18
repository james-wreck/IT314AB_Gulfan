
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class DbConnection {
  static Connection? _conn;

  static Future<Connection> get() async {
    if (_conn != null && _conn!.isOpen) {
      return _conn!;
    }

    _conn = await Connection.open(
      Endpoint(
        host: dotenv.env['DB_HOST']!,
        port: int.parse(dotenv.env['DB_PORT']!),
        database: dotenv.env['DB_NAME']!,
        username: dotenv.env['DB_USER']!,
        password: dotenv.env['DB_PASSWORD']!,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
      ),
    );

    return _conn!;
  }
}
