import 'package:flutter/material.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/layout/profile_screen/followers_screen.dart';
import 'package:savior/layout/profile_screen/followings_screen.dart';
import 'package:savior/layout/profile_screen/tabs/problems_tab.dart';

class NumbersWidget extends StatelessWidget {
  final int problemsLength;
  final int pollsLength;
  final int followersLength;
  final int followingLength;
  final String usrId;

  NumbersWidget(
      {required this.problemsLength,
      required this.pollsLength,
      required this.followersLength,
      required this.followingLength,
      required this.usrId});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: buildButton(
                      context, followingLength.toString(), 'Following',
                      onPressed: () {
                    navigateTo(
                        context,
                        FollowingsScreen(
                          id: usrId,
                        ));
                    AppBloc.get(context).getFollowingOfPerson(id: usrId);
                  }),
                ),
                const SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: buildButton(
                      context, followersLength.toString(), 'Followers',
                      onPressed: () {
                    navigateTo(context, FollowersScren(id: usrId));
                    AppBloc.get(context).getFollowersOfPerson(id: usrId);
                  }),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: buildButton(
                        context, problemsLength.toString(), 'Problems')),
                const SizedBox(
                  width: 7,
                ),
                Expanded(
                    child: buildButton(
                        context, pollsLength.toString(), 'decisions')),
              ],
            ),
          ],
        ),
      );
  Widget buildDivider() => Container(
        height: 24,
        child: const VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text,
          {Function()? onPressed}) =>
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: const Color.fromARGB(255, 224, 224, 224), width: 1)),
        child: MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 4),
          onPressed: onPressed,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: const Color.fromARGB(255, 19, 19, 19)),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 99, 99, 99)),
              ),
            ],
          ),
        ),
      );
}
