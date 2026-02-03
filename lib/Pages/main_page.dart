import 'package:flutter/material.dart';
import 'package:spring_autumn/Pages/home_page.dart';
import 'package:spring_autumn/Pages/payments_page.dart';
import 'package:spring_autumn/Pages/plan_page.dart';
import 'package:spring_autumn/Pages/savings_page.dart';
import 'package:spring_autumn/Pages/wallet_page.dart';
import 'package:spring_autumn/Widgets/custom_app_bar.dart';
import 'package:spring_autumn/Widgets/custom_bottom_navbar.dart';
import 'package:spring_autumn/Widgets/custom_drawer.dart';

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChange(int newIndex) {
    if (newIndex == _currentIndex) return;

    setState(() {
      _currentIndex = newIndex;
    });
    _pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 500),
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

          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            // Disable swiping if you only want navigation via the BottomBar
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onTabChange,
          ),
        ),
      ),
    );
  }
}
