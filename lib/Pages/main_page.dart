import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Pages/home_page.dart';
import 'package:spring_autumn/Pages/payments_page.dart';
import 'package:spring_autumn/Pages/plan_page.dart';
import 'package:spring_autumn/Pages/savings_page.dart';
import 'package:spring_autumn/Pages/wallet_page.dart';
import 'package:spring_autumn/Widgets/Custom/custom_app_bar.dart';
import 'package:spring_autumn/Widgets/Custom/custom_bottom_navbar.dart';
import 'package:spring_autumn/Widgets/Custom/custom_drawer.dart';
import 'package:spring_autumn/Widgets/Custom/custom_floating_action_button.dart';
import 'package:spring_autumn/Widgets/Custom/custom_floating_navbar.dart';
import 'package:spring_autumn/Widgets/Custom/custom_glass_floating_action_button.dart';
import 'package:spring_autumn/Widgets/Transaction/add_transaction_sheet.dart';
import 'package:spring_autumn/Model/transaction_model.dart';

ValueNotifier<bool> useGlassNavBar = ValueNotifier(false);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<DrawerScaffoldState> _drawerKey =
      GlobalKey<DrawerScaffoldState>();

  int _currentIndex = 0;
  late PageController _pageController;
  final List<Widget> _pages = [
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
    if (newIndex == _currentIndex) return;
    _pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      currentIndex: _currentIndex,
      onNavigate: (index) {
        _onTabChange(index);
      },
      key: _drawerKey,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: CustomAppBar(
            title: "",
            onMenuTap: () {
              _drawerKey.currentState?.toggleDrawer();
            },
          ),
          body: ValueListenableBuilder<bool>(
            valueListenable: useGlassNavBar,
            builder: (context, isGlass, _) {
              return Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _pages,
                  ),
                  if (isGlass)
                    FloatingGlassNavBar(
                      currentIndex: _currentIndex,
                      onTap: _onTabChange,
                    ),
                  if (_buildFAB(isGlass) != null)
                    Positioned(
                      bottom: isGlass ? 85 : 20,
                      right: 20,
                      child: _buildFAB(isGlass)!,
                    ),
                ],
              );
            },
          ),
          bottomNavigationBar: ValueListenableBuilder<bool>(
            valueListenable: useGlassNavBar,
            builder: (context, isGlass, _) {
              return isGlass
                  ? const SizedBox.shrink()
                  : CustomBottomNavBar(
                      currentIndex: _currentIndex,
                      onTap: _onTabChange,
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget? _buildFAB(bool isGlass) {
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
      return isGlass
          ? GlassFloatingActionButton(icon: icon, onTap: onTap)
          : CustomFloatingActionButton(icon: icon, onTap: onTap);
    }

    switch (_currentIndex) {
      case 0:
        return buildButton(Iconsax.wallet_add_1, () => openSheet());
      case 1:
        return buildButton(
          Iconsax.card_send,
          () => openSheet(type: Type.income),
        );
      case 2:
        return buildButton(Iconsax.card_receive, () => openSheet());
      default:
        return null;
    }
  }
}
