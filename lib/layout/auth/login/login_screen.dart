import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/default_form_field.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/layout/auth/forget_password/forget_password_screen.dart';
import 'package:savior/layout/auth/register/register_screen.dart';
import 'package:savior/layout/layout_of_app.dart';
import 'package:savior/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {
        if (state is AppLoginSuccessState) {
          showCustomSnackBar(context,
              content: "Done Login",
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
              AppLayout(),
            );
          });
        } else if (state is AppLoginErrorState) {
          showCustomSnackBar(context,
              content: state.error,
              bgColor: Colors.red,
              textColor: Colors.white);
        }
      },
      builder: (context, state) {
        return Scaffold(
            // backgroundColor: Colors.white,
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
                    _userInputsAndSendForm(state, context),
                    _footerSection(context, state),
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
              child: const Center(
                child: Image(
                  image: AssetImage('assets/images/app_logo-without-bg.png'),
                  width: 170,
                  height: 170,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 30.0,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "login to your existant account",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
      ],
    );
  }

  Widget _userInputsAndSendForm(state, context) {
    return Column(
      children: [
        DefaultFormField(
          type: TextInputType.emailAddress,
          controller: emailController,
          label: "email",
          focusedColorBorder: HexColor("#ced4da"),
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.alternate_email_outlined,
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
          isPassword: AppBloc.get(context).isPassword,
          focusedColorBorder: HexColor("#ced4da"),
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.password,
          suffix: AppBloc.get(context).suffix,
          maxLines: 1,
          isSuffix: true,
          suffixPressed: () => AppBloc.get(context).changePasswordVisibility(),
          validate: (password) {
            if (password == null || password.isEmpty) {
              return 'Please enter your password!';
            } else if (password.length < 8) {
              return 'Password must be more than 8 character';
            }
            return null;
          },
          borderColor: HexColor("#ced4da"),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            child: Text(
              "Forget Password?",
              style: TextStyle(color: Colors.grey.shade700),
            ),
            onPressed: () {
              navigateTo(context, ForgetPasswordScreen());
            },
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        ConditionalBuilder(
          condition: state is! AppLoginLoadingState,
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: AppColors.appMainColors,
            ),
            child: MaterialButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  SystemChannels.textInput
                      .invokeMethod('TextInput.hide'); //hides the keyboard
                  AppBloc.get(context).userLogin(
                      email: emailController.text,
                      password: passwordController.text);
                }
              },
              child: Text(
                "log in".toUpperCase(),
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

  Widget _footerSection(context, state) {
    return Column(
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            Expanded(
                child: Divider(
              color: Color.fromARGB(255, 213, 212, 212),
              thickness: 1,
            )),
            Text(
              " or login with ".toUpperCase(),
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(
                child: Divider(
              color: Color.fromARGB(255, 213, 212, 212),
              thickness: 1,
            )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginAndRegisterWithBuilder(
                context, state, Resources.facebook, "fb"),
            SizedBox(
              width: 5,
            ),
            loginAndRegisterWithBuilder(
                context, state, Resources.google, "google"),
            SizedBox(
              width: 5,
            ),
            loginAndRegisterWithBuilder(
                context, state, Resources.twitter, "twitter"),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(0),
              child: TextButton(
                  onPressed: () {
                    navigateTo(context, RegisterScreen());
                  },
                  child: Text(
                    "Create account",
                    style: TextStyle(
                        color: AppColors.appMainColors,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
