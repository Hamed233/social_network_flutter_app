import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/layout/single_screens/poll_single_screen.dart';
import 'package:savior/layout/single_screens/problem_single_screen.dart';
import 'package:savior/models/notification_model.dart';
import 'package:savior/routes/argument_bundle.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatelessWidget {
  final ArgumentBundle bundle;

  const NotificationScreen({Key? key, required this.bundle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? payload = bundle.extras;
    print(payload);

    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var appBloc = AppBloc.get(context);

          if (payload != null) {
            // appBloc.makeNotificationOpend(context, payload);
            // payload = null; // to prevent run makeNotificationOpend every time (Just once)
          }
          List<NotificationModel> notifications = [];
          if (appBloc.notificationsList.isNotEmpty) {
            notifications = appBloc.notificationsList;
          }

          // if(payload != null) appBloc.makeNotificationOpend(payload);

          return Scaffold(
            appBar: AppBar(
              shadowColor: Colors.grey,
              elevation: .3,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop(context),
              ),
              title: Text("Notifications"),
              centerTitle: true,
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: ConditionalBuilder(
                  condition: state is! GetNotificationsLoadingState,
                  builder: (context) => Container(
                    child: ConditionalBuilder(
                      condition: notifications.isNotEmpty,
                      builder: (context) => Column(
                        children: List.generate(
                          notifications.length,
                          (index) {
                            return _notificationBuilder(context,
                                model: notifications[index]);
                          },
                        ),
                      ),
                      fallback: (context) => Center(
                        child: SvgPicture.asset(
                          Resources.empty,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .75,
                        ),
                      ),
                    ),
                  ),
                  fallback: (context) => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appMainColors,
                    ),
                    heightFactor: 15,
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _notificationBuilder(context, {required NotificationModel model}) {
    final DateTime timeAgoOfNotification = DateTime.parse(model.date);

    return InkWell(
      onTap: () {
        if (model.notificationType == "problem") {
          AppBloc.get(context).getSingleProblem(model.postOrAccountId);
          navigateTo(context, SingleProblemsScreen(problemWithMore: true));
        } else {
          AppBloc.get(context).getSinglePoll(model.postOrAccountId);
          navigateTo(context, SinglePollScreen(pollWithMore: true));
        }
        if (model.isOpen == 0) {
          model.isOpen = 1;
          AppBloc.get(context).markNotificationAsOpened(model.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: Color.fromARGB(95, 158, 158, 158), width: .4),
            color: model.isOpen == 1
                ? Colors.white
                : Color.fromARGB(43, 33, 149, 243)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: reactIcon(model.notificationReaction)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          model.body!,
                          style: Theme.of(context).textTheme.headline3,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * .70,
                            child: Text(
                              timeago.format(timeAgoOfNotification).toString(),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Icon reactIcon(type) {
    if (type == "support") {
      return Icon(
        FontAwesomeIcons.handsClapping,
        color: Colors.blue,
        size: 38.0,
      );
    } else if (type == "note") {
      return Icon(
        FontAwesomeIcons.notesMedical,
        color: Colors.grey[800],
        size: 38.0,
      );
    } else if (type == "better_decision") {
      return Icon(
        FontAwesomeIcons.circlePlus,
        color: Colors.green,
        size: 38,
      );
    } else if (type == "voted") {
      return Icon(
        Icons.poll_outlined,
        size: 38,
      );
    } else if (type == "love_one_of_option_poll") {
      return Icon(
        FontAwesomeIcons.heart,
        color: Colors.blue,
        size: 38.0,
      );
    } else if (type == "suffer") {
      return Icon(
        FontAwesomeIcons.faceSadTear,
        color: Colors.blue,
        size: 38.0,
      );
    }

    return Icon(
      Icons.abc_outlined,
      size: 13.0,
    );
  }
}
