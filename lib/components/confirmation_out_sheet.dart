import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/layout/layout_of_app.dart';

class ConfimationOutSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Material(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsetsDirectional.all(10),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.drafts_rounded,
                              size: 26,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Save as draft",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                    color: Colors.green,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      AppBloc.get(context).cleanPreviousPollPostData();
                      navigateAndFinish(context, AppLayout());
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              size: 26,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Leave",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              size: 26,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Cancel",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                    color: Colors.grey.shade800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
