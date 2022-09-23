import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/default_form_field.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/layout/auth/login/login_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  var emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppStates>(
      listener: (context, state) {
        if (state is ResetPasswordSuccessful) {
          showCustomSnackBar(context,
              content: "Password Reset Email Sent!",
              bgColor: Colors.green,
              textColor: Colors.white);

          navigateAndFinish(
            context,
            LoginScreen(),
          );
        } else if (state is ResetPasswordFailed) {
          showCustomSnackBar(context,
              content: "Your email not valid or not exist!",
              bgColor: Colors.red,
              textColor: Colors.white);
        } else if (state is ResetPasswordLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: const Image(
                              image: AssetImage(
                                  'assets/images/app_logo-without-bg.png'),
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
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 13.0,
                    ),
                    Text(
                      "Enter your email below",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    DefaultFormField(
                      type: TextInputType.emailAddress,
                      controller: emailController,
                      label: "email",
                      focusedColorBorder: HexColor("#ced4da"),
                      labelColor: Colors.grey,
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
                      height: 20.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! ResetPasswordLoading,
                      builder: (context) => Container(
                        width: MediaQuery.of(context).size.width * .5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: AppColors.appMainColors,
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              AppBloc.get(context)
                                  .resetPassword(emailController.text.trim());
                            }
                          },
                          child: Text(
                            "Send Link",
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
                    Container(
                      padding: const EdgeInsets.all(0),
                      child: TextButton(
                          onPressed: () {
                            navigateTo(context, LoginScreen());
                          },
                          child: Text(
                            "Back to login?",
                            style: TextStyle(
                                color: AppColors.appMainColors,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
  }
}
