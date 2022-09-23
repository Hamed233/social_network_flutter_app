import 'package:flutter/material.dart';
import 'package:savior/layout/home_screen/polls_screen.dart';
import 'package:savior/layout/home_screen/problems_screen.dart';
import 'package:savior/layout/layout_of_app.dart';
import 'package:savior/layout/profile_screen/profile_screen.dart';

import '../layout/home_screen/polls_screen.dart';
import 'page_path.dart';

class PageRouter {
  final RouteObserver<PageRoute> routeObserver;

  PageRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PagePath.splashScreen:
        // return _buildRoute(settings, SplashPage());
      case PagePath.onBoardScreen:
        // return _buildRoute(settings, OnBoardPage())
      case PagePath.pollsScreen:
        return _buildRoute(settings, AppLayout());
      case PagePath.notificationScreen:
        // return _buildRoute(settings, NotificationScreen(bundle: args as ArgumentBundle));
      case PagePath.profileScreen:
        return _buildRoute(settings, ProfileScreen());
      case PagePath.pollsScreen:
        return _buildRoute(settings, PollsScreen(forWhat: "", pollWithMore: true));
      case PagePath.problemsScreen:
        return _buildRoute(settings, ProblemsScreen(forWhat: "", problemWithMore: true));
      case PagePath.searchScreen:
        // return _buildRoute(
        //   settings,
        //   SearchScreen(
        //     bundle: args as ArgumentBundle,
        //   ),
        // );      
      default:
        return _errorRoute();
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
