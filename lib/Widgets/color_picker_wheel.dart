import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:spring_autumn/Bloc/theme_state.dart';
import 'package:spring_autumn/Widgets/Custom/custom_button_one.dart';

void showColorPicker(BuildContext context) {
  final themeBloc = context.read<ThemeBloc>();

  Color tempColor = themeBloc.state.accentColor;
  bool tempUseAccent = themeBloc.state.useAccent;

  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Accent Settings",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text("Enable Accent Color"),
                    value: tempUseAccent,
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return tempColor;
                      }
                      return Colors.grey.shade400;
                    }),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return tempColor.withValues(alpha: 0.4);
                      }
                      return Colors.grey.shade300;
                    }),
                    onChanged: (value) {
                      setState(() {
                        tempUseAccent = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  if (tempUseAccent)
                    ColorPicker(
                      pickerColor: tempColor,
                      onColorChanged: (color) {
                        setState(() {
                          tempColor = color;
                        });
                      },
                      enableAlpha: false,
                      displayThumbColor: true,
                    ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: CustomButtonOne(
                  text: "Apply",
                  onTap: () {
                    if (tempUseAccent) {
                      themeBloc.add(ChangeAccentColor(tempColor));
                    } else {
                      themeBloc.add(ToggleAccent());
                    }

                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 5),

              SizedBox(
                width: double.infinity,
                child: CustomButtonOne(
                  text: "Close",
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
