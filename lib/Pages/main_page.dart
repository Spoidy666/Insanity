import 'package:flutter/material.dart';
import 'package:spring_autumn/Model/goal_modal.dart';
import 'package:spring_autumn/Pages/home_page.dart';
import 'package:spring_autumn/Pages/payments_page.dart';
import 'package:spring_autumn/Pages/plan_page.dart';
import 'package:spring_autumn/Pages/savings_page.dart';
import 'package:spring_autumn/Pages/wallet_page.dart';
import 'package:spring_autumn/Widgets/custom_app_bar.dart';
import 'package:spring_autumn/Widgets/custom_bottom_navbar.dart';
import 'package:spring_autumn/Widgets/custom_drawer.dart';

final List<GoalModel> dummyGoals = [
  GoalModel(
    id: "g1",
    title: "New Car",
    targetAmount: 8000,
    currentAmount: 6000,
    deadline: DateTime.now()
        .add(const Duration(days: 90))
        .millisecondsSinceEpoch,
    priority: 1,
    createdAt: DateTime.now().millisecondsSinceEpoch,
  ),
  GoalModel(
    id: "g2",
    title: "Emergency Fund",
    targetAmount: 5000,
    currentAmount: 1200,
    deadline: DateTime.now()
        .add(const Duration(days: 180))
        .millisecondsSinceEpoch,
    priority: 2,
    createdAt: DateTime.now().millisecondsSinceEpoch,
  ),
  GoalModel(
    id: "g3",
    title: "New Laptop",
    targetAmount: 2000,
    currentAmount: 2000,
    deadline: DateTime.now()
        .add(const Duration(days: 30))
        .millisecondsSinceEpoch,
    priority: 1,
    createdAt: DateTime.now().millisecondsSinceEpoch,
  ),
  GoalModel(
    id: "g4",
    title: "Trip to Japan",
    targetAmount: 10000,
    currentAmount: 2500,
    deadline: DateTime.now()
        .add(const Duration(days: 365))
        .millisecondsSinceEpoch,
    priority: 3,
    createdAt: DateTime.now().millisecondsSinceEpoch,
  ),
  GoalModel(
    id: "g5",
    title: "Home Down Payment",
    targetAmount: 50000,
    currentAmount: 7500,
    deadline: DateTime.now()
        .add(const Duration(days: 730))
        .millisecondsSinceEpoch,
    priority: 2,
    createdAt: DateTime.now().millisecondsSinceEpoch,
  ),
];

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
    PlanPage(goals: dummyGoals),
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
