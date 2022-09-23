import 'package:flutter/material.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/layout/home_screen/problems_screen.dart';


class ProblemsTab extends StatelessWidget {
  const ProblemsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProblemsScreen(forWhat: "person", problemWithMore: true);
  }
}
