import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/poll_container.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/models/make_decision.dart';
import 'package:savior/models/poll.dart';
import 'package:savior/models/problem.dart';

import '../../components/problem_container.dart';

class TrendScreen extends StatefulWidget {
  const TrendScreen({Key? key}) : super(key: key);

  @override
  _TrendScreenState createState() => _TrendScreenState();
}

class _TrendScreenState extends State<TrendScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppBloc cubit = AppBloc.get(context);
          List<PollModel> trendPolls = [];
          List<ProblemModel> trendProblems = [];
          if (cubit.trendPollsList.isNotEmpty) {
            trendPolls = cubit.trendPollsList;
          } 
          
          if (cubit.allProblemsList.isNotEmpty) {
            trendProblems = cubit.allProblemsList;
          }
          return Scaffold(
            appBar: TabBar(
              
              controller: _tabController,
              indicatorColor: AppColors.appMainColors,
              labelColor: AppColors.appMainColors,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Theme.of(context).textTheme.caption!.color,
              isScrollable: false,
              tabs: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.poll,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Tab(
                      text: "Polls",
                      iconMargin: const EdgeInsets.only(bottom: 0.0),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.puzzlePiece,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Tab(
                      text: "Problems",
                      iconMargin: const EdgeInsets.only(bottom: 0.0),
                    ),
                  ],
                ),
              ],
              onTap: (index) {
                cubit.changeTrendTabs(index);
              },
            ),
            body: Container(
              color: Color.fromARGB(255, 233, 231, 231),
              height: double.infinity,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ConditionalBuilder(
                    condition: state is! GetAllPollsDataLoadingState,
                    builder: (context) {
                      return ConditionalBuilder(
                        condition: trendPolls.isNotEmpty,
                        builder: (context) {
                          return PageView.builder(
                              itemCount: trendPolls.length,
                              itemBuilder: (context, index) {
                                return PollContainer(
                                  poll: trendPolls[index],
                                  state: state,
                                  pollWithMore: true,
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
                  ConditionalBuilder(
                    condition: state is! GetAllProblemsDataLoadingState,
                    builder: (context) {
                      return ConditionalBuilder(
                        condition: trendProblems.isNotEmpty,
                        builder: (context) {
                          return PageView.builder(
                              itemCount: trendProblems.length,
                              itemBuilder: (context, index) {
                                return ProblemContainer(
                                  problem: trendProblems[index],
                                  state: state,
                                  problemWithMore: true,
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
                ],
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
