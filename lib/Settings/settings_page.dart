import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Bloc/profile/profile_cubit.dart';
import 'package:spring_autumn/Bloc/theme_state.dart';
import 'package:spring_autumn/Pages/about_page.dart';
import 'package:spring_autumn/Settings/edit_profile_sheet.dart';
import 'package:spring_autumn/Widgets/color_picker_wheel.dart';
import 'package:spring_autumn/Widgets/curreny_selecter_tile.dart';
import 'package:spring_autumn/Widgets/custom_bold_text.dart';
import 'package:spring_autumn/Widgets/custom_primary_text.dart';
import 'package:spring_autumn/Widgets/importAndExport/import_export.dart';
import 'package:spring_autumn/Widgets/theme_toggle.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_1),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ProfileCubit, ProfileModel>(
              builder: (context, profile) {
                return Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.25),
                        backgroundImage: profile.imagePath != null
                            ? FileImage(File(profile.imagePath!))
                            : null,
                        child: profile.imagePath == null
                            ? Text(
                                (profile.name != null &&
                                        profile.name!.trim().isNotEmpty)
                                    ? profile.name!.trim()[0].toUpperCase()
                                    : "?",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              )
                            : null,
                      ),

                      const SizedBox(height: 15),
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBoldText(text: "Personal Information", size: 17),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) => const EditProfileSheet(),
                    );
                  },
                  icon: Icon(Iconsax.edit),
                ),
              ],
            ),

            const SizedBox(height: 12),

            BlocBuilder<ProfileCubit, ProfileModel>(
              builder: (context, profile) {
                return _cardContainer(
                  context,
                  children: [
                    _InfoRow(
                      icon: Iconsax.sms,
                      title: "Email",
                      value: profile.email,
                    ),
                    Divider(thickness: 0.1),
                    _InfoRow(
                      icon: Iconsax.call,
                      title: "Phone",
                      value: profile.phone,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 25),

            const CustomBoldText(text: "Utilities", size: 17),

            const SizedBox(height: 12),

            _cardContainer(
              context,
              children: [
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    final isDark =
                        state.themeData.brightness == Brightness.dark;

                    return ListTile(
                      leading: const Icon(Iconsax.brush),
                      title: const CustomPrimaryText(
                        text: "Theme Mode",
                        size: 15,
                      ),
                      trailing: ThemeToggle(
                        isDark: isDark,
                        onToggle: () {
                          context.read<ThemeBloc>().add(ToggleTheme());
                        },
                      ),
                    );
                  },
                ),

                const Divider(thickness: 0.1),

                ListTile(
                  leading: const Icon(Iconsax.colorfilter),
                  title: const CustomPrimaryText(
                    text: "Accent Color",
                    size: 15,
                  ),
                  trailing: CircleAvatar(
                    radius: 12,
                    backgroundColor: context
                        .watch<ThemeBloc>()
                        .state
                        .accentColor,
                  ),
                  onTap: () => showColorPicker(context),
                ),
                const Divider(thickness: 0.1),

                const CurrencySelectorTile(),

                const Divider(thickness: 0.1),
                UtilityRow(
                  icon: Iconsax.import_1,
                  title: "Import",
                  onTap: () => showImportCsvDialog(context),
                ),
                const Divider(thickness: 0.1),
                UtilityRow(
                  icon: Iconsax.export_1,
                  title: "Export",
                  onTap: () => exportTransactionsToCsv(context),
                ),
                const Divider(thickness: 0.1),

                UtilityRow(
                  icon: Iconsax.info_circle,
                  title: "About",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutPage()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _cardContainer(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: CustomPrimaryText(text: title, size: 15),
      trailing: CustomPrimaryText(text: value, size: 13),
    );
  }
}

class UtilityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const UtilityRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: CustomPrimaryText(text: title, size: 15),
      trailing: const Icon(Iconsax.arrow_right_3),
      onTap: onTap,
    );
  }
}
