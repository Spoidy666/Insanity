import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Widgets/Graphs/bar_graph.dart';
import 'package:spring_autumn/Widgets/modern_type_tab.dart';
import 'package:spring_autumn/Widgets/Graphs/piechart.dart';
import 'package:spring_autumn/Widgets/Graphs/line_chart.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import 'package:spring_autumn/Widgets/Custom/custom_scroll_physics.dart';

class VisualRepresentationPage extends StatefulWidget {
  const VisualRepresentationPage({super.key});

  @override
  State<VisualRepresentationPage> createState() =>
      _VisualRepresentationPageState();
}

class _VisualRepresentationPageState extends State<VisualRepresentationPage> {
  Type selectedType = Type.expense;
  late final PageController _pageController;

  DateFilter? selectedFilter;

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
    return Scaffold(
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
            onLongPress: () {
              setState(() => selectedFilter = null);
            },
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedFilter?.date ?? DateTime.now(),
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

              if (picked != null && context.mounted) {
                final mode = await showModalBottomSheet<DateFilterMode>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (ctx) => SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Filter by",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Iconsax.calendar_1),
                            title: Text(
                              "This day  (${picked.day}/${picked.month}/${picked.year})",
                            ),
                            onTap: () => Navigator.pop(ctx, DateFilterMode.day),
                          ),
                          ListTile(
                            leading: const Icon(Iconsax.calendar),
                            title: Text(
                              "This month  (${picked.month}/${picked.year})",
                            ),
                            onTap: () =>
                                Navigator.pop(ctx, DateFilterMode.month),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                if (mode != null) {
                  setState(() {
                    selectedFilter = DateFilter(picked, mode);
                  });
                }
              }
            },
            icon: Icon(
              Iconsax.calendar_edit,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            label: Text(
              selectedFilter == null
                  ? "All time"
                  : selectedFilter!.mode == DateFilterMode.day
                  ? "${selectedFilter!.date.day}/${selectedFilter!.date.month}/${selectedFilter!.date.year}"
                  : "${selectedFilter!.date.month}/${selectedFilter!.date.year}",
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
                ChartsSection(type: Type.income, dateFilter: selectedFilter),
                ChartsSection(type: Type.expense, dateFilter: selectedFilter),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartsSection extends StatelessWidget {
  final Type type;
  final DateFilter? dateFilter;

  const ChartsSection({
    super.key,
    required this.type,
    required this.dateFilter,
  });

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
        physics: const BouncingScrollPhysicsModified(),
        key: ValueKey(
          '${type.name}-${dateFilter?.mode.name ?? "all"}-${dateFilter?.date.day ?? ""}-${dateFilter?.date.month ?? ""}-${dateFilter?.date.year ?? ""}',
        ),
        child: Column(
          children: [
            ExpensePieChartCard(type: type, dateFilter: dateFilter),
            const SizedBox(height: 40),
            ExpenseBarChartCard(type: type, dateFilter: dateFilter),
            const SizedBox(height: 40),
            ExpenseLineChartCard(type: type, month: dateFilter?.date),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
