import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Settings/settings_page.dart';
import 'package:spring_autumn/Widgets/importAndExport/import_export.dart';

class ImportExportPage extends StatelessWidget {
  const ImportExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Import And Export"),
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_1),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsListTile(
              i: Iconsax.import_1,
              title: "Import",
              onTap: () => showImportCsvDialog(context),
            ),
            Divider(thickness: 0.1),
            SettingsListTile(
              i: Iconsax.export_1,
              title: "Export",
              onTap: () => exportTransactionsToCsv(context),
            ),
          ],
        ),
      ),
    );
  }
}
