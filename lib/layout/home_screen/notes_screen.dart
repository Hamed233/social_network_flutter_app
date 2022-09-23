import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/state_widgets.dart';
import 'package:savior/models/poll.dart';

class NotesScreen extends StatelessWidget {
  final PollModel poll;
  const NotesScreen({Key? key, required this.poll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          print(poll.caption);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios)),
              title: Text("All Notes"),
              centerTitle: true,
            ),
            body: Container(
              child: Column(
                children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ConditionalBuilder(
                        condition: poll.notes!.isNotEmpty,
                        builder: (context) => ConditionalBuilder(
                              condition: state is! GetNotesOfPollLoadingState,
                              builder: (context) => ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      noteBoxBuilder(context, state, poll.notes![index], poll),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 8,
                                      ),
                                  itemCount: poll.notes!.length),
                              fallback: (context) =>
                                  const CircularProgressIndicator(),
                            ),
                        fallback: (context) => const NotesEmptyWidget()),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: addNoteOrDecisionBox(context, poll, isNote: true, viewInsets: false),
                )
              ]),
            ),
          );
        });
  }
}
