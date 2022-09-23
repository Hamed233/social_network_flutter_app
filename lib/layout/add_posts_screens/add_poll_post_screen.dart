import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/models/make_decision.dart';


class AddPollScreen extends StatefulWidget {
  AddPollScreen({Key? key}) : super(key: key);

  @override
  State<AddPollScreen> createState() => _AddPollScreenState();
}

class _AddPollScreenState extends State<AddPollScreen> {
  TextEditingController pollTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final formKey = GlobalKey<FormState>();

    return BlocConsumer<AppBloc, AppStates>(listener: (context, state) {
      if (state is UploadPollFailedState) {
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
            "Add Poll (Make a right decision)",
            style: Theme.of(context).textTheme.headline3,
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
                      cubit.uploadPoll(context,
                          caption: pollTextController.text,
                          pollHasPhoto:
                              cubit.uploadedImage != null ? true : false);
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
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    if (state is UploadPollLoadingState)
                      const LinearProgressIndicator(),
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
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
                              controller: pollTextController,
                              keyboardType: TextInputType.multiline,
                              textAlignVertical: TextAlignVertical.top,
                              maxLines: null,
                              minLines: null,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 10, 5, 10),
                                  border: InputBorder.none,
                                  hintText:
                                      'Write here the topic/thing that puzzles you ...'), // اكتب هنا الموضوع/الشي الذى يحيرك...
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
                                borderRadius:
                                    BorderRadiusDirectional.circular(50),
                              ),
                              child: FittedBox(
                                child: Image(
                                  image: FileImage(cubit.uploadedImage!),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Decisions/Choices in your mind", // القرارات/الخيارات التى تدور بعقلك
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        _decisionBoxBuilder(
                                            context,
                                            cubit,
                                            state,
                                            cubit.decisionOptionItems[index],
                                            index),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height: 10,
                                        ),
                                    itemCount:
                                        cubit.decisionOptionItems.length),
                                labelWithBtn(context,
                                    label: "Add other decision",
                                    labelSize: 16.0,
                                    icon: FontAwesomeIcons.circlePlus,
                                    iconColor:
                                        cubit.decisionOptionItems.length <= 10
                                            ? Colors.blue
                                            : Colors.grey,
                                    iconSize: 19.0,
                                    spaceBetween: 8.0, onTap: () {
                                  if (cubit.decisionOptionItems.length <= 10)
                                    cubit.addDecisionOption();
                                }),
                              ],
                            ),
                          )
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
                              labelWithBtn(context,
                                  label: "Record",
                                  icon: FontAwesomeIcons.microphone,
                                  iconColor: Colors.red,
                                  iconSize: 15.0,
                                  spaceBetween: 3.0, onTap: () {
                              }),
                              
                              const Spacer(),
                              Row(
                                children: [
                                  Checkbox(
                                    value: cubit.pollIsAnonymous,
                                    onChanged: (bool? val) {
                                      cubit.togglePollIsAnonymous(val);
                                    },
                                  ),
                                  Text(
                                    "Poll as Anonymous?",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
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
                )),
          ),
        ),
      );
    });
  }


}

Widget _decisionBoxBuilder(context, AppBloc cubit, AppStates state,
    DecisionOption decisionOption, indexCounter) {
  File? imageUrl;
  if (cubit.decisionOptionPhotos.isNotEmpty) {
    cubit.decisionOptionPhotos.entries.forEach((element) {
      if (element.key == decisionOption.id) {
        imageUrl = element.value;
      }
    });
  }
  return Container(
    key: Key(decisionOption.id.toString()),
    decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10),
        border: Border.all(color: Colors.grey.shade300)),
    child: Column(
      children: [
        TextFormField(
          autofocus: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          onChanged: (String? text) {
            decisionOption.caption = text;
          },
          style: TextStyle(
            fontSize: 14,
          ),
          controller: TextEditingController(
              text: state is PreviousDataOfPollCleanedSuccessState
                  ? ''
                  : decisionOption.caption),
          keyboardType: TextInputType.multiline,
          textAlignVertical: TextAlignVertical.top,
          maxLines: null,
          minLines: null,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 5, 10),
              border: InputBorder.none,
              hintText: 'Write decision ...'),
        ),
        // ------------------- If set Image
        if (imageUrl != null)
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(50),
            ),
            child: FittedBox(
              child: Image(
                image: FileImage(
                  imageUrl!,
                ),
              ),
              fit: BoxFit.fill,
            ),
          ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              padding: EdgeInsetsDirectional.only(start: 10),
              height: 50,
              decoration: BoxDecoration(
                  //     border: Border(
                  //         top: BorderSide(
                  //   color: Color.fromARGB(255, 220, 219, 219),
                  // ))
                  ),
              child: Row(
                children: [
                  labelWithBtn(context,
                      label: "Photo",
                      icon: FontAwesomeIcons.image,
                      iconColor: Colors.green,
                      iconSize: 16.0,
                      spaceBetween: 5.0, onTap: () {
                    cubit.pickPollDecisionImage(
                        decisionOptionId: decisionOption.id);
                  }),
                  labelWithBtn(
                    context,
                    label: "Record",
                    icon: FontAwesomeIcons.microphone,
                    iconColor: Colors.red,
                    iconSize: 15.0,
                    spaceBetween: 3.0,
                  ),
                  const Spacer(),
                  if (indexCounter > 1)
                    labelWithBtn(context,
                        label: "Remove",
                        labelColor: Colors.red,
                        icon: Icons.remove_circle_outline,
                        iconColor: Colors.red,
                        iconSize: 15.0,
                        spaceBetween: 3.0, onTap: () {
                      cubit.removeDecisionOption(decisionOption.id);
                    }),
                ],
              )),
        ),
      ],
    ),
  );
}
