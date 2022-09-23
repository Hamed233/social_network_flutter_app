import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/models/poll.dart';
import 'package:savior/models/poll.dart';

class SinglePollScreen extends StatelessWidget {
  bool pollWithMore = true;
  SinglePollScreen({Key? key,  required this.pollWithMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppBloc cubit = AppBloc.get(context);
        List<PollModel> poll = [];
          if (cubit.singlePoll.isNotEmpty) {
            poll = cubit.singlePoll;
          }


        return Scaffold(
          appBar: AppBar(
            title: Text("Post"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ConditionalBuilder(
            condition: state is! GetSingleProblemDataLoadingState,
            builder: (context) {
              return ConditionalBuilder(
                condition: poll.isNotEmpty,
                builder: (context) {
                  return PageView.builder(
                      itemCount: poll.length,
                      itemBuilder: (context, index) {
                        return PollContainer(
                          poll: poll[index],
                          state: state,
                          pollWithMore: pollWithMore,
                        );
                      });
                },
                fallback: (context) => Center(
                  child: Text("empty"),
                ),
              );
            },
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
