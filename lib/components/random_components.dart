import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/confirmation_out_sheet.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/default_form_field.dart';
import 'package:savior/components/problem_container.dart';
import 'package:savior/components/loadings/image_with_name_skelton_loading.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/layout/add_posts_screens/add_poll_post_screen.dart';
import 'package:savior/layout/add_posts_screens/add_problem_screen.dart';
import 'package:savior/layout/profile_screen/person_profile_screen.dart';
import 'package:savior/models/better_decision.dart';
import 'package:savior/models/note.dart';
import 'package:savior/models/poll.dart';
import 'package:savior/models/problem.dart';
import 'package:savior/models/solution.dart';

import 'package:savior/models/user.dart';
import 'package:social_share/social_share.dart';
import 'package:timeago/timeago.dart' as timeago;

// ---------- Sheets ------------------
showConfimationOutBottomSheet(
  BuildContext context,
) {
  showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ConfimationOutSheet();
      }).then((value) {});
}

// ----------- Navigate component ----------------

navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

// ----------- Navigate And finish component ----------------
navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

// ------------ Default Button ------------
Widget defaultTextButton({
  required Function()? function,
  required String text,
  IconData? icon,
  Color? color,
}) =>
    TextButton(
      onPressed: function,
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
                color: color ?? AppColors.appMainColors, fontSize: 15),
          ),
          SizedBox(
            width: 1,
          ),
          Icon(
            icon,
            color: AppColors.appMainColors,
            size: 15,
          ),
        ],
      ),
    );

// ------------ Custom SnackBar ---------------------

showCustomSnackBar(BuildContext context,
    {required String content,
    required Color bgColor,
    required Color textColor}) {
  final snackBar = SnackBar(
    content: Text(
      content,
      style: TextStyle(
        color: textColor,
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: bgColor.withOpacity(0.7),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// ------------ Profile Image With User Info Component (For post) ---------------------

Widget profileImageWithUserInfoComponent(context, usrId,
    {profileImage,
    datetimeOfPublish,
    fullName,
    jobTitle,
    withFollow,
    pollIsAnonymous = false}) {
  final DateTime timeAgoOfPoll = DateTime.parse(datetimeOfPublish);
  return Expanded(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            if (!pollIsAnonymous) {
              // Get Profile Info
              // AppBloc.get(context).getPersonProfileData(id: usrId);

              navigateTo(
                  context,
                  PersonProfileScreen(
                    usrId: usrId,
                  ));
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: profileImage != "" && !pollIsAnonymous
                    ? DecorationImage(
                        image: NetworkImage(profileImage), fit: BoxFit.cover)
                    : DecorationImage(
                        image: AssetImage("assets/images/avatar.png"),
                        fit: BoxFit.cover)),
          ),
        ),

        const SizedBox(width: 8.0),
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      pollIsAnonymous ? "Anonymous" : fullName!,
                      style: TextStyle(
                        height: pollIsAnonymous ? 1 : 1.4,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    if (!pollIsAnonymous)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.appMainColors,
                        size: 16.0,
                      ),
                  ],
                ),
                if (!pollIsAnonymous && jobTitle != '')
                  const SizedBox(
                    height: 3,
                  ),
                if (!pollIsAnonymous && jobTitle != '')
                  Container(
                    width: MediaQuery.of(context).size.width * .65,
                    child: Text(
                      jobTitle!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .65,
                  child: Text(
                    timeago.format(timeAgoOfPoll).toString(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        // if (withFollow) Spacer(),
        if (withFollow && !pollIsAnonymous)
          TextButton(onPressed: () {}, child: Text("follow"))
      ],
    ),
  );
}

// ------------ Profile Image With Username Component (for followers & following) ---------------------

Widget profileImageWithUsernameComponent(context, cubit, usrId, isFollow,
    {profileImage, fullName}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      InkWell(
        onTap: () async {
          navigateTo(
              context,
              PersonProfileScreen(
                usrId: usrId,
              ));
          // Get Profile Info
          // await AppBloc.get(context).getPersonProfileData(id: usrId);
        },
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: profileImage != ""
                  ? DecorationImage(
                      image: NetworkImage(profileImage), fit: BoxFit.cover)
                  : DecorationImage(
                      image: AssetImage("assets/images/avatar.png"),
                      fit: BoxFit.cover)),
        ),
      ),
      const SizedBox(width: 8.0),
      Expanded(
        child: Container(
          child: Row(
            children: [
              Text(
                fullName!,
                style: Theme.of(context).textTheme.headline4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Icon(
                Icons.check_circle,
                color: AppColors.appMainColors,
                size: 16.0,
              ),
            ],
          ),
        ),
      ),
      if (usrId != userId)
        btnBuilder(
          context,
          cubit,
          isFollow,
          usrId: usrId,
          fullName: fullName!,
          image: profileImage,
          height: 30.0,
          followId: cubit.currentVisitedProfileData.id,
          followingDocId: cubit.currentVisitedProfileData.followingDocId,
        ),
    ],
  );
}

// btn builder
Widget btnBuilder(context, AppBloc cubit, isFollow,
    {usrId,
    followId,
    followingDocId,
    fullName,
    image,
    jobTitle,
    height,
    width}) {
  return Container(
    width: isFollow ? 112 : 80,
    height: height ?? 35.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.0),
      color: isFollow ? Colors.white : AppColors.appMainColors,
      border: Border.all(
        color: AppColors.appMainColors!,
        width: .8,
      ),
    ),
    child: Center(
      child: MaterialButton(
        onPressed: () {
          if (isFollow) {
            showCupertinoModalBottomSheet(
                expand: false,
                context: context,
                enableDrag: true,
                topRadius: const Radius.circular(0),
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return unfollowBottomSheet(
                      context, usrId, followId, followingDocId);
                });
          } else {
            cubit.addPersonToFollowingThenFollowers(
                usrId: usrId, username: fullName!, image: image);
          }
        },
        child: Row(
          children: [
            Text(
              isFollow ? "following" : "follow",
              style: TextStyle(
                  color: isFollow ? AppColors.appMainColors : Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal),
            ),
            if (isFollow!)
              Icon(
                Icons.arrow_drop_down_sharp,
                color: AppColors.appMainColors,
                size: 16,
              )
          ],
        ),
      ),
    ),
  );
}

Widget unfollowBottomSheet(context, usrId, followId, followingDocId) {
  return Material(
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FontAwesomeIcons.minus,
            color: Color.fromARGB(255, 212, 212, 212),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              AppBloc.get(context)
                  .unfollowPerson(usrId, followId, followingDocId)
                  .then((value) {
                Navigator.pop(context);
              });
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10),
                border: Border.all(color: Colors.grey, width: .2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.remove_circle,
                      size: 22,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      "Unfollow",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Color.fromARGB(255, 24, 23, 23),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

class MorePostBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding:
            const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.minus,
              color: Color.fromARGB(255, 212, 212, 212),
            ),
            const SizedBox(
              height: 10,
            ),
            _itemBuilder(context,
                icon: Icons.bookmark,
                iconColor: Colors.black,
                title: "bookmark"),
            const SizedBox(
              height: 10,
            ),
            _itemBuilder(context,
                icon: Icons.report,
                iconColor: Colors.red,
                title: "report",
                titleColor: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(context, {icon, iconColor, title, titleColor, onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          border: Border.all(color: Colors.grey, width: .2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: iconColor,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: titleColor ?? Color.fromARGB(255, 24, 23, 23),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- More bottom sheet ---

// ------------ Note box Widget ---------------------
Widget mainBoxNote(context, AppStates state, NoteModel note,
    {model, isProblem = false, String? noteId, isReplay = false}) {
  return Column(
    children: [
      noteBoxBuilder(context, state, note, model,
          noteId: noteId, isReplay: isReplay, isProblem: isProblem),
      replayBox(context, state, model, note),
    ],
  );
}

Widget noteBoxBuilder(context, AppStates state, NoteModel note, model,
    {String? noteId, isProblem = false, isReplay = false}) {
  final DateTime timeAgoOfNote = DateTime.parse(note.publishDateTime!);
  return Container(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                // Get Profile Info
                await AppBloc.get(context)
                    .getPersonProfileData(id: model.generalUserInfoModel!.uId!)
                    .then((value) {
                  navigateTo(
                      context,
                      PersonProfileScreen(
                        usrId: model.generalUserInfoModel!.uId!,
                      ));
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image:
                        note.author!.image != null && note.author!.image != ''
                            ? DecorationImage(
                                image: NetworkImage(note.author!.image!),
                                fit: BoxFit.cover)
                            : DecorationImage(
                                image: AssetImage("assets/images/avatar.png"),
                                fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsetsDirectional.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        color: Colors.grey[100],
                        // border: Border.all(
                        //   color: Color.fromARGB(255, 248, 241, 175),
                        // ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(note.author!.fullName!,
                                  style: TextStyle(
                                      height: 1.4,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: AppColors.appMainColors,
                                size: 16.0,
                              ),
                              const Spacer(),
                              Text(
                                timeago.format(timeAgoOfNote).toString(),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            note.note!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 32,
                          child: TextButton(
                            onPressed: () {
                              if (note.usersIdOfSupportNote!.contains(userId)) {
                                note.usersIdOfSupportNote!.remove(userId);

                                AppBloc.get(context).toggleSupportReactOnNote(
                                    model, note, "remove",
                                    isProblem: isProblem);
                              } else {
                                note.usersIdOfSupportNote!.add(userId);
                                AppBloc.get(context).toggleSupportReactOnNote(
                                    model, note, "add",
                                    isProblem: isProblem);
                              }
                            },
                            child: Row(
                              children: [
                                // ReactionButton<Reaction>(
                                //   onReactionChanged: (isChecked) {
                                //     print('reaction changed $isChecked');
                                //   },
                                //   initialReaction: Reaction(
                                //     icon: Icon(
                                //       FontAwesomeIcons.thumbsUp,
                                //       color: Colors.grey[800],
                                //       size: 18,
                                //     ),
                                //     value: null,
                                //   ),
                                //   reactions: [
                                //     Reaction(
                                //       previewIcon: Padding(
                                //           padding:
                                //               const EdgeInsetsDirectional.all(8.0),
                                //           child: Text(
                                //             "👍",
                                //             style: TextStyle(
                                //               fontSize: 19,
                                //             ),
                                //           )),
                                //       icon: Text(
                                //         "👍",
                                //         style: TextStyle(
                                //           fontSize: 19,
                                //         ),
                                //       ),
                                //       value: null,
                                //     ),
                                //     Reaction(
                                //       previewIcon: Padding(
                                //         padding:
                                //             const EdgeInsetsDirectional.all(8.0),
                                //         child: Text(
                                //           "👎",
                                //           style: TextStyle(
                                //             fontSize: 19,
                                //           ),
                                //         ),
                                //       ),
                                //       icon: Text(
                                //         "👎",
                                //         style: TextStyle(
                                //           fontSize: 19,
                                //         ),
                                //       ),
                                //       value: null,
                                //     ),
                                //     Reaction(
                                //       previewIcon: Padding(
                                //         padding:
                                //             const EdgeInsetsDirectional.all(8.0),
                                //         child: Text(
                                //           "♥️",
                                //           style: TextStyle(
                                //             fontSize: 19,
                                //           ),
                                //         ),
                                //       ),
                                //       icon: Text(
                                //         "♥️",
                                //         style: TextStyle(
                                //           fontSize: 19,
                                //         ),
                                //       ),
                                //       value: null,
                                //     ),
                                //     Reaction(
                                //       previewIcon: Padding(
                                //         padding:
                                //             const EdgeInsetsDirectional.all(8.0),
                                //         child: Text(
                                //           "😡",
                                //           style: TextStyle(
                                //             fontSize: 19,
                                //           ),
                                //         ),
                                //       ),
                                //       icon: Text(
                                //         "😡",
                                //         style: TextStyle(
                                //           fontSize: 19,
                                //         ),
                                //       ),
                                //       value: null,
                                //     ),
                                //   ],
                                // ),
                                Icon(
                                  FontAwesomeIcons.handsClapping,
                                  color: note.usersIdOfSupportNote!
                                          .contains(userId)
                                      ? Colors.blue
                                      : Colors.grey[800],
                                  size: 16.0,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "support",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          color: note.usersIdOfSupportNote!
                                                  .contains(userId)
                                              ? Colors.blue
                                              : Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 32,
                          child: TextButton(
                            onPressed: () {
                              showCupertinoModalBottomSheet(
                                  expand: false,
                                  context: context,
                                  enableDrag: true,
                                  topRadius: const Radius.circular(0),
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return isProblem
                                        ? addProblemNoteBox(context, model,
                                            isReplay: true,
                                            noteId: isReplay ? noteId : note.id,
                                            nestedNoteId:
                                                isReplay ? note.id : null)
                                        : addNoteOrDecisionBox(context, model,
                                            isNote: true,
                                            isReplay: true,
                                            noteId: isReplay ? noteId : note.id,
                                            nestedNoteId:
                                                isReplay ? note.id : null);
                                  }).then((value) {});
                            },
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.reply,
                                  color: Colors.grey[800],
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "replay",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 6.0),
                          child: Text(
                            note.usersIdOfSupportNote!.length.toString() +
                                " support •" +
                                note.replais!.length.toString() +
                                " replies",
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget replayBox(context, AppStates state, model, NoteModel note) {
  return Column(
    children: [
      const SizedBox(
        height: 10,
      ),
      Container(
        margin: const EdgeInsetsDirectional.only(start: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.replais!.isNotEmpty && note.showReplaies)
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => noteBoxBuilder(
                      context, state, note.replais![index], model,
                      noteId: note.id!, isReplay: true),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                  itemCount: note.replais!.length),
            if (note.replais!.isNotEmpty && !note.showReplaies)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 37, top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    // note.showReplaies = !note.showReplaies;
                    // AppBloc.get(context).toggleNoteReplaies();
                  },
                  child: Container(
                    child: Text(
                      "Show replaies...",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Color.fromARGB(255, 16, 16, 17),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            if (note.replais!.isNotEmpty && !note.showReplaies)
              const SizedBox(
                height: 10,
              ),
            if (note.showReplaies)
              GestureDetector(
                onTap: () {
                  // note.showReplaies = !note.showReplaies;
                  // AppBloc.get(context).toggleNoteReplaies();
                },
                child: Container(
                  margin: const EdgeInsetsDirectional.only(start: 60),
                  child: Text(
                    "Show less...",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Color.fromARGB(255, 16, 16, 17),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

// ------------ Label With Spacer Button Widget ---------------------

Widget labelWithBtn(context,
        {label,
        labelSize,
        labelColor,
        icon,
        iconColor,
        iconSize,
        spaceBetween,
        Function()? onTap}) =>
    Container(
      height: 32,
      child: TextButton(
        onPressed: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize ?? 14,
              color: iconColor ?? Colors.grey[600],
            ),
            SizedBox(
              width: spaceBetween ?? 1,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: labelColor ?? Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontSize: labelSize ?? 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );

// ------------ Show All Button Widget ---------------------

Widget showAllBtn(context,
        {label,
        labelSize,
        labelColor,
        icon,
        iconColor,
        iconSize,
        spaceBetween,
        Function()? onTap}) =>
    Container(
      height: 32,
      child: TextButton(
        onPressed: onTap,
        child: Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: labelColor ?? Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontSize: labelSize ?? 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
            SizedBox(
              width: spaceBetween ?? 1,
            ),
            Icon(
              icon,
              size: iconSize ?? 14,
              color: iconColor ?? Colors.grey[600],
            ),
          ],
        ),
      ),
    );

// ------------ Title With Spacer Icon Widget ---------------------

Widget titleWithSpacerIcon(context, title, icon) {
  return Row(
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.headline3,
      ),
      Spacer(),
      IconButton(
          onPressed: () {},
          icon: Icon(
            icon,
            size: 20,
          )),
    ],
  );
}

// ------------ Widget to make login and register builder ---------------------

Widget loginAndRegisterWithBuilder(context, state, websiteSvg, loginWith) {
  return Expanded(
    child: InkWell(
      onTap: () {
        // if (loginWith == "fb") {
        //   AppCubit.get(context).loginWithFB();
        // } else if (loginWith == "google") {
        //   AppCubit.get(context).googleLogin();
        // } else if (loginWith == "twitter") {
        //   AppCubit.get(context).loginWithTwitter();
        // }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          border: Border.all(
            color: Color.fromARGB(255, 216, 216, 216),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 10.0,
            bottom: 10.0,
          ),
          child: state is! SignInWithTwitterLoading ||
                  state is! SignInWithFBLoading ||
                  state is! SignInWithGoogleLoading
              ? SvgPicture.asset(
                  websiteSvg,
                  width: 30,
                  height: 30,
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    ),
  );
}

// Add Problem note
addProblemNoteBox(context, problem,
    {viewInsets = true, isReplay = false, noteId, nestedNoteId}) {
  TextEditingController textFieldController = TextEditingController();
  return Material(
      child: Padding(
    padding: EdgeInsets.only(
        bottom: viewInsets ? MediaQuery.of(context).viewInsets.bottom : 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 10, top: 10, bottom: 10),
            child: DefaultFormField(
              autoFocus: true,
              type: TextInputType.text,
              controller: textFieldController,
              focusedColorBorder: HexColor("#ced4da"),
              labelColor: Colors.grey,
              borderWidth: 50.0,
              hintText: isReplay
                  ? "write replay on note here..."
                  : "add some notes here...",
              prefixColorIcon: Colors.grey,
              borderColor: HexColor("#ced4da"),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 10, top: 10, bottom: 10),
          child: defaultTextButton(
              function: () {
                if (textFieldController.text.isNotEmpty) {
                  if (isReplay) {
                    // AppBloc.get(context)
                    //     .addReplayNoteToDBTable(
                    //         context, textFieldController.text, pollId, noteId,
                    //         nestedNoteId: nestedNoteId)
                    //     .then((value) {
                    //   // if(!viewInsets) {
                    //   //   Navigator.of(context).pop();
                    //   // }
                    // });
                  } else {
                    AppBloc.get(context)
                        .addProblemNoteToDBTable(
                            context, textFieldController.text, problem)
                        .then((value) {
                      // if(!viewInsets) {
                      //   Navigator.of(context).pop();
                      // }
                    });
                  }
                }
              },
              text: "add"),
        ),
      ],
    ),
  ));
}

// ------------ Widget to make input for add note or decision ---------------------
addNoteOrDecisionBox(context, PollModel poll,
    {isNote = false,
    viewInsets = true,
    isReplay = false,
    noteId,
    nestedNoteId}) {
  TextEditingController textFieldController = TextEditingController();
  return Material(
      child: Padding(
    padding: EdgeInsets.only(
        bottom: viewInsets ? MediaQuery.of(context).viewInsets.bottom : 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 10, top: 10, bottom: 10),
            child: DefaultFormField(
              autoFocus: true,
              type: TextInputType.text,
              controller: textFieldController,
              focusedColorBorder: HexColor("#ced4da"),
              labelColor: Colors.grey,
              borderWidth: 50.0,
              hintText: isNote
                  ? isReplay
                      ? "write replay on note here..."
                      : "add some notes here..."
                  : "write better decision here..",
              prefixColorIcon: Colors.grey,
              borderColor: HexColor("#ced4da"),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 10, top: 10, bottom: 10),
          child: defaultTextButton(
              function: () {
                if (textFieldController.text.isNotEmpty) {
                  if (isNote) {
                    if (isReplay) {
                      // AppBloc.get(context)
                      //     .addReplayNoteToDBTable(
                      //         context, textFieldController.text, pollId, noteId,
                      //         nestedNoteId: nestedNoteId)
                      //     .then((value) {
                      //   // if(!viewInsets) {
                      //   //   Navigator.of(context).pop();
                      //   // }
                      // });
                    } else {
                      AppBloc.get(context)
                          .addPollNoteToDBTable(
                              context, textFieldController.text, poll)
                          .then((value) {
                        // if(!viewInsets) {
                        //   Navigator.of(context).pop();
                        // }
                      });
                    }
                  } else {
                    AppBloc.get(context).addBetterDecisionToDBTable(
                        context, textFieldController.text, poll);
                  }
                }
              },
              text: "add"),
        ),
      ],
    ),
  ));
}

// ------------ Widget to make input for add note ---------------------
addNoteBoxEndOfNotes(context, cubit, PollModel poll, {noteId, nestedNoteId}) {
  TextEditingController textFieldController = TextEditingController();
  return Container(
      color: Colors.white,
      height: 40,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: cubit.userModel.image != null &&
                          cubit.userModel.image != ''
                      ? DecorationImage(
                          image: NetworkImage(cubit.userModel.image),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: AssetImage("assets/images/avatar.png"),
                          fit: BoxFit.cover)),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 10, top: 2, bottom: 2),
                child: DefaultFormField(
                  type: TextInputType.text,
                  controller: textFieldController,
                  focusedColorBorder: HexColor("#ced4da"),
                  labelColor: Colors.grey,
                  borderWidth: 50.0,
                  hintText: "add some notes here...",
                  prefixColorIcon: Colors.grey,
                  borderColor: HexColor("#ced4da"),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.only(start: 5, top: 2, bottom: 2),
              child: defaultTextButton(
                  function: () {
                    if (textFieldController.text.isNotEmpty) {
                      AppBloc.get(context)
                          .addPollNoteToDBTable(
                              context, textFieldController.text, poll)
                          .then((value) {});
                    }
                  },
                  text: "add"),
            ),
          ],
        ),
      ));
}

// ------------ Solution Builder ---------------------
Widget solutionBuilder(context, ProblemModel problem, SolutionModel solution) {
  return Container(
    // color: Colors.amber,
    height: 220,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        profileImageWithUserInfoComponent(context, solution.author!.uId,
            profileImage: solution.author!.image,
            datetimeOfPublish: solution.publishDateTime,
            fullName: solution.author!.fullName,
            jobTitle: solution.author!.jobTitle,
            withFollow: true),
        Column(
          children: [
            InkWell(
              onDoubleTap: () {
                // if (!solution.usersIdOfSupportSolution!.contains(userId)) {
                //   problem.peopleSolutions!.forEach((element2) {
                //     if (element2.id == solution.id) {
                //       element2.usersIdOfSupportSolution!.add(userId);
                //       AppBloc.get(context).updateSolution(problem);
                //     }
                //   });
                // }
              },
              child: Container(
                width: double.infinity,
                key: UniqueKey(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(8),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              solution.solution!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                              overflow: TextOverflow.clip,
                              maxLines: 8,
                            ),
                          ),
                        ],
                      ),
                      solution.image!.isNotEmpty
                          ? imageBuilder(solution.image)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            SolutionStats(solution: solution, problem: problem),
          ],
        ),
      ],
    ),
  );
}

// ------------ Better Choice Builder ---------------------
Widget betterChoiceBuilder(
    context, PollModel poll, BetterDecisionOption betterDecisionOption) {
  return Container(
    // color: Colors.amber,
    height: 130,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        profileImageWithUserInfoComponent(
            context, betterDecisionOption.userModel!.uId,
            profileImage: betterDecisionOption.userModel!.image,
            datetimeOfPublish: betterDecisionOption.publishDateTime,
            fullName: betterDecisionOption.userModel!.fullName,
            jobTitle: betterDecisionOption.userModel!.jobTitle,
            withFollow: true),
        betterOptionBuilder(context, poll, betterDecisionOption),
      ],
    ),
  );
}

// ------------ Better Option Builder ---------------------
Widget betterOptionBuilder(
    context, PollModel poll, BetterDecisionOption betterDecisionOption) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 200),
    child: Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onDoubleTap: () {
                if (!betterDecisionOption.usersIdOfLove!.contains(userId)) {
                  poll.betterDecisionOption!.forEach((element2) {
                    if (element2.id == betterDecisionOption.id) {
                      element2.usersIdOfLove!.add(userId);
                      AppBloc.get(context).updateBetterDecision(poll);
                    }
                  });
                }
              },
              onTap: () {
                if (!betterDecisionOption.usersIdOfVoted!.contains(userId)) {
                  poll.betterDecisionOption!.forEach((element2) {
                    if (element2.id == betterDecisionOption.id) {
                      element2.usersIdOfVoted!.add(userId);
                      AppBloc.get(context).updateBetterDecision(poll);
                    }
                  });
                }
              },
              child: Container(
                color: const Color(0xffEEF0EB),
                width: double.infinity,
                key: UniqueKey(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(8),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              betterDecisionOption.caption!,
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
                          if (betterDecisionOption.usersIdOfVoted!
                              .contains(userId))
                            const Icon(Icons.check,
                                color: Colors.green, size: 19),
                        ],
                      ),
                      betterDecisionOption.imageUrl != null
                          ? imageBuilder(betterDecisionOption.imageUrl)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
              betterDecisionOption.usersIdOfLove!.length.toString() +
                  " love • ",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
            Icon(
              Icons.poll_outlined,
              size: 15,
            ),
            Text(
              betterDecisionOption.usersIdOfVoted!.length.toString() + " votes",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    ),
  );
}

// ------------ Image of profile Builder ---------------------

Widget imageBuilder(image) {
  return Container(
    width: double.infinity,
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadiusDirectional.circular(50),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FittedBox(
        child: CachedNetworkImage(fit: BoxFit.contain, imageUrl: image),
        fit: BoxFit.contain,
      ),
    ),
  );
}

// Build Social Media Buttons
Widget socialMediaBtnsBuilder(context, model, isProblem) {
  return Material(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          buildSocialBtn(
              icon: FontAwesomeIcons.copy,
              color: Colors.grey,
              onClicked: () {
                SocialShare.copyToClipboard(model.caption).then((value) {
                  model.shares += 1;
                  if (isProblem) {
                    AppBloc.get(context).recordProblemShare(model);
                  } else {
                    AppBloc.get(context).recordPollShare(model);
                  }
                });
              }),
          const SizedBox(width: 5),
          buildSocialBtn(
              icon: FontAwesomeIcons.facebookSquare,
              color: Color(0xFF0075fc),
              onClicked: () {}),
          const SizedBox(width: 5),
          buildSocialBtn(
              icon: FontAwesomeIcons.twitter,
              color: Color(0xFF1da1f2),
              onClicked: () {
                SocialShare.shareTwitter(model.caption!).then((value) {
                  model.shares += 1;
                  if (isProblem) {
                    AppBloc.get(context).recordProblemShare(model);
                  } else {
                    AppBloc.get(context).recordPollShare(model);
                  }
                });
              }),
          const SizedBox(width: 5),
          buildSocialBtn(
              icon: FontAwesomeIcons.linkedin,
              color: Color(0xFF0064c9),
              onClicked: () {}),
          const SizedBox(width: 5),
          buildSocialBtn(
              icon: FontAwesomeIcons.whatsapp,
              color: Color(0xFF00d856),
              onClicked: () {
                SocialShare.checkInstalledAppsForShare().then((data) {
                  if (data!['whatsapp'] == true) {
                    SocialShare.shareWhatsapp(model.caption!).then((value) {
                      model.shares += 1;
                      if (isProblem) {
                        AppBloc.get(context).recordProblemShare(model);
                      } else {
                        AppBloc.get(context).recordPollShare(model);
                      }
                    });
                  } else {
                    showCustomSnackBar(context,
                        content: "App Not found",
                        bgColor: Colors.red,
                        textColor: Colors.white);
                  }
                });
              }),
          const SizedBox(width: 5),
          buildSocialBtn(
              icon: FontAwesomeIcons.telegram,
              color: Color(0xFF1da1f2),
              onClicked: () {
                SocialShare.checkInstalledAppsForShare().then((data) {
                  if (data!['telegram'] == true) {
                    SocialShare.shareTelegram(model.caption!).then((value) {
                      model.shares += 1;
                      if (isProblem) {
                        AppBloc.get(context).recordProblemShare(model);
                      } else {
                        AppBloc.get(context).recordPollShare(model);
                      }
                    });
                  } else {
                    showCustomSnackBar(context,
                        content: "App Not found",
                        bgColor: Colors.red,
                        textColor: Colors.white);
                  }
                });
              }),
          const SizedBox(width: 5),
          buildSocialBtn(
              icon: Icons.sms,
              color: Colors.black26,
              onClicked: () {
                SocialShare.checkInstalledAppsForShare().then((data) {
                  if (data!['false'] == true) {
                    SocialShare.shareSms(model.caption!).then((value) {
                      model.shares += 1;
                      if (isProblem) {
                        AppBloc.get(context).recordProblemShare(model);
                      } else {
                        AppBloc.get(context).recordPollShare(model);
                      }
                    });
                  } else {
                    showCustomSnackBar(context,
                        content: "App Not found",
                        bgColor: Colors.red,
                        textColor: Colors.white);
                  }
                });
              }),
        ]),
      ),
    ),
  );
}

Widget buildSocialBtn({
  required IconData icon,
  required Color color,
  required Function() onClicked,
}) =>
    InkWell(
      onTap: onClicked,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Color.fromARGB(138, 243, 243, 243),
            border: Border.all(
                color: Color.fromARGB(255, 196, 196, 196), width: .3),
            borderRadius: BorderRadiusDirectional.circular(40)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: FaIcon(
              icon,
              color: color,
              size: 30,
            ),
          ),
        ),
      ),
    );

Widget mainFloatingBTN(context) {
  return SpeedDial(
    activeIcon: Icons.close,
    animatedIconTheme: IconThemeData(size: 22),
    icon: Icons.add,
    backgroundColor: AppColors.appMainColors,
    foregroundColor: Colors.white,
    visible: true,
    overlayColor: Color.fromARGB(0, 0, 0, 0),
    curve: Curves.bounceIn,
    children: [
      SpeedDialChild(
          child: const Icon(
            Icons.poll_outlined,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          onTap: () {
            navigateTo(context, AddPollScreen());
          },
          label: 'Poll',
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
          labelBackgroundColor: Colors.blue),
      SpeedDialChild(
          child: const Icon(
            FontAwesomeIcons.puzzlePiece,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          onTap: () {
            navigateTo(context, AddProblemScreen());
          },
          label: 'Problem',
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
          labelBackgroundColor: Colors.red),
    ],
  );
}

// ------------ Function to make Random String id ---------------------
var _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQq43567RrSsTtUuVvWwXxYyZz1234567890' +
        DateTime.now().millisecond.toString();
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
