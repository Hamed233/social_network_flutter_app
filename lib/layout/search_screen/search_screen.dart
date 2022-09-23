import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/state_widgets.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/models/user.dart';

import '../../components/search_field.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var bloc = AppBloc.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.appMainColors,
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(context),
            ),
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              width: double.infinity,
              height: 40,
              margin: const EdgeInsetsDirectional.only(end: 14.0),
              child: Center(
                child:
                    SearchField(controller: searchController, autofocus: true),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              // color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  // Divider(),
                  // InkWell(
                  //   onTap: () {},
                  //   child: Container(
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.av_timer_rounded,
                  //             color: Colors.grey.shade600, size: 25),
                  //         const SizedBox(
                  //           width: 10,
                  //         ),
                  //         Container(
                  //           width: MediaQuery.of(context).size.width * 0.7,
                  //           child: Text(
                  //             "Search dsdsdsds",
                  //             style: Theme.of(context).textTheme.bodyText1,
                  //             overflow: TextOverflow.ellipsis,
                  //             maxLines: 4,
                  //           ),
                  //         ),
                  //         Spacer(),
                  //         IconButton(
                  //           icon: Icon(Icons.remove_circle_outline_sharp,
                  //               color: Colors.red, size: 25),
                  //           onPressed: () {},
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  SizedBox(
                    height: 5.0,
                  ),

                  ConditionalBuilder(
                      condition: state is! SearchInUserTblLoadingState,
                      builder: (context) => ConditionalBuilder(
                          condition: bloc.searchList.isNotEmpty,
                          builder: (context) {
                            return Column(
                              children: List.generate(
                                bloc.searchList.length,
                                (index) {
                                  return SearchBuilder(
                                      model: bloc.searchList[index]);
                                },
                              ),
                            );
                          },
                          fallback: (context) => SearchWidget(searchIn: "")),
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator()))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SearchBuilder extends StatelessWidget {
  final UserModel model;
  const SearchBuilder({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: model.image!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(model.image!),
                              fit: BoxFit.cover)
                          : DecorationImage(
                              image: AssetImage("assets/images/avatar.png"),
                              fit: BoxFit.cover)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    model.fullName!,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline_sharp,
                      color: Colors.red, size: 25),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
