import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Bloc/theme_state.dart';
import 'package:spring_autumn/Pages/about_page.dart';
import 'package:spring_autumn/Pages/profile_page.dart';
import 'package:spring_autumn/Settings/importSettings.dart';
import 'package:spring_autumn/Widgets/custom_primary_text.dart';
import 'package:spring_autumn/Widgets/theme_toggle.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                final isDark = state.themeData.brightness == Brightness.dark;

                return Container(
                  height: 700,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Column(
                      children: [
                        SettingsListTile(
                          i: Icons.person,
                          title: "Profile",
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return ProfilePage();
                                },
                              ),
                            );
                          },
                        ),
                        Divider(thickness: 0.1),

                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              const SizedBox(width: 15),
                              Icon(Iconsax.brush),
                              const SizedBox(width: 10),
                              Text(
                                "Theme Mode",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: ThemeToggle(
                              isDark: isDark,
                              onToggle: () {
                                context.read<ThemeBloc>().add(ToggleTheme());
                              },
                            ),
                          ),
                        ),
                        const Divider(thickness: 0.1),
                        SettingsListTile(
                          i: Iconsax.import_1,
                          title: "Import and Export",
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return ImportExportPage();
                                },
                              ),
                            );
                          },
                        ),
                        const Divider(thickness: 0.1),
                        SettingsListTile(
                          i: Iconsax.info_circle,
                          title: "About",
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return AboutPage();
                                },
                              ),
                            );
                          },
                        ),
                        const Divider(thickness: 0.1),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final IconData i;
  final String title;
  final VoidCallback onTap;

  const SettingsListTile({
    super.key,
    required this.i,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(i),
          const SizedBox(width: 10),
          CustomPrimaryText(text: title, size: 17),
        ],
      ),
      trailing: Icon(Iconsax.arrow_right_3),
      onTap: onTap,
    );
  }
}
