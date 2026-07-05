import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:spring_autumn/Pages/about_page.dart';
import 'package:spring_autumn/Pages/home_page.dart';
import 'package:spring_autumn/Pages/payments_page.dart';
import 'package:spring_autumn/Pages/plan_page.dart';
import 'package:spring_autumn/Pages/savings_page.dart';
import 'package:spring_autumn/Pages/visual_representation_page.dart';
import 'package:spring_autumn/Pages/wallet_page.dart';
import 'package:spring_autumn/Settings/glass_settings.dart';
import 'package:spring_autumn/Settings/settings_page.dart';
import 'package:spring_autumn/Theme/glass.dart';
import 'package:spring_autumn/Widgets/Custom/custom_app_bar.dart';
import 'package:spring_autumn/Widgets/Custom/custom_bottom_navbar.dart';
import 'package:spring_autumn/Widgets/Custom/custom_drawer.dart';
import 'package:spring_autumn/Widgets/Custom/custom_floating_action_button.dart';
import 'package:spring_autumn/Widgets/Custom/custom_floating_navbar.dart';
import 'package:spring_autumn/Widgets/Glass/custom_glass_floating_action_button.dart';
import 'package:spring_autumn/Widgets/Transaction/add_transaction_sheet.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import 'dart:math';

enum OverlayPage { settings, graphs, glass, about }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<OverlayPage> _pageStack = [];
  bool get _hasOverlay => _pageStack.isNotEmpty;
  OverlayPage? get _currentOverlay => _pageStack.lastOrNull;

  void _pushOverlay(OverlayPage page) {
    setState(() => _pageStack.add(page));
  }

  void _popOverlay() {
    if (_pageStack.isNotEmpty) setState(() => _pageStack.removeLast());
  }

  Widget _buildOverlayWidget(OverlayPage page) {
    return switch (page) {
      OverlayPage.settings => SettingsPage(onOverlayNavigate: _pushOverlay),
      OverlayPage.graphs => const VisualRepresentationPage(),
      OverlayPage.glass => const GlassSettingsPage(),

      OverlayPage.about => const AboutPage(),
    };
  }

  final GlobalKey<DrawerScaffoldState> _drawerKey =
      GlobalKey<DrawerScaffoldState>();

  int _currentIndex = 0;
  late PageController _pageController;
  final List<Widget> _pages = const [
    HomePage(),
    WalletPage(),
    PaymentsPage(),
    SavingsPage(),
    PlanPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    _pageController.addListener(() {
      final page = _pageController.page;
      if (page == null) return;
      if (page == page.roundToDouble()) {
        final settled = page.round();
        if (settled != _currentIndex) {
          setState(() => _currentIndex = settled);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChange(int newIndex) {
    if (_pageStack.isNotEmpty) setState(() => _pageStack.clear());
    if (newIndex == _currentIndex) return;
    _pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasOverlay,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _hasOverlay) _popOverlay();
      },
      child: DrawerScaffold(
        currentIndex: _currentIndex,
        onNavigate: (index) {
          _onTabChange(index);
          _popOverlay();
        },
        onOverlayNavigate: _pushOverlay,
        activeOverlay: _currentOverlay,
        key: _drawerKey,
        child: SafeArea(
          top: false,
          child: Scaffold(
            appBar: CustomAppBar(
              title: _currentOverlay?.label ?? "",
              showBackButton: _hasOverlay,
              onBackTap: _popOverlay,
              onMenuTap: () => _drawerKey.currentState?.toggleDrawer(),
              onSettingsTap: () => _pushOverlay(OverlayPage.settings),
              isSettingsActive: _currentOverlay == OverlayPage.settings,
            ),
            body: ValueListenableBuilder<GlassConfig>(
              valueListenable: glassConfig,
              builder: (context, config, _) {
                return Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _pages,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOutCubic,
                      switchOutCurve: Curves.easeInOutCubic,
                      transitionBuilder: (child, animation) {
                        final slide = Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return SlideTransition(position: slide, child: child);
                      },
                      child: _hasOverlay
                          ? KeyedSubtree(
                              key: ValueKey(_currentOverlay),
                              child: Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: _buildOverlayWidget(_currentOverlay!),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    LiquidGlassLayer(
                      settings: LiquidGlassSettings(
                        thickness: 25,
                        lightAngle: pi / 2,
                        chromaticAberration: 0.15,
                      ),
                      child: Stack(
                        children: [
                          if (config.navbar)
                            FloatingGlassNavBar(
                              currentIndex: _currentIndex,
                              onTap: _onTabChange,
                            ),

                          if (_buildFAB(config) != null && !_hasOverlay)
                            Positioned(
                              bottom: config.navbar ? 85 : 20,
                              right: 20,
                              child: _buildFAB(config)!,
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            bottomNavigationBar: ValueListenableBuilder<GlassConfig>(
              valueListenable: glassConfig,
              builder: (context, config, _) {
                return config.navbar
                    ? const SizedBox.shrink()
                    : CustomBottomNavBar(
                        currentIndex: _currentIndex,
                        onTap: _onTabChange,
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildFAB(GlassConfig config) {
    void openSheet({Type? type}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        builder: (_) => type == null
            ? const AddTransactionSheet()
            : AddTransactionSheet(defaultType: type),
      );
    }

    Widget buildButton(IconData icon, VoidCallback onTap) {
      return config.fab
          ? GlassFloatingActionButton(icon: icon, onTap: onTap)
          : CustomFloatingActionButton(icon: icon, onTap: onTap);
    }

    switch (_currentIndex) {
      case 0:
        return buildButton(Iconsax.card_add, () => openSheet());
      case 1:
        return buildButton(
          Iconsax.card_send,
          () => openSheet(type: Type.income),
        );
      case 2:
        return buildButton(Iconsax.card_receive, () => openSheet());
      case 3:
        return buildButton(
          Iconsax.add_circle,
          () => showAddSavingSheet(context),
        );
      default:
        return null;
    }
  }
}

extension OverlayPageLabel on OverlayPage {
  String get label => switch (this) {
    OverlayPage.settings => "Settings",
    OverlayPage.graphs => "Graph View",
    OverlayPage.glass => "Glass Theme",
    OverlayPage.about => "About ",
  };
}
