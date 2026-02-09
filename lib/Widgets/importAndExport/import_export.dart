import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spring_autumn/Database/database_helper.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import 'package:uuid/uuid.dart';

Future<void> showImportCsvDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Import Transactions'),
      content: const Text(
        'Select a CSV file to import transactions.\n'
        'Duplicate or invalid rows will be skipped.',
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await importCsvTransactions(context);
          },
          child: const Text(
            'Import CSV',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

Future<void> importCsvTransactions(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv', 'txt'],
  );

  if (result == null) return;

  final file = File(result.files.single.path!);
  final csvString = await file.readAsString();

  final rows = const CsvToListConverter(
    shouldParseNumbers: false,
    eol: '\n',
  ).convert(csvString);

  if (rows.length <= 1) return;

  final uuid = const Uuid();
  int imported = 0;
  int skipped = 0;

  for (int i = 1; i < rows.length; i++) {
    try {
      final row = rows[i];
      final title = row[0].toString().trim();
      String rawCat = row[1].toString().trim();
      if (rawCat.isEmpty) rawCat = "Misc";
      final categoryName =
          rawCat[0].toUpperCase() + rawCat.substring(1).toLowerCase();

      final notes = row[2]?.toString().trim();
      final rawAmount = num.tryParse(row[3].toString().trim()) ?? 0;
      final double amount = rawAmount.toDouble().abs();

      final typeStr = row[4].toString().trim().toLowerCase();
      final methodStr = row[5].toString().trim().toLowerCase();
      final type = typeStr.contains('income') ? Type.income : Type.expense;
      Method method;
      if (methodStr.contains('upi') ||
          methodStr.contains('online') ||
          methodStr.contains('gpay')) {
        method = Method.upi;
      } else if (methodStr.contains('card') || methodStr.contains('bank')) {
        method = Method.card;
      } else {
        method = Method.cash;
      }

      final timestamp =
          int.tryParse(row[6].toString()) ??
          DateTime.now().millisecondsSinceEpoch;
      var category = await getCategoryByName(categoryName);

      if (category == null) {
        await insertCategory(categoryName);
        category = await getCategoryByName(categoryName);
      }

      if (category == null) {
        debugPrint('Row $i: Category logic failed for $categoryName');
        skipped++;
        continue;
      }

      final categoryId = category['id'] as String;

      final exists = await transactionExists(
        title: title,
        amount: amount,
        categoryId: categoryId,
        timestamp: timestamp,
        type: type.name,
        method: method.name,
      );

      if (exists) {
        skipped++;
        continue;
      }

      final transaction = TransactionModel(
        id: uuid.v4(),
        title: title,
        categoryId: categoryId,
        notes: notes,
        amount: amount,
        type: type,
        method: method,
        transactionTimestamp: timestamp,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await insertATransaction(transaction);
      imported++;
    } catch (e) {
      debugPrint('Error Importing Row $i: $e');
      skipped++;
    }
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Imported: $imported. Skipped: $skipped'),
        backgroundColor: imported > 0 ? Colors.green : Colors.red,
      ),
    );
    await getAllTransactions();
  }
}

Future<void> exportTransactionsToCsv(BuildContext context) async {
  debugPrint('EXPORT STARTED');

  final result = await getTransactionsForExport();
  debugPrint('Rows fetched: ${result.length}');

  if (result.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('No transactions to export')));
    return;
  }

  final List<List<dynamic>> csvData = [
    [
      'title',
      'category',
      'notes',
      'amount',
      'type',
      'method',
      'transaction_timestamp',
    ],
  ];

  for (final row in result) {
    csvData.add([
      row['title'],
      row['category'],
      row['notes'] ?? '',
      row['amount'],
      row['type'],
      row['method'],
      row['transaction_timestamp'],
    ]);
  }

  final csvString = const ListToCsvConverter().convert(csvData);
  if (Platform.isAndroid) {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/transactions_export_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(csvString);

    await Share.shareXFiles([XFile(file.path)], text: 'Transactions export');

    return;
  }

  final directory = await getDownloadsDirectory();
  final file = File(
    '${directory!.path}/transactions_export_${DateTime.now().millisecondsSinceEpoch}.csv',
  );
  await file.writeAsString(csvString);

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
}
