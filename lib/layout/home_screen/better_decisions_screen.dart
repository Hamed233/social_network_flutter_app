import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/state_widgets.dart';
import 'package:savior/models/poll.dart';

class BetterDecisionsScreen extends StatelessWidget {
  final PollModel poll;
  const BetterDecisionsScreen({Key? key, required this.poll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios)),
              title: Text("All Better Decisions"),
              centerTitle: true,
            ),
            body: Container(
              color: Colors.white,
              child: Column(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ConditionalBuilder(
                        condition: poll.notes!.isNotEmpty,
                        builder: (context) => ConditionalBuilder(
                              condition: poll.betterDecisionOption!.isNotEmpty,
                              builder: (context) => ConditionalBuilder(
                                condition: state
                                    is! GetBetterDecisionsOfPollLoadingState,
                                builder: (context) => ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        Padding(
                                          padding: const EdgeInsetsDirectional.only(top: 8, bottom: 8),
                                          child: betterChoiceBuilder(context, poll,
                                              poll.betterDecisionOption![index]),
                                        ),
                                    separatorBuilder: (context, index) =>
                                        Container(
                                          height: 0.2,
                                          color: Colors.grey,
                                        ),
                                    itemCount: poll.betterDecisionOption!.length),
                                fallback: (context) =>
                                    const CircularProgressIndicator(),
                              ),
                              fallback: (context) => const EmptyBoxWidget(),
                            ),
                        fallback: (context) => const NotesEmptyWidget()),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: addNoteOrDecisionBox(context, poll,
                      isNote: false, viewInsets: false),
                )
              ]),
            ),
          );
        });
  }
}
