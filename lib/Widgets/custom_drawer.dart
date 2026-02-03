import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Bloc/theme_state.dart';
import 'package:spring_autumn/Pages/visual_representation_page.dart';
import 'package:spring_autumn/Settings/settings_page.dart';
import 'package:spring_autumn/Widgets/drawer_button.dart';
import 'package:spring_autumn/Widgets/drawer_theme_toggle.dart';
import 'package:spring_autumn/Widgets/importAndExport/import_export.dart';

class CustomDrawer extends StatelessWidget {
  final void Function(int index) onItemTap;
  final int currentIndex;

  const CustomDrawer({
    super.key,
    required this.onItemTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SizedBox(
          width: 170,
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 15),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey,
                  ),
                  child: const Center(
                    child: Text(
                      "Insanity",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const Divider(thickness: 0.3, height: 30),

                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        CustomDrawerButton(
                          name: "Home",
                          onTap: () => onItemTap(0),
                          isActive: currentIndex == 0,
                          i: Iconsax.home_2,
                        ),
                        const SizedBox(height: 10),
                        CustomDrawerButton(
                          name: "Wallet",
                          onTap: () => onItemTap(1),
                          isActive: currentIndex == 1,
                          i: Iconsax.wallet,
                        ),
                        const SizedBox(height: 10),
                        CustomDrawerButton(
                          name: "Expenses",
                          onTap: () => onItemTap(2),
                          isActive: currentIndex == 2,
                          i: Iconsax.money,
                        ),
                        const SizedBox(height: 10),
                        CustomDrawerButton(
                          name: "Savings",
                          onTap: () => onItemTap(3),
                          isActive: currentIndex == 3,
                          i: Iconsax.wallet_money,
                        ),
                        const SizedBox(height: 10),
                        CustomDrawerButton(
                          name: "Plan",
                          onTap: () => onItemTap(4),
                          isActive: currentIndex == 4,
                          i: Iconsax.graph,
                        ),
                        const SizedBox(height: 10),
                        CustomDrawerButton(
                          name: "Graphs",
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const VisualRepresentationPage(),
                              ),
                            );
                          },
                          isActive: false,
                          i: Iconsax.status,
                        ),
                        const SizedBox(height: 10),
                        CustomDrawerButton(
                          name: "Import",
                          onTap: () => showImportCsvDialog(context),
                          isActive: false,
                          i: Iconsax.import_1,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    final isDark =
                        state.themeData.brightness == Brightness.dark;
                    return DrawerThemeToggle(
                      isDark: isDark,
                      onToggle: () =>
                          context.read<ThemeBloc>().add(ToggleTheme()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => SettingsPage()));
                    },
                    child: Icon(
                      Iconsax.setting_24,
                      size: 25,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerScaffold extends StatefulWidget {
  final Widget child;
  final ValueChanged<int> onNavigate;
  final int currentIndex;

  const DrawerScaffold({
    super.key,
    required this.child,
    required this.onNavigate,
    required this.currentIndex,
  });

  @override
  DrawerScaffoldState createState() => DrawerScaffoldState();
}

class DrawerScaffoldState extends State<DrawerScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curvedAnimation;
  final double maxSlide = 180;
  void navigateTo(int index) {
    widget.onNavigate(index);
    toggleDrawer();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  void toggleDrawer() =>
      _controller.isDismissed ? _controller.forward() : _controller.reverse();

  void _onDragUpdate(DragUpdateDetails details) {
    _controller.value += details.primaryDelta! / maxSlide;
  }

  void _onDragEnd(DragEndDetails details) {
    if (_controller.isDismissed || _controller.isCompleted) return;

    if (details.velocity.pixelsPerSecond.dx.abs() >= 365) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / maxSlide;
      _controller.fling(velocity: visualVelocity);
    } else if (_controller.value < 0.5) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          double slide = maxSlide * _curvedAnimation.value;
          double radius = _curvedAnimation.value * 30;

          return Stack(
            children: [
              CustomDrawer(
                onItemTap: navigateTo,
                currentIndex: widget.currentIndex,
              ),
              Transform(
                transform: Matrix4.identity()..translate(slide),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      if (_controller.value > 0)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 25,
                          spreadRadius: 5,
                          offset: const Offset(-10, 0),
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Stack(
                      children: [
                        widget.child,

                        if (_controller.value > 0)
                          GestureDetector(
                            onTap: _curvedAnimation.value > 0.1
                                ? toggleDrawer
                                : null,
                            child: BlocBuilder<ThemeBloc, ThemeState>(
                              builder: (context, state) {
                                final isDark =
                                    state.themeData.brightness ==
                                    Brightness.dark;
                                return Container(
                                  color: isDark
                                      ? Colors.grey.shade700.withValues(
                                          alpha: 0.15 * _curvedAnimation.value,
                                        )
                                      : Colors.black.withValues(
                                          alpha: 0.60 * _curvedAnimation.value,
                                        ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
