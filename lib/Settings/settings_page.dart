import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Bloc/Settings/font_size.dart';
import 'package:spring_autumn/Bloc/profile/profile_cubit.dart';
import 'package:spring_autumn/Bloc/theme_state.dart';
import 'package:spring_autumn/Bloc/transactions/transaction__event.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Database/database_helper.dart';
import 'package:spring_autumn/Pages/about_page.dart';
import 'package:spring_autumn/Settings/edit_profile_sheet.dart';
import 'package:spring_autumn/Settings/glass_settings.dart';
import 'package:spring_autumn/Widgets/Custom/custom_button_one.dart';
import 'package:spring_autumn/Widgets/Custom/custom_snackbar.dart';
import 'package:spring_autumn/Widgets/color_picker_wheel.dart';
import 'package:spring_autumn/Widgets/curreny_selecter_tile.dart';
import 'package:spring_autumn/Widgets/Custom/custom_bold_text.dart';
import 'package:spring_autumn/Widgets/Custom/custom_primary_text.dart';
import 'package:spring_autumn/Widgets/default_payment_method.dart';
import 'package:spring_autumn/Widgets/importAndExport/import_export.dart';
import 'package:spring_autumn/Widgets/theme_toggle.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left_2),
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                  ),
                                )
                              : null,
                        ),

                        const SizedBox(height: 15),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,

                          child: Text(
                            profile.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
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
                      Divider(
                        thickness: 3,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      _InfoRow(
                        icon: Iconsax.call,
                        title: "Phone",
                        value: profile.phone,
                      ),
                      const SizedBox(height: 5),
                    ],
                  );
                },
              ),
              const SizedBox(height: 25),

              const CustomBoldText(text: "Theme", size: 17),
              const SizedBox(height: 12),
              _cardContainer(
                context,
                children: [
                  const SizedBox(height: 5),
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
                  Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  UtilityRow(
                    icon: Iconsax.designtools,
                    title: "Frosted Glass Theme",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GlassSettingsPage(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: ListTile(
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
                  ),

                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(height: 25),

              const CustomBoldText(text: "Utilities", size: 17),

              const SizedBox(height: 12),

              _cardContainer(
                context,
                children: [
                  const SizedBox(height: 5),

                  const CurrencySelectorTile(),
                  Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  BlocBuilder<MiniPlayerSettingsCubit, double>(
                    builder: (context, value) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: const [
                            SizedBox(width: 15),
                            Icon(Iconsax.size),
                            SizedBox(width: 10),
                            CustomPrimaryText(text: "Font size", size: 15),
                          ],
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Slider(
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  value: value,

                                  onChanged: (newValue) {
                                    context
                                        .read<MiniPlayerSettingsCubit>()
                                        .update(newValue);
                                  },
                                  thumbColor: Theme.of(
                                    context,
                                  ).colorScheme.tertiary,
                                  inactiveColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  activeColor: Theme.of(
                                    context,
                                  ).colorScheme.tertiary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("${value.toInt()}%"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  UtilityRow(
                    icon: Iconsax.card,
                    title: "Default Payment Method",
                    onTap: () async {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (_) => DefaultMethodSheet(),
                      );
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  UtilityRow(
                    icon: Iconsax.box_remove,
                    title: "Delete Category",
                    onTap: () => _showDeleteCategoryPopup(context),
                  ),
                  Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  UtilityRow(
                    icon: Iconsax.import_1,
                    title: "Import",
                    onTap: () => showImportCsvDialog(context),
                  ),
                  Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  UtilityRow(
                    icon: Iconsax.export_1,
                    title: "Export",
                    onTap: () => exportTransactionsToCsv(context),
                  ),
                  Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.surface,
                  ),

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
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
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
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(icon),
        title: CustomPrimaryText(text: title, size: 15),
        trailing: const Icon(Iconsax.arrow_right_3),
        onTap: onTap,
      ),
    );
  }
}

void _showDeleteCategoryPopup(BuildContext context) async {
  final categories = await getAllCategories();

  String? selectedCategoryId;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Delete Category?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),
                  CustomPrimaryText(
                    text:
                        "All transactions under this category will also be deleted.",
                    size: 15,
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(10),
                    initialValue: selectedCategoryId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Select Category",
                    ),
                    items: categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat['id'] as String,
                        child: Text(cat['name'] as String),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonOne(
                          text: "Cancel",
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButtonOne(
                          text: "Delete",
                          type: ButtonType.danger,
                          onTap: selectedCategoryId == null
                              ? () {
                                  CustomSnackbar.show(
                                    context,
                                    message:
                                        "Please select a category to delete",
                                    top: true,
                                  );
                                }
                              : () async {
                                  await deleteCategory(selectedCategoryId!);

                                  context.read<TransactionBloc>().add(
                                    TransactionDeleted(),
                                  );

                                  Navigator.pop(context);
                                  CustomSnackbar.show(
                                    context,
                                    message: "Category deleted successfully",
                                    type: SnackbarType.success,
                                  );
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
