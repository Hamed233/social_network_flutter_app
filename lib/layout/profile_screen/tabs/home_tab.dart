import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/components/problem_container.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/models/poll.dart';
import 'package:savior/models/problem.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppBloc cubit = AppBloc.get(context);
          List<PollModel> polls = [];
          List<PollModel> supportedAndVotedPolls = [];
          List<ProblemModel> problems = [];
          if (cubit.personPollsList.isNotEmpty) {
            polls = cubit.personPollsList;
          }

          if (cubit.personProblemsList.isNotEmpty) {
            problems = cubit.personProblemsList;
          }

          if (cubit.reactionsPollListForCurrentUser.isNotEmpty) {
            supportedAndVotedPolls = cubit.reactionsPollListForCurrentUser;
          }

          

          return ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8.0),
                child: titleWithSpacerIcon(context, "Latest Polls (Decisions)",
                    Icons.arrow_forward_ios),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsetsDirectional.only(start: 8.0),
                width: double.infinity,
                height: 350,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: polls.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ConditionalBuilder(
                        condition:
                            state is! GetAllPollsDataForPersonLoadingState,
                        builder: (context) {
                          return ConditionalBuilder(
                            condition: polls.isNotEmpty,
                            builder: (context) {
                              return Container(
                                width: 360.0,
                                height: 300.0,
                                margin:
                                    const EdgeInsetsDirectional.only(end: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Color.fromARGB(
                                            255, 224, 224, 224))),
                                child: PollContainer(
                                  poll: polls[index],
                                  state: state,
                                  pollWithMore: false,
                                ),
                              );
                            },
                            fallback: (context) => Center(
                              child: Text("Sorry, Not found any Polls!"),
                            ),
                          );
                        },
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8.0),
                child: titleWithSpacerIcon(
                    context, "Latest Problems", Icons.arrow_forward_ios),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsetsDirectional.only(start: 8.0),
                width: double.infinity,
                height: 350,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: problems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ConditionalBuilder(
                        condition:
                            state is! GetAllProblemsForPersonDataLoadingState,
                        builder: (context) {
                          return ConditionalBuilder(
                            condition: problems.isNotEmpty,
                            builder: (context) {
                              return Container(
                                width: 360.0,
                                height: 300.0,
                                margin:
                                    const EdgeInsetsDirectional.only(end: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Color.fromARGB(
                                            255, 224, 224, 224))),
                                child: ProblemContainer(
                                  problem: problems[index],
                                  state: state,
                                  problemWithMore: false,
                                ),
                              );
                            },
                            fallback: (context) => Center(
                              child: Text("Sorry, Not found any Problems!"),
                            ),
                          );
                        },
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8.0),
                child: titleWithSpacerIcon(context, "Latest voted & supported Polls",
                    Icons.arrow_forward_ios),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsetsDirectional.only(start: 8.0),
                width: double.infinity,
                height: 350,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: supportedAndVotedPolls.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ConditionalBuilder(
                        condition:
                            state is! GetCurrentInfoAboutUserLoadingState,
                        builder: (context) {
                          return ConditionalBuilder(
                            condition: supportedAndVotedPolls.isNotEmpty,
                            builder: (context) {
                              return Container(
                                width: 360.0,
                                height: 300.0,
                                margin:
                                    const EdgeInsetsDirectional.only(end: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Color.fromARGB(
                                            255, 224, 224, 224))),
                                child: PollContainer(
                                  poll: supportedAndVotedPolls[index],
                                  state: state,
                                  pollWithMore: false,
                                ),
                              );
                            },
                            fallback: (context) => Center(
                              child: Text("Sorry, Not found any Polls!"),
                            ),
                          );
                        },
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }
}
