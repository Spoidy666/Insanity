import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Bloc/transactions/transaction__event.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Database/database_helper.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import 'package:spring_autumn/Widgets/Custom/custom_button_one.dart';
import 'package:spring_autumn/Widgets/Custom/custom_snackbar.dart';
import 'package:spring_autumn/Widgets/Custom/custom_text_field.dart';

class EditTransactionSheet extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionSheet({super.key, required this.transaction});

  @override
  State<EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends State<EditTransactionSheet> {
  late final TextEditingController titleController;
  late final TextEditingController amountController;
  late final TextEditingController notesController;

  late Type selectedType;
  late Method selectedMethod;
  late String selectedCategory;
  late DateTime selectedDate;

  List<Map<String, Object?>> categories = [];

  @override
  void initState() {
    super.initState();

    final tx = widget.transaction;

    titleController = TextEditingController(text: tx.title);
    amountController = TextEditingController(text: tx.amount.toString());
    notesController = TextEditingController(text: tx.notes);

    selectedType = tx.type;
    selectedMethod = tx.method;
    selectedCategory = tx.categoryId;
    selectedDate = DateTime.fromMillisecondsSinceEpoch(tx.transactionTimestamp);

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
                'Edit Transaction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: titleController,
                label: "Title",
                keyType: TextInputType.text,
              ),

              const SizedBox(height: 10),

              CustomTextField(
                controller: amountController,
                keyType: TextInputType.number,
                label: "Amount",
              ),

              const SizedBox(height: 12),

              Center(
                child: Wrap(
                  spacing: 10,
                  children: Type.values.map((t) {
                    final isSelected = selectedType == t;
                    return ChoiceChip(
                      selected: isSelected,
                      label: Text(
                        t.name[0].toUpperCase() + t.name.substring(1),
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
                      width: 2,
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
                      width: 2,
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
                onChanged: (v) => setState(() => selectedCategory = v!),
              ),

              const SizedBox(height: 12),

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
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
              ),

              CustomTextField(
                controller: notesController,
                label: "Notes (Optional)",
                keyType: TextInputType.multiline,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: CustomButtonOne(
                  text: "Update Transaction",
                  onTap: _saveChanges,
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final amount = double.tryParse(amountController.text.trim());

    if (titleController.text.trim().isEmpty || amount == null || amount <= 0) {
      CustomSnackbar.show(context, message: "Invalid input");
      return;
    }

    final updated = widget.transaction.copyWith(
      title: titleController.text.trim(),
      amount: amount,
      notes: notesController.text.trim(),
      type: selectedType,
      method: selectedMethod,
      categoryId: selectedCategory,
      transactionTimestamp: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      ).millisecondsSinceEpoch,
    );

    await updateTransaction(updated);
    context.read<TransactionBloc>().add(TransactionUpdated());

    Navigator.pop(context);
  }
}
