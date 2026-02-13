import 'package:flutter/material.dart';
import 'package:spring_autumn/Model/goal_modal.dart';
import 'package:spring_autumn/Widgets/goal_card.dart';

class PlanPage extends StatefulWidget {
  final List<GoalModel> goals;
  const PlanPage({super.key, required this.goals});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  // This controller helps track the center item
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
