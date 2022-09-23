import 'package:country_picker/country_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:savior/blocs/bloc_observer.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/styles/themes.dart';
import 'package:savior/exceptions/api_exception.dart';
import 'package:savior/layout/auth/login/login_screen.dart';
import 'package:savior/layout/layout_of_app.dart';
import 'package:savior/network/local/cache_helper.dart';
import 'package:savior/routes/routes.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('On Background Message');
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // For notification
  var token = await FirebaseMessaging.instance.getToken();
  print("token" + token.toString());

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: CacheHelperKeys.themeOfAppModeKey);
  // var onBoarding = CacheHelper.getData(key: CacheHelperKeys.onBoardingKey)??'';
  userId = CacheHelper.getData(key: CacheHelperKeys.userIdKey) ?? '';

  Widget widget = AppLayout();

  if (userId != '') {
    widget = AppLayout();
  } else {
    widget = LoginScreen();
  }

  runApp(ProviderScope(
    child: MyApp(startWidget: widget, isDark: isDark),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



class MyApp extends StatelessWidget {
  late final PageRouter _router;

  MyApp({Key? key, this.isDark, this.startWidget})
      : _router = PageRouter(),
        super(key: key) {
    initLogger();
  }
  final Widget? startWidget;
  final bool? isDark;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (BuildContext context) => AppBloc()
            ..changeAppMode(
              fromShared: isDark,
            )
            ..getUserData()..getAllPolls()..getAllProblems(),
        ),
      ],
      child: BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: MaterialApp(
              // title: "Tasks",
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              // themeMode: AppBloc
              //     .get(context)
              //     .isDark ? ThemeMode.dark : ThemeMode.light,
              themeMode: ThemeMode.light,
              onGenerateRoute: _router.getRoute,
              navigatorObservers: [_router.routeObserver],
              navigatorKey: navigatorKey,
              localizationsDelegates: [
                CountryLocalizations.delegate,
                // GlobalMaterialLocalizations.delegate,
                // GlobalWidgetsLocalizations.delegate,
                // GlobalCupertinoLocalizations.delegate,
              ],
            ),
          );
        },
      ),
    );
  }

  void initLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      dynamic e = record.error;
      String m = e is APIException ? e.message : e.toString();
      print(
          '${record.loggerName}: ${record.level.name}: ${record.message} ${m != 'null' ? m : ''}');
    });
    Logger.root.info("Logger initialized.");
  }
}
