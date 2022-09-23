import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/models/make_decision.dart';
import 'package:savior/models/problem.dart';

class AddSolutionScreen extends StatefulWidget {
  final ProblemModel? problem;
  const AddSolutionScreen({Key? key, required this.problem}) : super(key: key);

  @override
  _AddNewPollScreenState createState() => _AddNewPollScreenState();
}

class _AddNewPollScreenState extends State<AddSolutionScreen> {
  TextEditingController solutionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final formKey = GlobalKey<FormState>();

    return BlocConsumer<AppBloc, AppStates>(listener: (context, state) {
      if (state is PublishSolutionErrorState) {
        showCustomSnackBar(context,
            content: state.error, bgColor: Colors.red, textColor: Colors.white);
      }
    }, builder: (context, state) {
      AppBloc cubit = AppBloc.get(context);

      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.close,
              size: 23,
              color: Colors.grey[500],
            ),
            onPressed: () {
              showConfimationOutBottomSheet(context);
            }, // check "if alredy wanna close or make it draft "
          ),
          title: Text(
            "Add Solution",
          ),
          centerTitle: true,
          elevation: .2,
          actions: [
            if (state is! PublishSolutionLoadingState)
              Container(
                margin: const EdgeInsetsDirectional.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(10),
                    color: AppColors.appMainColors),
                child: TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      cubit.publishSolution(
                          context, solutionController.text, widget.problem!);
                    } else {
                      showCustomSnackBar(context,
                          content: "Please, Write your solution!",
                          bgColor: Colors.red,
                          textColor: Colors.white);
                    }
                  },
                  child: const Text(
                    "Publish",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Container(
          height: double.infinity,
          child: Form(
              key: formKey,
              child: AddSolutionBuilder(
                  problem: widget.problem!,
                  cubit: cubit,
                  state: state,
                  controller: solutionController)),
        ),
      );
    });
  }
}

class AddSolutionBuilder extends StatelessWidget {
  ProblemModel problem;
  AppBloc cubit;
  AppStates state;
  TextEditingController controller;
  AddSolutionBuilder(
      {Key? key,
      required this.problem,
      required this.cubit,
      required this.state,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                      child: ProblemContainer(
                        problem: problem,
                      )),

                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 200, // if there image
                      ),
                      child: TextFormField(
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        controller: controller,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        minLines: null,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                            border: InputBorder.none,
                            hintText: 'Write solution here ...'),
                      ),
                    ),
                  ),
                  if (cubit.pickedFile != null)
                    const SizedBox(
                      height: 10,
                    ),
                  if (cubit.pickedFile != null)
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(50),
                      ),
                      child: FittedBox(
                        child: Image(
                          image: FileImage(cubit.uploadedImage!),
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: EdgeInsetsDirectional.only(start: 10),
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: Color.fromARGB(255, 220, 219, 219),
                  ))),
                  child: Row(
                    children: [
                      labelWithBtn(context,
                          label: "Photo",
                          icon: FontAwesomeIcons.image,
                          iconColor: Colors.green,
                          iconSize: 16.0,
                          spaceBetween: 5.0, onTap: () {
                        cubit.uploadImage();
                      }),
                      // labelWithBtn(
                      //   context,
                      //   label: "Video",
                      //   icon: FontAwesomeIcons.video,
                      //   iconColor: Colors.blue,
                      //   iconSize: 15.0,
                      //   spaceBetween: 5.0,
                      // ),
                      labelWithBtn(
                        context,
                        label: "Record",
                        icon: FontAwesomeIcons.microphone,
                        iconColor: Colors.red,
                        iconSize: 15.0,
                        spaceBetween: 3.0,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Checkbox(
                            value: cubit.solutionIsAnonymous,
                            onChanged: (bool? val) {
                              cubit.toggleSolutionIsAnonymous(val);
                            },
                          ),
                          Text(
                            "Publish as Anonymous?",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}

class ProblemContainer extends StatelessWidget {
  final ProblemModel problem;
  const ProblemContainer({Key? key, required this.problem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(problem.id.toString()),
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          border: Border.all(color: Color.fromARGB(255, 238, 238, 238))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                profileImageWithUserInfoComponent(
                  context,
                  problem.generalUserInfoModel!.uId,
                  profileImage: problem.generalUserInfoModel!.image,
                  datetimeOfPublish: problem.publishDateTime,
                  fullName: problem.generalUserInfoModel!.fullName,
                  jobTitle: problem.generalUserInfoModel!.jobTitle,
                  withFollow: false,
                  pollIsAnonymous: problem.isAnonymous,
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Text(
              problem.caption!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            problem.imageUrl!.isNotEmpty
                ? const SizedBox.shrink()
                : const SizedBox(height: 6.0),
            problem.imageUrl!.isNotEmpty
                ? imageBuilder(problem.imageUrl)
                : const SizedBox.shrink(),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
