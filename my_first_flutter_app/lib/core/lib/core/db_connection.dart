import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class DbConnection {
  DbConnection._();
  static final DbConnection instance = DbConnection._();

  Connection? _conn;

  Connection get connection {
    final c = _conn;
    if (c == null || !c.isOpen) {
      throw StateError('Database not connected. Call connect() first.');
    }
    return c;
  }

  Future<void> connect() async {
    if (_conn != null && _conn!.isOpen) return;

    _conn = await Connection.open(
      Endpoint(
        host: dotenv.env['DB_HOST']!,
        port: int.parse(dotenv.env['DB_PORT'] ?? '5432'),
        database: dotenv.env['DB_NAME']!,
        username: dotenv.env['DB_USER']!,
        password: dotenv.env['DB_PASSWORD']!,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );

    final result = await _conn!.execute('SELECT 1');
    if (result.isEmpty) {
      throw Exception('Connection test query returned no rows.');
    }
  }

  Future<void> close() async {
    await _conn?.close();
    _conn = null;
  }
}