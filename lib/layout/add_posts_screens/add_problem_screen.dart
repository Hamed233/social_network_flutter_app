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

class AddProblemScreen extends StatelessWidget {
  AddProblemScreen({Key? key}) : super(key: key);

  TextEditingController problemTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final formKey = GlobalKey<FormState>();

    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
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
                "Add your question (or problem)",
              ),
              centerTitle: true,
              elevation: .5,
              actions: [
                if (state is! UploadPollLoadingState)
                  Container(
                    margin: const EdgeInsetsDirectional.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        color: AppColors.appMainColors),
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          cubit.addDataToProblemsTable(
                              context, problemTextController.text);
                        } else {
                          showCustomSnackBar(context,
                              content: "Please, Write something!",
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
                child: SolveProblemBuilder(
                  problemTextController: problemTextController,
                  cubit: cubit,
                  state: state,
                ),
              ),
            ),
          );
        });
  }

}

class SolveProblemBuilder extends StatelessWidget {
  TextEditingController problemTextController;
  AppBloc cubit;
  AppStates state;
  SolveProblemBuilder(
      {Key? key,
      required this.problemTextController,
      required this.cubit,
      required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 200, // if there image
                      ),
                      child: TextFormField(
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 14, overflow: TextOverflow.clip),
                        controller: problemTextController,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        minLines: null,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                            border: InputBorder.none,
                            hintText:
                                'Write here the problem you face and suffer from.e.g:\nHow can i stop smoking?,\nHow i learn programming? etc...'), // اكتب هنا المشكلة التى تواجهك وتعانى منها (على سبيل المثال: كيف يمكننى التوقف عن التدخين؟...)
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
            ),
            Align(
              alignment: Alignment.bottomLeft,
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
                      labelWithBtn(
                        context,
                        label: "Video",
                        icon: FontAwesomeIcons.video,
                        iconColor: Colors.blue,
                        iconSize: 15.0,
                        spaceBetween: 5.0,
                      ),
                      labelWithBtn(
                        context,
                        label: "Record",
                        icon: FontAwesomeIcons.microphone,
                        iconColor: Colors.red,
                        iconSize: 15.0,
                        spaceBetween: 3.0,
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
