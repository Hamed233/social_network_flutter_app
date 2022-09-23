import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/components/problem_container.dart';
import 'package:savior/models/poll.dart';
import 'package:savior/models/problem.dart';

class ProblemsScreen extends StatelessWidget {
  String forWhat = "";
  bool problemWithMore = true;
  ProblemsScreen({Key? key, required this.forWhat, required this.problemWithMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppBloc cubit = AppBloc.get(context);
        List<ProblemModel> problems = [];
        if (forWhat == "person") {
          if (cubit.personProblemsList.isNotEmpty) {
            problems = cubit.personProblemsList;
          }
        } else if (forWhat == "reactions") {
          if (cubit.allProblemsList.isNotEmpty) {
            problems = cubit.allProblemsList;
          }
        } else {
          if (cubit.allProblemsList.isNotEmpty) {
            problems = cubit.allProblemsList;
          }
        }

        return ConditionalBuilder(
          condition: state is! GetAllProblemsDataLoadingState,
          builder: (context) {
            return ConditionalBuilder(
              condition: problems.isNotEmpty,
              builder: (context) {
                return PageView.builder(
                    itemCount: problems.length,
                    itemBuilder: (context, index) {
                      return ProblemContainer(
                        problem: problems[index],
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
        );
      },
    );
  }
}
