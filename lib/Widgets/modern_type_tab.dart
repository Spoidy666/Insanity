import 'package:flutter/material.dart';
import 'package:spring_autumn/Model/transaction_model.dart';

class TypeToggleTab extends StatelessWidget {
  final Type selected;
  final ValueChanged<Type> onChanged;

  const TypeToggleTab({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: Type.values.map((type) {
          final isActive = selected == type;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  type.name[0].toUpperCase() + type.name.substring(1),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? Colors.white
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
