import 'package:flutter/material.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/layout/home_screen/polls_screen.dart';

class DecisionsTab extends StatelessWidget {
  const DecisionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PollsScreen(forWhat: "person", pollWithMore: true,);
  }
}
