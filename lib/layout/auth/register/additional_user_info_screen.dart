import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/constants/enum_generator.dart';
import 'package:savior/components/default_form_field.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/layout/layout_of_app.dart';

class AditionalUserInfoScreen extends StatelessWidget {
  AditionalUserInfoScreen({Key? key}) : super(key: key);

  TextEditingController jobController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {
        if (state is SaveAdditionalUserInfoSuccessState) {
          print(userId);
          showCustomSnackBar(context,
              content: "Great Job! Enjoy.",
              bgColor: Colors.green,
              textColor: Colors.white);
          navigateAndFinish(
            context,
            AppLayout(),
          );
        } else if (state is SomeInfoNotExistState) {
          showCustomSnackBar(context,
              content: "Some information not filled out!, please fill it.",
              bgColor: Colors.red,
              textColor: Colors.white);
        } else if (state is SaveAdditionalUserInfoErrorState) {
          showCustomSnackBar(context,
              content: state.error,
              bgColor: Colors.red,
              textColor: Colors.white);
        }
      },
      builder: (context, state) {
        AppBloc cubit = AppBloc.get(context);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              if (state is! SaveAdditionalUserInfoLoadingState)
                defaultTextButton(
                    color: AppColors.appMainColors,
                    function: () {
                      cubit.saveAdditionalUserInfo(jobController.text);
                    },
                    text: "Save"),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              // height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  if (state is SaveAdditionalUserInfoLoadingState)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _headerSection(),
                          _userInputs(state, context, cubit),
                        ],
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

  Widget _headerSection() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: const Image(
                  image: AssetImage('assets/images/app_logo-without-bg.png'),
                  width: 170,
                  height: 170,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25.0,
        ),
        Text(
          "Some additional information",
          style: TextStyle(
            fontSize: 22.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "Give us more information about you!",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget _userInputs(state, context, AppBloc cubit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputLabel(context, "Job title"),
        const SizedBox(
          height: 3,
        ),
        DefaultFormField(
          type: TextInputType.text,
          controller: jobController,
          hintText: "e.g: Engineer, doctor, programmer ...",
          focusedColorBorder: HexColor("#ced4da"),
          borderWidth: 50.0,
          validate: (jobTitleVal) {
            if (jobTitleVal!.length < 6) {
              return 'Job title must have atleast 6 characters';
            } else if (jobTitleVal.contains('@')) {
              return 'Sign @ not allowed';
            } else if (jobTitleVal.isEmpty || jobTitleVal == '') {
              return "Please, enter Job title";
            }
            return null;
          },
          borderColor: HexColor("#ced4da"),
        ),
        const SizedBox(
          height: 15.0,
        ),
        inputLabel(context, "Gender"),
        const SizedBox(
          height: 3,
        ),
        genderBuilder(context, cubit, "male"),
        const SizedBox(
          height: 15.0,
        ),
        inputLabel(context, "Date of birth"),
        const SizedBox(
          height: 3,
        ),
        InkWell(
          onTap: () async {
            await cubit.selectDateOfBirth(context);
          },
          child: Container(
            padding: const EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
              top: 5,
              bottom: 5,
            ),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(50),
                border: Border.all(
                  color: state is SelectDateOfBirthAfterNow
                      ? Colors.red
                      : HexColor("#ced4da"),
                  width: 0.5,
                ),
                color: Theme.of(context).cardColor),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                cubit.birthDate,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 13, color: Colors.black),
              ),
            ),
          ),
        ),
        if (state is SelectDateOfBirthAfterNow)
          const SizedBox(
            height: 5.0,
          ),
        if (state is SelectDateOfBirthAfterNow)
          Text(
            "Please, choose valid date of birth!",
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontSize: 12, color: Colors.red),
          ),
        const SizedBox(
          height: 15.0,
        ),
        inputLabel(context, "Country"),
        const SizedBox(
          height: 3,
        ),
        InkWell(
          onTap: () {
            cubit.countryPicker(context);
          },
          child: Container(
            padding: const EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
              top: 5,
              bottom: 5,
            ),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(50),
                border: Border.all(
                  color: HexColor("#ced4da"),
                  width: 0.5,
                ),
                color: Theme.of(context).cardColor),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                cubit.userCountry,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 13, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget genderBuilder(context, cubit, gender) {
    int selectedValue = cubit.selectedValueOfGender;

    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 10,
        end: 10,
        top: 5,
        bottom: 5,
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(50),
          border: Border.all(
            color: HexColor("#ced4da"),
            width: 0,
          ),
          color: Theme.of(context).cardColor),
      child: DropdownButton(
        underline: Container(
          width: 0,
        ),
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        dropdownColor: Theme.of(context).cardColor,
        onChanged: (int? value) {
          cubit.getSelectedValueOfGender(value);
        },
        items: [
          DropdownMenuItem(
            value: 1,
            child: Text(
              Gender.male.name.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text(
              Gender.female.name.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
        style: Theme.of(context).textTheme.bodyText1,
        value: selectedValue,
      ),
    );
  }

  Widget inputLabel(context, label) => Text(
        label,
        style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
      );
}
