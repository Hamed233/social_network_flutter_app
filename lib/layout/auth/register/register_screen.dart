import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/default_form_field.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/layout/auth/login/login_screen.dart';
import 'package:savior/layout/auth/register/additional_user_info_screen.dart';
import 'package:savior/models/user.dart';
import 'package:savior/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  UserModel? model;

  final formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {
        if (state is AppRegisterSuccessState) {
          showCustomSnackBar(context,
              content:
                  "Register successfully, tell us some information about you!",
              bgColor: Colors.green,
              textColor: Colors.white);
          userId = state.uId;
          CacheHelper.saveData(
            key: CacheHelperKeys.userIdKey,
            value: state.uId,
          ).then((value) {
            AppBloc.get(context).getUserData(id: state.uId);
            navigateAndFinish(
              context,
              AditionalUserInfoScreen(),
            );
          });
        } else if (state is AppRegisterErrorState) {
          showCustomSnackBar(context,
              content: state.error,
              bgColor: Colors.red,
              textColor: Colors.white);
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _headerSection(),
                    _userInputAndSendForm(state, context),
                    _footerSection(context),
                  ],
                ),
              ),
            ),
          ),
        ));
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
          "Let's Get Started",
          style: TextStyle(
            fontSize: 28.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "Create a new account in small steps!",
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

  Widget _userInputAndSendForm(state, context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        DefaultFormField(
          type: TextInputType.text,
          controller: usernameController,
          label: "username",
          focusedColorBorder: HexColor("#ced4da"),
          labelColor: Colors.grey,
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.person,
          validate: (usernameVal) {
            final RegExp _messageRegex = RegExp(r'[a-zA-Z0-9]');
            if (usernameVal!.length < 6) {
              return 'Username must have atleast 6 characters';
            } else if (usernameVal.contains('@')) {
              return 'Sign @ not allowed';
            } else if (!_messageRegex.hasMatch(usernameVal)) {
              return 'Emoji not supported';
            } else if (usernameVal.isEmpty || usernameVal == null) {
              return "Please, enter username";
            }
            return null;
          },
          borderColor: HexColor("#ced4da"),
        ),
        const SizedBox(
          height: 10.0,
        ),
        DefaultFormField(
          type: TextInputType.emailAddress,
          controller: emailController,
          label: "email",
          focusedColorBorder: HexColor("#ced4da"),
          labelColor: Colors.grey,
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.alternate_email,
          validate: (emailVal) {
            bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(emailVal!);
            if (emailVal == null || emailVal.isEmpty) {
              return 'Please enter your email!';
            } else if (!emailValid) {
              return 'Email not valid!';
            }
            return null;
          },
          borderColor: HexColor("#ced4da"),
        ),
        const SizedBox(
          height: 10.0,
        ),
        DefaultFormField(
          type: TextInputType.visiblePassword,
          controller: passwordController,
          label: "password",
          focusedColorBorder: HexColor("#ced4da"),
          labelColor: Colors.grey,
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.person,
          isPassword: AppBloc.get(context).isPassword,
          suffix: AppBloc.get(context).suffix,
          isSuffix: true,
          maxLines: 1,
          suffixPressed: () => AppBloc.get(context).changePasswordVisibility(),
          validate: (passwordVal) {
            if (passwordVal == null || passwordVal.isEmpty) {
              return 'Please enter your password!';
            } else if (passwordVal.length < 8) {
              return 'Password must be more than 8 character';
            }
            return null;
          },
          borderColor: HexColor("#ced4da"),
        ),
        const SizedBox(
          height: 15.0,
        ),
        ConditionalBuilder(
          condition: state is! AppRegisterLoadingState,
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: AppColors.appMainColors,
            ),
            child: MaterialButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  AppBloc.get(context).userRegister(
                      name: usernameController.text,
                      email: emailController.text,
                      password: passwordController.text);
                }
              },
              child: Text(
                "Create".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        ),
        const SizedBox(
          height: 30.0,
        ),
      ],
    );
  }

  Widget _footerSection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "You have an account?",
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          width: 55,
          child: TextButton(
              onPressed: () {
                navigateTo(context, LoginScreen());
              },
              child: Text(
                "login",
                style: TextStyle(
                    color: AppColors.appMainColors,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }
}
