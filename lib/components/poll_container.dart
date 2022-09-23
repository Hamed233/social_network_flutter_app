import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/default_form_field.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/state_widgets.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/layout/home_screen/better_decisions_screen.dart';
import 'package:savior/layout/home_screen/notes_screen.dart';
import 'package:savior/models/better_decision.dart';
import 'package:savior/models/make_decision.dart';
import 'package:savior/models/poll.dart';

class PollContainer extends StatelessWidget {
  PollModel poll;
  AppStates state;
  bool pollWithMore;
  PollContainer({
    Key? key,
    required this.poll,
    required this.state,
    required this.pollWithMore,
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
                    _PollHeader(poll: poll, withMore: pollWithMore),
                    _ContentOfPoll(poll: poll),
                  ],
                ),
                _PollStats(poll: poll),
                _PollFooter(
                  poll: poll,
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

class _PollHeader extends StatelessWidget {
  final PollModel poll;
  final bool withMore;

  const _PollHeader({
    Key? key,
    required this.poll,
    required this.withMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        profileImageWithUserInfoComponent(
          context,
          poll.generalUserInfoModel.uId,
          profileImage: poll.generalUserInfoModel.image,
          datetimeOfPublish: poll.publishDateTime,
          fullName: poll.generalUserInfoModel.fullName,
          jobTitle: poll.generalUserInfoModel.jobTitle,
          withFollow: false,
          pollIsAnonymous: poll.isAnonymous,
        ),
        if (withMore)
          const SizedBox(
            width: 5,
          ),
        if (withMore)
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () => showCupertinoModalBottomSheet(
                expand: false,
                context: context,
                enableDrag: true,
                topRadius: const Radius.circular(0),
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return MorePostBottomSheet();
                }),
          ),
      ],
    );
  }
}

class _ContentOfPoll extends StatelessWidget {
  final PollModel? poll;
  const _ContentOfPoll({Key? key, this.poll}) : super(key: key);

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
            poll!.caption!,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          poll!.imageUrl != null
              ? const SizedBox.shrink()
              : const SizedBox(height: 6.0),
          poll!.imageUrl != null
              ? imageBuilder(poll!.imageUrl)
              : const SizedBox.shrink(),
          const SizedBox(height: 8.0),
          ConditionalBuilder(
            condition: poll!.decisionOption!.isNotEmpty,
            builder: (context) => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => _optionBuilder(
                    context, poll!, poll!.decisionOption![index]),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                itemCount: poll!.decisionOption!.length),
            fallback: (context) => Container(),
          ),
        ],
      ),
    );
  }
}

class _PollFooter extends StatelessWidget {
  final PollModel poll;
  final AppStates state;
  const _PollFooter({Key? key, required this.poll, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBloc cubit = AppBloc.get(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConditionalBuilder(
          condition: poll.betterDecisionOption!.isNotEmpty,
          builder: (context) => ConditionalBuilder(
            condition: state is! GetBetterDecisionsOfPollLoadingState,
            builder: (context) => Column(
              children: [
                const Divider(),
                Row(
                  children: [
                    Text(
                      "Top Better decisions",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.grey[800]),
                    ),
                    const Spacer(),
                    showAllBtn(context,
                        label: "show all",
                        icon: Icons.arrow_forward_ios,
                        onTap: () => navigateTo(
                            context, BetterDecisionsScreen(poll: poll))),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => betterChoiceBuilder(
                        context, poll, poll.betterDecisionOption![index]),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                    itemCount: poll.betterDecisionOption!.length > 2
                        ? 2
                        : poll.betterDecisionOption!.length),
              ],
            ),
            fallback: (context) => const CircularProgressIndicator(),
          ),
          fallback: (context) => Container(),
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
            showAllBtn(context,
                label: "show all",
                icon: Icons.arrow_forward_ios,
                onTap: () => navigateTo(context, NotesScreen(poll: poll))),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ConditionalBuilder(
            condition: poll.notes!.isNotEmpty,
            builder: (context) => ConditionalBuilder(
                  condition: state is! GetNotesOfPollLoadingState,
                  builder: (context) => Column(
                    children: [
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => mainBoxNote(
                              context, state, poll.notes![index],
                              model: poll, isProblem: false),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 8,
                              ),
                          itemCount:
                              poll.notes!.length > 2 ? 2 : poll.notes!.length),
                              const SizedBox(height: 7),
                      addNoteBoxEndOfNotes(context, cubit, poll),
                    ],
                  ),
                  fallback: (context) => const CircularProgressIndicator(),
                ),
            fallback: (context) => Column(
                  children: [
                    addNoteBoxEndOfNotes(context, cubit, poll),
                  ],
                )),
      ],
    );
  }
}

Widget _optionBuilder(context, PollModel poll, DecisionOption decisionOption) {
  Widget currentWidget = InkWell(
    onTap: () {
      if (poll.usersIdOfVoted!.isNotEmpty) {
        poll.usersIdOfVoted!.forEach((element) {
          if (!element.contains(userId)) {
            decisionOption.votes += 1;
            poll.usersIdOfVoted!.add(userId);
            AppBloc.get(context).updateVoteOption(poll, "vote");
          }
        });
      } else {
        decisionOption.votes += 1;
        poll.usersIdOfVoted!.add(userId);
        AppBloc.get(context).updateVoteOption(poll, "vote");
      }
    },
    onDoubleTap: () {
      if (poll.usersIdOfLove!.isNotEmpty) {
        poll.usersIdOfLove!.forEach((element) {
          if (!element.contains(userId)) {
            decisionOption.likes += 1;
            poll.usersIdOfLove!.add(userId);
            AppBloc.get(context).updateVoteOption(poll, "love");
          }
        });
      } else {
        decisionOption.likes += 1;
        poll.usersIdOfLove!.add(userId);
        AppBloc.get(context).updateVoteOption(poll, "love");
      }
    },
    child: Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(8),
              color: Color(0xffEEF0EB),
              border: Border.all(
                color: Color(0xffEEF0EB),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    decisionOption.caption!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                ),
                decisionOption.imageUrl != null
                    ? const SizedBox.shrink()
                    : const SizedBox(height: 6.0),
                decisionOption.imageUrl != null
                    ? imageBuilder(decisionOption.imageUrl)
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  if (poll.usersIdOfVoted!.isNotEmpty) {
    poll.usersIdOfVoted!.forEach((element) {
      if (element.contains(userId)) {
        currentWidget = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onDoubleTap: () {
                if (poll.usersIdOfLove!.isNotEmpty) {
                  poll.usersIdOfLove!.forEach((element) {
                    if (!element.contains(userId)) {
                      decisionOption.likes += 1;
                      poll.usersIdOfLove!.add(userId);
                      AppBloc.get(context).updateVoteOption(poll, "love");
                    }
                  });
                } else {
                  decisionOption.likes += 1;
                  poll.usersIdOfLove!.add(userId);
                  AppBloc.get(context).updateVoteOption(poll, "love");
                }
              },
              child: Container(
                width: double.infinity,
                key: UniqueKey(),
                child: LinearPercentIndicator(
                  barRadius: const Radius.circular(8),
                  padding: EdgeInsets.zero,
                  percent: double.parse(decisionOption.votes.toString()) /
                      double.parse(poll.usersIdOfVoted!.length.toString()),
                  animation: true,
                  animationDuration: 1000,
                  backgroundColor: const Color(0xffEEF0EB),
                  progressColor:
                      poll.decisionOption!.length == decisionOption.votes
                          ? AppColors.appMainColors
                          : AppColors.appMainColors,
                  center: Container(
                    padding: const EdgeInsetsDirectional.all(8),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                decisionOption.caption!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                                overflow: TextOverflow.clip,
                                maxLines: 8,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(5),
                                color: Color(0xffEEF0EB),
                                border: Border.all(
                                  color: Color(0xffEEF0EB),
                                ),
                              ),
                              padding: const EdgeInsetsDirectional.all(3),
                              child: Text(
                                '${(decisionOption.votes / poll.usersIdOfVoted!.length * 100).toStringAsFixed(1)}%',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        decisionOption.imageUrl != null
                            ? imageBuilder(decisionOption.imageUrl)
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    });
  }
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 200),
    child: Column(
      children: [
        currentWidget,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              // "♡"
              "♥️",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              decisionOption.likes.toString() + " love • ",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
            Icon(
              Icons.poll_outlined,
              size: 15,
            ),
            Text(
              decisionOption.votes.toString() + " votes",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    ),
  );
}

class _PollStats extends StatelessWidget {
  final PollModel poll;

  const _PollStats({
    Key? key,
    required this.poll,
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
            const Icon(
              FontAwesomeIcons.handsClapping,
              color: Colors.blue,
              size: 13.0,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              poll.usersIdOfSupportPoll!.length.toString() +
                  " support • ${poll.shares} shares",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              poll.notes!.length.toString() +
                  " note • " +
                  poll.betterDecisionOption!.length.toString() +
                  " better decisions",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            // _PollActionButton(
            //   widget: ReactionButton<Reaction>(
            //     onReactionChanged: (isChecked) {
            //       print('reaction changed $isChecked');
            //     },
            //     initialReaction: Reaction(
            //       icon: Icon(
            //         FontAwesomeIcons.thumbsUp,
            //         color: Colors.grey[800],
            //         size: 18,
            //       ),
            //       value: null,
            //     ),
            //     reactions: [
            //       Reaction(
            //         previewIcon: Padding(
            //             padding: const EdgeInsetsDirectional.all(8.0),
            //             child: Text(
            //               "👍",
            //               style: TextStyle(
            //                 fontSize: 19,
            //               ),
            //             )),
            //         icon: Text(
            //           "👍",
            //           style: TextStyle(
            //             fontSize: 19,
            //           ),
            //         ),
            //         value: null,
            //       ),
            //       Reaction(
            //         previewIcon: Padding(
            //           padding: const EdgeInsetsDirectional.all(8.0),
            //           child: Text(
            //             "👎",
            //             style: TextStyle(
            //               fontSize: 19,
            //             ),
            //           ),
            //         ),
            //         icon: Text(
            //           "👎",
            //           style: TextStyle(
            //             fontSize: 19,
            //           ),
            //         ),
            //         value: null,
            //       ),
            //       Reaction(
            //         previewIcon: Padding(
            //           padding: const EdgeInsetsDirectional.all(8.0),
            //           child: Text(
            //             "♥️",
            //             style: TextStyle(
            //               fontSize: 19,
            //             ),
            //           ),
            //         ),
            //         icon: Text(
            //           "♥️",
            //           style: TextStyle(
            //             fontSize: 19,
            //           ),
            //         ),
            //         value: null,
            //       ),
            //       Reaction(
            //         previewIcon: Padding(
            //           padding: const EdgeInsetsDirectional.all(8.0),
            //           child: Text(
            //             "😡",
            //             style: TextStyle(
            //               fontSize: 19,
            //             ),
            //           ),
            //         ),
            //         icon: Text(
            //           "😡",
            //           style: TextStyle(
            //             fontSize: 19,
            //           ),
            //         ),
            //         value: null,
            //       ),
            //     ],
            //   ),
            //   // label: 'like',
            //   onTap: () {},
            // ),
            _PollActionButton(
              widget: Icon(
                FontAwesomeIcons.handsClapping,
                color: poll.usersIdOfSupportPoll!.contains(userId)
                    ? Colors.blue
                    : Colors.grey[800],
                size: 19.0,
              ),
              // label: 'support',
              onTap: () {
                if (poll.usersIdOfSupportPoll!.contains(userId)) {
                  poll.usersIdOfSupportPoll!.remove(userId);
                  AppBloc.get(context)
                      .toggleSupportReact(poll, "remove", "support");
                } else {
                  poll.usersIdOfSupportPoll!.add(userId);
                  AppBloc.get(context)
                      .toggleSupportReact(poll, "add", "support");
                }
              },
            ),
            const SizedBox(
              width: 3,
            ),
            // _PollActionButton(
            //   widget: Icon(
            //     FontAwesomeIcons.notesMedical,
            //     color: Colors.grey[800],
            //     size: 19.0,
            //   ),
            //   // label: 'note',
            //   onTap: () {
            //     showCupertinoModalBottomSheet(
            //         expand: false,
            //         context: context,
            //         enableDrag: true,
            //         topRadius: const Radius.circular(0),
            //         backgroundColor: Colors.transparent,
            //         builder: (context) {
            //           return addNoteOrDecisionBox(context, poll, isNote: true);
            //         }).then((value) {});
            //   },
            // ),
            // const SizedBox(
            //   width: 3,
            // ),
            _PollActionButton(
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
                      return socialMediaBtnsBuilder(context, poll, false);
                    }).then((value) {});
              },
            ),
            const Spacer(),
            _PollActionButton(
              widget: Icon(
                FontAwesomeIcons.circlePlus,
                color: Colors.green,
                size: 16.0,
              ),
              label: 'better decision',
              labelColor: Colors.green,
              // label: 'anwser',
              onTap: () => showCupertinoModalBottomSheet(
                  expand: false,
                  context: context,
                  enableDrag: true,
                  topRadius: const Radius.circular(0),
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return addNoteOrDecisionBox(context, poll, isNote: false);
                  }).then((value) {}),
            ),
            const SizedBox(
              width: 3,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        // AddOpinionBox(),
      ],
    );
  }
}

class _PollActionButton extends StatelessWidget {
  final Widget widget;
  final String? label;
  final Color? labelColor;
  final Function() onTap;

  const _PollActionButton({
    Key? key,
    required this.widget,
    this.label,
    this.labelColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
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
