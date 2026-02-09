import 'package:spring_autumn/Model/transaction_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

late Database _db;
Future<void> initializeDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'transaction.db');

  _db = await openDatabase(
    path,
    version: 2,
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE categories (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL UNIQUE
        );
      ''');

      await db.execute('''
        CREATE TABLE transactions (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          category_id TEXT NOT NULL,
          notes TEXT,
          amount INTEGER NOT NULL CHECK (amount >= 0),
          type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
          method TEXT NOT NULL CHECK (method IN ('upi', 'cash', 'card')),
          transaction_timestamp INTEGER NOT NULL,
          created_at INTEGER NOT NULL,
          FOREIGN KEY (category_id) REFERENCES categories(id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE
        );
      ''');
      await db.insert('categories', {'id': 'uuid-food', 'name': 'Food'});

      await db.insert('categories', {'id': 'uuid-travel', 'name': 'Travel'});

      await db.insert('categories', {
        'id': 'uuid-shopping',
        'name': 'Shopping',
      });

      await db.insert('categories', {'id': 'uuid-salary', 'name': 'Salary'});
      await db.execute(
        'CREATE INDEX idx_transactions_date ON transactions(transaction_timestamp);',
      );

      await db.execute(
        'CREATE INDEX idx_transactions_category ON transactions(category_id);',
      );
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
      CREATE TABLE transactions_new (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        category_id TEXT NOT NULL,
        notes TEXT,
        amount REAL NOT NULL CHECK (amount >= 0),
        type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
        method TEXT NOT NULL CHECK (method IN ('upi', 'cash', 'card')),
        transaction_timestamp INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories(id)
          ON DELETE RESTRICT
          ON UPDATE CASCADE
      );
    ''');

        await db.execute('''
      INSERT INTO transactions_new (
        id, title, category_id, notes, amount,
        type, method, transaction_timestamp, created_at
      )
      SELECT 
        id, title, category_id, notes, amount,
        type, method, transaction_timestamp, created_at
      FROM transactions;
    ''');

        await db.execute('DROP TABLE transactions;');

        await db.execute(
          'ALTER TABLE transactions_new RENAME TO transactions;',
        );

        await db.execute(
          'CREATE INDEX idx_transactions_date ON transactions(transaction_timestamp);',
        );

        await db.execute(
          'CREATE INDEX idx_transactions_category ON transactions(category_id);',
        );
      }
    },
  );
}

Future<List<Map<String, Object?>>> getAllTransactions() async {
  return await _db.rawQuery(
    'SELECT * FROM transactions ORDER BY transaction_timestamp DESC',
  );
}

Future<void> insertATransaction(TransactionModel value) async {
  await _db.insert('transactions', {
    'id': value.id,
    'title': value.title,
    'category_id': value.categoryId,
    'notes': value.notes,
    'amount': value.amount,
    'type': value.type.name, // enum → String
    'method': value.method.name, // enum → String
    'transaction_timestamp': value.transactionTimestamp,
    'created_at': value.createdAt,
  }, conflictAlgorithm: ConflictAlgorithm.abort);
  getAllTransactions();
}

Future<List<Map<String, Object?>>> getAllCategories() async {
  return await _db.rawQuery('SELECT id, name FROM categories ORDER BY name');
}

Future<void> insertCategory(String name) async {
  final trimmedName = name.trim();
  final normalizedName =
      trimmedName[0].toUpperCase() + trimmedName.substring(1).toLowerCase();

  if (trimmedName.isEmpty) {
    throw Exception('Category name cannot be empty');
  }

  await _db.insert('categories', {
    'id':
        'uuid-${normalizedName.toLowerCase()}-${DateTime.now().millisecondsSinceEpoch}',
    'name': normalizedName,
  }, conflictAlgorithm: ConflictAlgorithm.ignore);
}

Future<Map<String, Object?>?> getCategoryByName(String name) async {
  final result = await _db.query(
    'categories',
    where: 'name = ?',
    whereArgs: [name.trim()],
    limit: 1,
  );

  return result.isNotEmpty ? result.first : null;
}

Future<void> deleteTransaction(String transactionId) async {
  await _db.delete('transactions', where: 'id = ?', whereArgs: [transactionId]);
}

Future<void> updateTransaction(TransactionModel value) async {
  await _db.update(
    'transactions',
    {
      'title': value.title,
      'category_id': value.categoryId,
      'notes': value.notes,
      'amount': value.amount,
      'type': value.type.name,
      'method': value.method.name,
      'transaction_timestamp': value.transactionTimestamp,
    },
    where: 'id = ?',
    whereArgs: [value.id],
  );
}

Future<bool> transactionExists({
  required String title,
  required double amount,
  required String categoryId,
  required int timestamp,
  required String type,
  required String method,
}) async {
  final result = await _db.query(
    'transactions',
    where: '''
      title = ? AND
      amount = ? AND
      category_id = ? AND
      transaction_timestamp = ? AND
      type = ? AND
      method = ?
    ''',
    whereArgs: [title, amount, categoryId, timestamp, type, method],
    limit: 1,
  );

  return result.isNotEmpty;
}

Future<List<Map<String, Object?>>> getTransactionsForExport() async {
  return await _db.rawQuery('''
    SELECT 
      t.title,
      IFNULL(c.name, 'Unknown') AS category, 
      t.notes,
      t.amount,
      t.type,
      t.method,
      t.transaction_timestamp
    FROM transactions t
    LEFT JOIN categories c ON t.category_id = c.id
    ORDER BY t.transaction_timestamp ASC
  ''');
}
