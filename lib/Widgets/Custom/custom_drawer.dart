import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Bloc/theme_state.dart';
import 'package:spring_autumn/Pages/main_page.dart';
import 'package:spring_autumn/Widgets/Custom/custom_icon_button_one.dart';
import 'package:spring_autumn/Widgets/drawer_button.dart';
import 'package:spring_autumn/Widgets/drawer_theme_toggle.dart';
import 'package:spring_autumn/Widgets/importAndExport/import_export.dart';
import 'package:spring_autumn/Widgets/Custom/custom_scroll_physics.dart';

class CustomDrawer extends StatelessWidget {
  final void Function(int index) onItemTap;
  final int currentIndex;
  final void Function(OverlayPage page) onOverlayNavigate;
  final OverlayPage? activeOverlay;
  const CustomDrawer({
    super.key,
    required this.onItemTap,
    required this.currentIndex,
    required this.onOverlayNavigate,
    this.activeOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: SizedBox(
            width: 170,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 15),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 7, 51, 126),
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
                      physics: const BouncingScrollPhysicsModified(),
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
                              onOverlayNavigate(OverlayPage.graphs);
                            },
                            isActive: activeOverlay == OverlayPage.graphs,
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
                          CustomDrawerButton(
                            name: "Export",
                            onTap: () => exportTransactionsToCsv(context),
                            isActive: false,
                            i: Iconsax.export_1,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

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
                    child: CustomIconButtonOne(
                      icon: Iconsax.setting_24,
                      onTap: () {
                        onOverlayNavigate(OverlayPage.settings);
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
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
  final void Function(OverlayPage page) onOverlayNavigate;
  final OverlayPage? activeOverlay;

  const DrawerScaffold({
    super.key,
    required this.child,
    required this.onNavigate,
    required this.currentIndex,
    required this.onOverlayNavigate,
    this.activeOverlay,
  });

  @override
  State<DrawerScaffold> createState() => DrawerScaffoldState();
}

class DrawerScaffoldState extends State<DrawerScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  final double maxSlide = 180;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  void toggleDrawer() =>
      _controller.isDismissed ? _controller.forward() : _controller.reverse();

  void _onDragUpdate(DragUpdateDetails details) {
    _controller.value = (_controller.value + details.primaryDelta! / maxSlide)
        .clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;

    if (velocity.abs() > 200) {
      if (velocity > 0) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      return;
    }

    if (_controller.value > 0.2) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void navigateTo(int index) {
    widget.onNavigate(index);
    toggleDrawer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cache the drawer and main content outside the AnimatedBuilder
    // so they don't rebuild every frame. Wrapped in RepaintBoundary
    // so their pixels are rasterized once and then just transformed.
    final drawerContent = RepaintBoundary(
      child: CustomDrawer(
        onItemTap: navigateTo,
        currentIndex: widget.currentIndex,
        onOverlayNavigate: overlayNavigate,
        activeOverlay: widget.activeOverlay,
      ),
    );

    final mainContent = RepaintBoundary(child: widget.child);

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final slide = maxSlide * _animation.value;
          final radius = 30 * _animation.value;

          return Stack(
            children: [
              Opacity(
                opacity: 0.7 + (0.3 * _animation.value),
                child: Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..translate(-60 * (1 - _animation.value))
                    ..scale(0.95 + (0.05 * _animation.value), 1.0),
                  child: drawerContent,
                ),
              ),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()..translate(slide),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Stack(
                    children: [
                      mainContent,
                      if (_animation.value > 0)
                        GestureDetector(
                          onTap: toggleDrawer,
                          child: Container(
                            color: Colors.black.withValues(
                              alpha: 0.60 * _animation.value,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void overlayNavigate(OverlayPage page) {
    widget.onOverlayNavigate(page);
    _controller.reverse();
  }
}
