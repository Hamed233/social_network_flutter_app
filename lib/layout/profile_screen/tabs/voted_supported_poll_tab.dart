import 'package:flutter/material.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/layout/home_screen/polls_screen.dart';


class PollReactionsTab extends StatelessWidget {
  const PollReactionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PollsScreen(forWhat: "reactions", pollWithMore: true);
  }
}
