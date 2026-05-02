import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spring_autumn/Bloc/currency/currency_cubit.dart';
import 'package:spring_autumn/Widgets/Custom/custom_bold_text.dart';

// Dummy Model for Savings
class SavingsGoal {
  final String id;
  final String title;
  final IconData icon;
  final double currentAmount;
  final double targetAmount;
  final Color iconColor;

  SavingsGoal({
    required this.id,
    required this.title,
    required this.icon,
    required this.currentAmount,
    required this.targetAmount,
    required this.iconColor,
  });

  double get progress => (currentAmount / targetAmount).clamp(0.0, 1.0);
}

// Dummy Data Notifier
final ValueNotifier<List<SavingsGoal>> dummyGoalsNotifier = ValueNotifier([
  SavingsGoal(
    id: '1',
    title: 'Emergency Fund',
    icon: Iconsax.safe_home,
    currentAmount: 2500,
    targetAmount: 5000,
    iconColor: Colors.blueAccent,
  ),
  SavingsGoal(
    id: '2',
    title: 'New Laptop',
    icon: Iconsax.monitor,
    currentAmount: 800,
    targetAmount: 2000,
    iconColor: Colors.purpleAccent,
  ),
  SavingsGoal(
    id: '3',
    title: 'Japan Vacation',
    icon: Iconsax.airplane,
    currentAmount: 3200,
    targetAmount: 4000,
    iconColor: Colors.orangeAccent,
  ),
  SavingsGoal(
    id: '4',
    title: 'Car Downpayment',
    icon: Iconsax.car,
    currentAmount: 1500,
    targetAmount: 10000,
    iconColor: Colors.greenAccent,
  ),
]);

void showAddSavingSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const AddSavingSheet(),
  );
}

class AddSavingSheet extends StatefulWidget {
  const AddSavingSheet({super.key});

  @override
  State<AddSavingSheet> createState() => _AddSavingSheetState();
}

class _AddSavingSheetState extends State<AddSavingSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<IconData> _icons = [
    Iconsax.safe_home,
    Iconsax.airplane,
    Iconsax.car,
    Iconsax.monitor,
    Iconsax.mobile,
    Iconsax.shopping_bag,
    Iconsax.book,
    Iconsax.heart,
  ];

  final List<Color> _colors = [
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.redAccent,
    Colors.cyanAccent,
    Colors.yellowAccent,
  ];

  late IconData _selectedIcon;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedIcon = _icons.first;
    _selectedColor = _colors.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleController.text.trim().isEmpty ||
        _amountController.text.trim().isEmpty) {
      return;
    }

    final targetAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (targetAmount <= 0) return;

    final newGoal = SavingsGoal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      icon: _selectedIcon,
      currentAmount: 0,
      targetAmount: targetAmount,
      iconColor: _selectedColor,
    );

    dummyGoalsNotifier.value = [...dummyGoalsNotifier.value, newGoal];
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomBoldText(text: "New Savings Goal", size: 22),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Goal Title",
              filled: true,
              fillColor: Theme.of(context).colorScheme.primary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: "Target Amount",
              filled: true,
              fillColor: Theme.of(context).colorScheme.primary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Select Icon",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _icons.map((icon) {
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _selectedColor.withValues(alpha: 0.2)
                          : Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: _selectedColor, width: 2)
                          : null,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? _selectedColor
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Select Color",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Create Goal",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<CurrencyCubit, AppCurrency>(
      builder: (context, currency) {
        final formatter = NumberFormat.currency(
          locale: currency.locale,
          symbol: currency.symbol,
          decimalDigits: currency.decimalDigits,
        );

        return ValueListenableBuilder<List<SavingsGoal>>(
          valueListenable: dummyGoalsNotifier,
          builder: (context, goals, _) {
            final totalSaved = goals.fold<double>(
              0,
              (sum, item) => sum + item.currentAmount,
            );
            final totalTarget = goals.fold<double>(
              0,
              (sum, item) => sum + item.targetAmount,
            );
            final totalProgress = totalTarget > 0
                ? (totalSaved / totalTarget).clamp(0.0, 1.0)
                : 0.0;

            return Scaffold(
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header / Total Savings Hero Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Savings",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomBoldText(
                                text: formatter.format(totalSaved),
                                size: 32,
                              ),
                              const SizedBox(height: 20),
                              // Global Progress Bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: totalProgress,
                                  minHeight: 10,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surface,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Goal: ${formatter.format(totalTarget)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  Text(
                                    "${(totalProgress * 100).toStringAsFixed(1)}%",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Title for the list
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomBoldText(text: "Your Goals", size: 20),
                        ],
                      ),
                    ),
                  ),

                  // Goals List
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final goal = goals[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Normal tapping functionality for ${goal.title} coming soon!",
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Card(
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: goal.iconColor.withValues(
                                            alpha: 0.15,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          goal.icon,
                                          color: goal.iconColor,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomBoldText(
                                              text: goal.title,
                                              size: 17,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${formatter.format(goal.currentAmount)} / ${formatter.format(goal.targetAmount)}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: goal.progress,
                                            minHeight: 8,
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  goal.iconColor,
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "${(goal.progress * 100).toStringAsFixed(1)}%",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: goal.iconColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: goals.length),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
