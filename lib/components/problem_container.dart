import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/state_widgets.dart';
import 'package:savior/layout/single_screens/add_solution_screen.dart';
import 'package:savior/models/problem.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/models/solution.dart';

class ProblemContainer extends StatelessWidget {
  ProblemModel problem;
  AppStates state;
  bool problemWithMore;
  ProblemContainer({
    Key? key,
    required this.problem,
    required this.state,
    required this.problemWithMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProblemHeader(
                        problem: problem, problemWithMore: problemWithMore),
                    _ContentOfProblem(problem: problem),
                  ],
                ),
                _ProblemStats(problem: problem),
                _ProblemFooter(
                  problem: problem,
                  state: state,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProblemHeader extends StatelessWidget {
  final ProblemModel problem;
  final bool problemWithMore;

  const _ProblemHeader({
    Key? key,
    required this.problem,
    required this.problemWithMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        profileImageWithUserInfoComponent(
          context,
          problem.generalUserInfoModel!.uId,
          profileImage: problem.generalUserInfoModel!.image,
          datetimeOfPublish: problem.publishDateTime,
          fullName: problem.generalUserInfoModel!.fullName,
          jobTitle: problem.generalUserInfoModel!.jobTitle,
          withFollow: false,
          pollIsAnonymous: problem.isAnonymous,
        ),
        if (problemWithMore)
          const SizedBox(
            width: 5,
          ),
        if (problemWithMore)
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () => print('More'),
          ),
      ],
    );
  }
}

class _ContentOfProblem extends StatelessWidget {
  final ProblemModel? problem;
  const _ContentOfProblem({Key? key, this.problem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15.0),
          Text(
            problem!.caption!,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          problem!.imageUrl!.isNotEmpty
              ? const SizedBox.shrink()
              : const SizedBox(height: 6.0),
          problem!.imageUrl!.isNotEmpty
              ? imageBuilder(problem!.imageUrl)
              : const SizedBox.shrink(),
          const SizedBox(height: 8.0),
          // ConditionalBuilder(
          //   condition: problem!.peopleSolutions!.isNotEmpty,
          //   builder: (context) => ListView.separated(
          //       shrinkWrap: true,
          //       itemBuilder: (context, index) => _optionBuilder(
          //           context, problem!, problem!.decisionOption![index]),
          //       separatorBuilder: (context, index) => const SizedBox(
          //             height: 8,
          //           ),
          //       itemCount: poll!.decisionOption!.length),
          //   fallback: (context) => Container(),
          // ),
        ],
      ),
    );
  }
}

class _ProblemFooter extends StatelessWidget {
  final ProblemModel problem;
  final AppStates state;
  const _ProblemFooter({Key? key, required this.problem, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Row(
          children: [
            Text(
              "Top Solutions",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.grey[800]),
            ),
            const Spacer(),
            // showAllBtn(context,
            //     label: "show all", icon: Icons.arrow_forward_ios, onTap: () => navigateTo(context, BetterDecisionsScreen(poll: poll))),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ConditionalBuilder(
          condition: problem.peopleSolutions!.isNotEmpty,
          builder: (context) => ConditionalBuilder(
            condition: state is! GetAllProblemsDataLoadingState,
            builder: (context) => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => solutionBuilder(
                    context, problem, problem.peopleSolutions![index]),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                itemCount: problem.peopleSolutions!.length > 2
                    ? 2
                    : problem.peopleSolutions!.length),
            fallback: (context) => const CircularProgressIndicator(),
          ),
          fallback: (context) => const EmptyBoxWidget(),
        ),
        const Divider(),
        Row(
          children: [
            Text(
              "Top Notes",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.grey[800]),
            ),
            const Spacer(),
            // showAllBtn(context,
            //     label: "show all", icon: Icons.arrow_forward_ios, onTap: () => navigateTo(context, NotesScreen(poll: poll))),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ConditionalBuilder(
            condition: problem.notes!.isNotEmpty,
            builder: (context) => ConditionalBuilder(
                  condition: state is! GetNotesOfProblemLoadingState,
                  builder: (context) => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => mainBoxNote(
                          context, state, problem.notes![index],
                          model: problem, isProblem: true),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                      itemCount: problem.notes!.length > 2
                          ? 2
                          : problem.notes!.length),
                  fallback: (context) => const CircularProgressIndicator(),
                ),
            fallback: (context) => const NotesEmptyWidget()),
      ],
    );
  }
}

class SolutionStats extends StatelessWidget {
  final SolutionModel solution;
  final ProblemModel problem;

  const SolutionStats({
    Key? key,
    required this.solution,
    required this.problem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 217, 4),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Color.fromARGB(182, 228, 228, 228),
                ),
              ),
              child: Icon(
                FontAwesomeIcons.one,
                color: Colors.white,
                size: 13.0,
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              solution.usersIdOfSupportSolution!.length.toString() +
                  " support ",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Color.fromARGB(182, 228, 228, 228),
                ),
              ),
              child: Icon(
                FontAwesomeIcons.zero,
                color: Colors.white,
                size: 13.0,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              solution.usersIdOfInSupportSolution!.length.toString() +
                  " unsupport",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              "200 shares",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            _ProblemActionButton(
              bg: solution.usersIdOfSupportSolution!.contains(userId)
                  ? Color.fromARGB(255, 240, 217, 4)
                  : Colors.white,
              widget: Icon(
                FontAwesomeIcons.one,
                color: solution.usersIdOfSupportSolution!.contains(userId)
                    ? Colors.white
                    : Color.fromARGB(255, 240, 217, 4),
                size: 19.0,
              ),
              onTap: () {
                if (solution.usersIdOfSupportSolution!.contains(userId)) {
                  solution.usersIdOfSupportSolution!.remove(userId);
                  AppBloc.get(context)
                      .toggleSupportAndUnsupportSolutionReact(problem, false);
                } else {
                  solution.usersIdOfSupportSolution!.add(userId);
                  solution.usersIdOfInSupportSolution!.remove(userId);
                  AppBloc.get(context)
                      .toggleSupportAndUnsupportSolutionReact(problem, true);
                }
              },
            ),
            const SizedBox(
              width: 3,
            ),
            _ProblemActionButton(
              bg: solution.usersIdOfInSupportSolution!.contains(userId)
                  ? Colors.black
                  : Colors.white,
              widget: Icon(
                FontAwesomeIcons.zero,
                color: solution.usersIdOfInSupportSolution!.contains(userId)
                    ? Colors.white
                    : Colors.black,
                size: 19.0,
              ),
              onTap: () {
                if (solution.usersIdOfInSupportSolution!.contains(userId)) {
                  solution.usersIdOfInSupportSolution!.remove(userId);
                  AppBloc.get(context)
                      .toggleSupportAndUnsupportSolutionReact(problem, false);
                } else {
                  solution.usersIdOfSupportSolution!.remove(userId);
                  solution.usersIdOfInSupportSolution!.add(userId);
                  AppBloc.get(context)
                      .toggleSupportAndUnsupportSolutionReact(problem, true);
                }
              },
            ),
            const SizedBox(
              width: 3,
            ),
            _ProblemActionButton(
              widget: Icon(
                Icons.share,
                color: Colors.grey[800],
                size: 19.0,
              ),
              // label: 'share',
              onTap: () {
                showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    enableDrag: true,
                    topRadius: const Radius.circular(0),
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return socialMediaBtnsBuilder(context, solution, true);
                    }).then((value) {});
              },
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class _ProblemStats extends StatelessWidget {
  final ProblemModel problem;

  const _ProblemStats({
    Key? key,
    required this.problem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Icon(
              FontAwesomeIcons.faceSadTear,
              color: Colors.blue,
              size: 13.0,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              problem.peopleSuffer!.length.toString() + " suffer • 44 shares",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              problem.notes!.length.toString() +
                  " note • " +
                  problem.peopleSolutions!.length.toString() +
                  " solutions",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            _ProblemActionButton(
              widget: Icon(
                FontAwesomeIcons.faceSadTear,
                color: problem.peopleSuffer!.contains(userId)
                    ? Colors.blue
                    : Colors.grey[800],
                size: 19.0,
              ),
              onTap: () {
                if (problem.peopleSuffer!.contains(userId)) {
                  problem.peopleSuffer!.remove(userId);
                  AppBloc.get(context).toggleSufferReact(problem, "remove");
                } else {
                  problem.peopleSuffer!.add(userId);
                  AppBloc.get(context).toggleSufferReact(problem, "add");
                }
              },
            ),
            const SizedBox(
              width: 3,
            ),
            _ProblemActionButton(
              widget: Icon(
                FontAwesomeIcons.notesMedical,
                color: Colors.grey[800],
                size: 19.0,
              ),
              // label: 'note',
              onTap: () {
                showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    enableDrag: true,
                    topRadius: const Radius.circular(0),
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return addProblemNoteBox(context, problem.id);
                    }).then((value) {});
              },
            ),
            const SizedBox(
              width: 3,
            ),
            _ProblemActionButton(
              widget: Icon(
                Icons.share,
                color: Colors.grey[800],
                size: 19.0,
              ),
              // label: 'share',
              onTap: () {
                showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    enableDrag: true,
                    topRadius: const Radius.circular(0),
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return socialMediaBtnsBuilder(context, problem, true);
                    }).then((value) {});
              },
            ),
            const Spacer(),
            _ProblemActionButton(
                widget: Icon(
                  FontAwesomeIcons.circlePlus,
                  color: Colors.green,
                  size: 16.0,
                ),
                label: 'add solution',
                labelColor: Colors.green,
                // label: 'anwser',
                onTap: () =>
                    navigateTo(context, AddSolutionScreen(problem: problem))),
            const SizedBox(
              width: 3,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class _ProblemActionButton extends StatelessWidget {
  final Widget widget;
  final String? label;
  final Color? labelColor;
  final Color? bg;
  final Function() onTap;

  const _ProblemActionButton({
    Key? key,
    required this.widget,
    this.label,
    this.labelColor,
    this.bg,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: bg ?? Colors.white,
          border: Border.all(
            color: Color.fromARGB(182, 228, 228, 228),
          ),
        ),
        // height: 25.0,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              widget,
              const SizedBox(
                width: 3,
              ),
              if (label != null)
                Text(
                  label!,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 16, color: labelColor ?? Colors.grey[800]),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
