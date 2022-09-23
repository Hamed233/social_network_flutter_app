import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/animated_toggle_widget.dart';
import 'package:savior/components/styles/colors.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
      
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: Container(),
          title: Text(
            "settings",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: [

          ],
        ),
        body: state is! GetUserDataLoadingState ? SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 15.0,
                end: 15.0,
                top: 20.0,
                bottom: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(10),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_pin,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10,),
                              Text(
                                "account",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
        
                  SizedBox(height: 20,),
        
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                 Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    "general",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.dark_mode,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                   "toggleMode",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
                                  AnimatedToggle(
                                    values: ["dark", "light"],
                                    onToggleCallback: () {
                                      AppBloc.get(context).changeAppMode();
                                    },
                                    buttonColor: Theme.of(context).scaffoldBackgroundColor,
                                    backgroundColor: Color.fromARGB(255, 213, 212, 212),
                                    textColor: Colors.grey,
                                    isDark: AppBloc.get(context).isDark,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.notifications_none,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    "notifications",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        
                  SizedBox(height: 20,),
        
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    "help Feedback",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    "about",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.new_releases_outlined,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    "whatIsNew",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        
                  SizedBox(height: 20,),
        
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          // if(isLoginWith != null) {
                            AppBloc.get(context).signOut(context);
                          // } else {
                          //   navigateTo(context, LoginScreen());
                          // }
                        },
                        child: state is! SignoutLoading ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ) : Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25,),
                ],
              ),
            ),
          ),
        ) : Center(child: CircularProgressIndicator(color: AppColors.appMainColors, strokeWidth: 3)),
      );
      }
    );
  }
}
