import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/main_side_navbar.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/layout/notifications_screen/notifications_screen.dart';
import 'package:savior/layout/search_screen/search_screen.dart';
import 'package:savior/layout/settings/settings.dart';
import 'package:savior/network/local/cache_helper.dart';
import 'package:savior/routes/argument_bundle.dart';
import 'package:savior/service/local_notification_service.dart';

import '../blocs/general_app_bloc/app_general_bloc.dart';

class AppLayout extends StatefulWidget {
  AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var appCubit = AppBloc.get(context);
        var userId = CacheHelper.getData(key: CacheHelperKeys.userIdKey);

        return Scaffold(
          key: scaffoldKey,
          endDrawer: MainSideNavBar(username: "hamed esam", bio: "programmer"),
          appBar: state is! GetUserDataLoadingState
              ? AppBar(
                  elevation: 0,
                  titleSpacing: 0,
                  leading: SizedBox(
                    width: 45.0,
                    height: 30.0,
                    child: CircleAvatar(
                      child: Center(
                        child: Icon(
                          currentIconScreen(appCubit),
                          color: AppColors.appMainColors,
                          size: 28,
                        ),
                      ),
                      radius: 20,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  title: Text(
                    currentScreenTitle(appCubit),
                    style: TextStyle(color: AppColors.appMainColors),
                  ),
                  centerTitle: false,
                  actions: state is! GetAllPollsDataLoadingState
                      ? currentActionsList(context, appCubit, state)
                      : null,
                )
              : null,
          body: appCubit.mainScreens[appCubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            elevation: 0,
            onTap: (index) {
              appCubit.changeBottomNav(index);
            },
            currentIndex: appCubit.currentIndex,
            items: bottomBarList(),
          ),
          floatingActionButton: mainFloatingBTN(context),
        );
      },
    );
  }

  List<BottomNavigationBarItem> bottomBarList() {
    return [
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.poll),
        label: 'Polls',
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.puzzlePiece),
        label: 'Problems',
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.fire),
        label: 'Trend',
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.userLarge),
        label: 'Profile',
      ),
    ];
  }

  imageProfile(AppBloc cubit, state, {isLoginWith, socialUserData, imageProfile}) {
    //   print(cubit.userModel!.image!);
    //   if (isLoginWith == "Google") {
    //     socialUserData = FirebaseAuth.instance.currentUser!;
    //     return NetworkImage(socialUserData.photoURL);
    //   } else if (isLoginWith == "fb") {
    //     return NetworkImage(CacheHelper.getData(key: "userFBPicture"));
    //   } else if (isLoginWith == "Twitter") {
    //     return NetworkImage(CacheHelper.getData(key: "userTwitterPicture"));
    //   } else if (isLoginWith == "Native_email") {
    //     return cubit.userModel!.image!.isNotEmpty
    //         ? NetworkImage(cubit.userModel!.image!)
    //         : AssetImage('assets/images/avatar.jpg');
    //   } else {
    //     return AssetImage('assets/images/avatar.jpg');
    //   }
    // }

    // if (cubit.userModel!.image!.isNotEmpty) {
    //   return CircleAvatar(
    //     backgroundImage: NetworkImage(cubit.userModel!.image!),
    //     radius: 18,
    //   );
    // }
    return CircleAvatar(
      backgroundImage: AssetImage('assets/images/avatar.png'),
      // radius: 20,
    );
  }

  IconData currentIconScreen(appCubit) {
    if (appCubit.currentIndex == 0) {
      return FontAwesomeIcons.poll;
    } else if (appCubit.currentIndex == 1) {
      return FontAwesomeIcons.puzzlePiece;
    } else if (appCubit.currentIndex == 2) {
      return FontAwesomeIcons.fire;
    } else if (appCubit.currentIndex == 3) {
      return FontAwesomeIcons.userLarge;
    }

    return FontAwesomeIcons.house;
  }

  String currentScreenTitle(appCubit) {
    if (appCubit.currentIndex == 0) {
      return "Polls";
    } else if (appCubit.currentIndex == 1) {
      return "Problems";
    } else if (appCubit.currentIndex == 2) {
      return "Trend";
    } else if (appCubit.currentIndex == 3) {
      return "Profile";
    }

    return "Savior";
  }

  List<Widget> currentActionsList(context, AppBloc appCubit, state) {
    var notitficationsLength = appCubit.notificationsList
        .where((element) => element.isOpen == 0)
        .length;

    return [
      IconButton(
          onPressed: () {
            navigateTo(context, SearchScreen());
          },
          icon: const Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 17,
          )),
        IconButton(
          onPressed: () {
            appCubit.getNotifications();
            navigateTo(
              context,
              NotificationScreen(
                bundle: ArgumentBundle(),
              ),
            );
          },
          icon: Stack(
            children: <Widget>[
              const Icon(Icons.notifications_on_outlined),
              if (notitficationsLength > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 13,
                      minHeight: 13,
                    ),
                    child: Text(
                      notitficationsLength.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ),
      InkWell(
        child: imageProfile(appCubit, state),
        onTap: () {
          scaffoldKey.currentState!.openEndDrawer();
        },
      ),
    ];
  }
}
