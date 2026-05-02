import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Theme/glass.dart';
import 'package:spring_autumn/Widgets/Custom/custom_primary_text.dart';

class GlassSettingsPage extends StatelessWidget {
  const GlassSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Frosted Glass Theme",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 10.0),
            child: CustomPrimaryText(
              text:
                  "Note : This is a preview of the frosted glass theme and can cause performance issues on lower-end devices",
              size: 14,
            ),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ValueListenableBuilder<GlassConfig>(
              valueListenable: glassConfig,
              builder: (context, config, _) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      _buildToggle(
                        context,
                        icon: Iconsax.menu,
                        title: "Navigation Bar",
                        value: config.navbar,
                        onChanged: (val) {
                          final newConfig = config.copyWith(navbar: val);
                          glassConfig.value = newConfig;
                          saveGlassConfig(newConfig);
                        },
                      ),
                      Divider(
                        thickness: 3,
                        color: Theme.of(context).colorScheme.surface,
                      ),

                      _buildToggle(
                        context,
                        icon: Iconsax.add_circle,
                        title: "Floating Button",
                        value: config.fab,
                        onChanged: (val) {
                          final newConfig = config.copyWith(fab: val);
                          glassConfig.value = newConfig;
                          saveGlassConfig(newConfig);
                        },
                      ),
                      Divider(
                        thickness: 3,
                        color: Theme.of(context).colorScheme.surface,
                      ),

                      _buildToggle(
                        context,
                        icon: Iconsax.mouse,
                        title: "Buttons",
                        value: config.button,
                        onChanged: (val) {
                          final newConfig = config.copyWith(button: val);
                          glassConfig.value = newConfig;
                          saveGlassConfig(newConfig);
                        },
                      ),
                      Divider(
                        thickness: 3,
                        color: Theme.of(context).colorScheme.surface,
                      ),

                      _buildToggle(
                        context,
                        icon: Iconsax.notification,
                        title: "Snackbars",
                        value: config.snackbar,
                        onChanged: (val) {
                          final newConfig = config.copyWith(snackbar: val);
                          glassConfig.value = newConfig;
                          saveGlassConfig(newConfig);
                        },
                      ),
                      Divider(
                        thickness: 3,
                        color: Theme.of(context).colorScheme.surface,
                      ),

                      _buildToggle(
                        context,
                        icon: Iconsax.menu_1,
                        title: "Drawer ",
                        value: config.drawer,
                        onChanged: (val) {
                          final newConfig = config.copyWith(drawer: val);
                          glassConfig.value = newConfig;
                          saveGlassConfig(newConfig);
                        },
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: value
              ? colorScheme.tertiary
              : colorScheme.onSurface.withOpacity(0.6),
        ),
        title: CustomPrimaryText(text: title, size: 15),
        trailing: Switch(
          value: value,
          activeColor: colorScheme.tertiary,
          onChanged: onChanged,
        ),
        onTap: () => onChanged(!value),
      ),
    );
  }
}
