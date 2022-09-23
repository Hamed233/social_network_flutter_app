import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/components/problem_container.dart';
import 'package:savior/models/poll.dart';
import 'package:savior/models/problem.dart';

class SingleProblemsScreen extends StatelessWidget {
  bool problemWithMore = true;
  SingleProblemsScreen({Key? key,  required this.problemWithMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppBloc cubit = AppBloc.get(context);
        List<ProblemModel> problem = [];
          if (cubit.singleProblem.isNotEmpty) {
            problem = cubit.singleProblem;
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
                condition: problem.isNotEmpty,
                builder: (context) {
                  return PageView.builder(
                      itemCount: problem.length,
                      itemBuilder: (context, index) {
                        return ProblemContainer(
                          problem: problem[index],
                          state: state,
                          problemWithMore: problemWithMore,
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
