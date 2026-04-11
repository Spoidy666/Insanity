import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Widgets/Graphs/bar_graph.dart';
import 'package:spring_autumn/Widgets/Graphs/line_chart.dart';
import 'package:spring_autumn/Widgets/modern_type_tab.dart';
import 'package:spring_autumn/Widgets/Graphs/piechart.dart';
import 'package:spring_autumn/Model/transaction_model.dart';

class VisualRepresentationPage extends StatefulWidget {
  const VisualRepresentationPage({super.key});

  @override
  State<VisualRepresentationPage> createState() =>
      _VisualRepresentationPageState();
}

class _VisualRepresentationPageState extends State<VisualRepresentationPage> {
  Type selectedType = Type.expense;
  late final PageController _pageController;

  DateTime? selectedMonth;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedType.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Graphs"),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_1),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            TypeToggleTab(
              selected: selectedType,
              onChanged: (type) {
                setState(() => selectedType = type);
                _pageController.animateToPage(
                  type.index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                );
              },
            ),

            const SizedBox(height: 8),

            TextButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedMonth ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  initialDatePickerMode: DatePickerMode.day,
                  builder: (context, child) {
                    final theme = Theme.of(context);
                    return Theme(
                      data: theme.copyWith(
                        colorScheme: theme.colorScheme,
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (picked != null) {
                  setState(() {
                    selectedMonth = DateTime(picked.year, picked.month);
                  });
                }
              },
              onLongPress: () {
                setState(() => selectedMonth = null);
              },
              icon: Icon(
                Iconsax.calendar_edit,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              label: Text(
                selectedMonth == null
                    ? "All time"
                    : "${selectedMonth!.month}/${selectedMonth!.year}",
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),

            const SizedBox(height: 12),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => selectedType = Type.values[index]);
                },
                children: [
                  ChartsSection(type: Type.income, month: selectedMonth),
                  ChartsSection(type: Type.expense, month: selectedMonth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartsSection extends StatelessWidget {
  final Type type;
  final DateTime? month;

  const ChartsSection({super.key, required this.type, required this.month});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        key: ValueKey(
          '${type.name}-${month?.month ?? "all"}-${month?.year ?? ""}',
        ),
        child: Column(
          children: [
            ExpensePieChartCard(type: type, month: month),
            const SizedBox(height: 40),
            ExpenseBarChartCard(type: type, month: month),
            const SizedBox(height: 40),
            ExpenseLineChartCard(type: type, month: month),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
