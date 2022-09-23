import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/loadings/poll_post_skelton_loading.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/models/poll.dart';

class PollsScreen extends StatefulWidget {
  String forWhat = "";
  bool pollWithMore = true;
  PollsScreen({Key? key, required this.forWhat, required this.pollWithMore})
      : super(key: key);

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBloc cubit = AppBloc.get(context);
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<PollModel> polls = [];

        if (widget.forWhat == "person") {
          if (cubit.personPollsList.isNotEmpty) {
            polls = cubit.personPollsList;
          }
        } else if (widget.forWhat == "reactions") {
          if (cubit.reactionsPollListForCurrentUser.isNotEmpty) {
            polls = cubit.reactionsPollListForCurrentUser;
          }
        } else {
          if (polls.isNotEmpty) {
            polls = cubit.allPollsList;
          }
        }

        return ConditionalBuilder(
          condition: state is! GetAllPollsDataOfFollowingLoadingState ||
              state is! GetFollowingOfPersonLoadingState,
          builder: (context) {
            return ConditionalBuilder(
              condition: polls.isNotEmpty,
              builder: (context) {
                return RefreshIndicator(
                  color: AppColors.appMainColors,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    // loadPollsController();
                    cubit.getAllPolls();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: polls.length,
                            itemBuilder: (context, index) {
                              if (index == (polls.length - 1) &&
                                  !cubit.pollsOfSameCountryLoaded) {
                                cubit.loadMorePollsFromSameCountry();
                              } else if (index ==
                                      (polls.length - 1) &&
                                  !cubit.pollsOfDifferentCountryLoaded) {
                                cubit.loadMorePollsFromDifferentCountry();
                              }
                              return PollContainer(
                                poll: polls[index],
                                state: state,
                                pollWithMore: widget.pollWithMore,
                              );
                            }),
                      ),

                      // when the _loadMore function is running
                      if (state is GetAllPollsDataOfSameCountryLoadingState ||
                          state
                              is StartedLoadMorePollsFromDifferentCountryState)
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                );
              },
              fallback: (context) => Center(
                child: Text("empty"),
              ),
            );
          },
          fallback: (context) => const PollPostSkeletonLoading(),
        );
      },
    );
  }

  // Future loadPollsController() async {
  //   AppBloc cubit = AppBloc.get(context);
  //   cubit.loadFollowingPollsAsFirst().then((value) {
  //     print(cubit.followingPollsList);
  //     print(polls.length);
  //     if (cubit.followingPollsList.isEmpty) {
  //       cubit.loadMorePollsFromSameCountry().then((value) {
  //         print(polls.length);
  //         if (cubit.pollsOfSameCountry.isEmpty) {
  //           cubit.loadMorePollsFromDifferentCountry();
  //           print(polls.length);
  //         }
  //       });
  //     }
  //   });
  // }
}
