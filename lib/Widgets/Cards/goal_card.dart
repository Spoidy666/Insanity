import 'package:flutter/material.dart';
import 'package:spring_autumn/Model/goal_modal.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _priorityColor(goal.priority),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          // Icon Background
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            radius: 25,
            child: Icon(_getIcon(goal.title), color: Colors.white),
          ),
          const SizedBox(width: 20),
          // Text Content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getDeadline(goal),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Progress Circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 65,
                height: 65,
                child: CircularProgressIndicator(
                  value: goal.progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Text(
                "${(goal.progress * 100).toInt()}°", 
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _priorityColor(int p) {
    if (p == 1) return const Color(0xFFFF4B5C);
    if (p == 2) return const Color(0xFFFFA351);
    return const Color(0xFF4DA6FF);
  }

  IconData _getIcon(String title) {
    if (title.contains("Car")) return Icons.directions_car_filled;
    if (title.contains("House")) return Icons.home_filled;
    return Icons.beach_access_rounded;
  }

  String _getDeadline(GoalModel goal) {
    return "3 Months left";
  }
}

class _GoalInfo extends StatelessWidget {
  final GoalModel goal;

  const _GoalInfo({required this.goal});

  @override
  Widget build(BuildContext context) {
    String subtitle;

    if (goal.deadlineDate != null) {
      final daysLeft = goal.deadlineDate!.difference(DateTime.now()).inDays;
      subtitle = daysLeft > 0 ? "$daysLeft days left" : "Deadline passed";
    } else {
      subtitle = "No deadline";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          goal.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 10),
        Text(
          "\$${goal.currentAmount.toStringAsFixed(0)} / \$${goal.targetAmount.toStringAsFixed(0)}",
          style: const TextStyle(fontSize: 13, color: Colors.white70),
        ),
      ],
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  final double progress;
  final String label;

  const _ProgressCircle({required this.progress, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0, 1),
            strokeWidth: 6,
            backgroundColor: Colors.white30,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
