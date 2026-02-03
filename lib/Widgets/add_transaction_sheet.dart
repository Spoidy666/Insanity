import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Bloc/transactions/transaction__event.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Database/database_helper.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import 'package:spring_autumn/Widgets/custom_snackbar.dart';
import 'package:spring_autumn/Widgets/custom_text_field.dart';
import 'package:uuid/uuid.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final notesController = TextEditingController();

  Type selectedType = Type.expense;
  Method selectedMethod = Method.cash;

  String? selectedCategory;
  DateTime selectedDate = DateTime.now();

  List<Map<String, Object?>> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result = await getAllCategories();
    if (!mounted) return;
    setState(() => categories = result);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SizedBox(
                  width: 40,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Add Transaction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: titleController,
                label: "Title",
                keyType: TextInputType.text,
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: amountController,
                keyType: TextInputType.number,
                label: "Amount",
              ),

              const SizedBox(height: 10),
              Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: Type.values.map((t) {
                    final isSelected = selectedType == t;

                    return ChoiceChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      checkmarkColor: Theme.of(context).colorScheme.surface,
                      label: Text(
                        t.name[0].toUpperCase() + t.name.substring(1),
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      selected: isSelected,

                      backgroundColor: Theme.of(context).colorScheme.primary,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      onSelected: (_) => setState(() => selectedType = t),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 15),
              DropdownButtonFormField<Method>(
                initialValue: selectedMethod,
                borderRadius: BorderRadius.circular(12),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 1,
                    ),
                  ),
                ),
                items: Method.values.map((m) {
                  return DropdownMenuItem<Method>(
                    value: m,
                    child: Text(
                      m.name[0].toUpperCase() + m.name.substring(1),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                onChanged: (v) => setState(() => selectedMethod = v!),
              ),

              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                borderRadius: BorderRadius.circular(12),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 1,
                    ),
                  ),
                ),
                items: categories.map((c) {
                  return DropdownMenuItem<String>(
                    value: c['id'] as String,
                    child: Text(
                      c['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                onChanged: (v) => setState(() => selectedCategory = v),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    final newCategoryId = await showModalBottomSheet<String>(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) => const AddCategorySheet(),
                    );

                    if (newCategoryId != null) {
                      await _loadCategories();
                      setState(() => selectedCategory = newCategoryId);
                    }
                  },

                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  label: Text(
                    'Add Category',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Transaction Date'),
                subtitle: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                trailing: const Icon(Iconsax.calendar_edit),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
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
                    setState(() => selectedDate = picked);
                  }
                },
              ),

              CustomTextField(
                controller: notesController,
                keyType: TextInputType.multiline,

                label: "Notes (Optional)",
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) {
                      CustomSnackbar.show(context, message: "Enter the title");

                      return;
                    }

                    if (amountController.text.trim().isEmpty) {
                      CustomSnackbar.show(context, message: "Enter the amount");

                      return;
                    }
                    if (selectedCategory == null) {
                      CustomSnackbar.show(
                        context,
                        message: "Select a Category",
                      );

                      return;
                    }

                    final amount = int.tryParse(amountController.text);
                    if (amount == null || amount <= 0) {
                      CustomSnackbar.show(
                        context,
                        message: "The Amount should be above 0",
                      );

                      return;
                    }

                    final transaction = TransactionModel(
                      id: const Uuid().v4(),
                      title: titleController.text.trim(),
                      categoryId: selectedCategory!,
                      notes: notesController.text.trim().isEmpty
                          ? ""
                          : notesController.text.trim(),
                      amount: amount,
                      type: selectedType,
                      method: selectedMethod,
                      transactionTimestamp: DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                      ).millisecondsSinceEpoch,
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                    );

                    await insertATransaction(transaction);
                    context.read<TransactionBloc>().add(TransactionAdded());
                    Navigator.pop(context);
                  },

                  child: Text(
                    'Save Transaction',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: controller,
            label: 'Category Name',
            keyType: TextInputType.text,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final name =
                    controller.text.trim()[0].toUpperCase() +
                    controller.text.trim().substring(1);

                if (name.isEmpty) {
                  CustomSnackbar.show(context, message: 'Enter category name');
                  return;
                }

                await insertCategory(name);

                final category = await getCategoryByName(name);
                Navigator.pop(context, category?['id']);
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
