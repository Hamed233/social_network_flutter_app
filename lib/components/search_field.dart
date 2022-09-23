import 'package:flutter/material.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/components/styles/colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final bool? autofocus;
  final String? hintText;
  final Color? borderColor;

  const SearchField({
    Key? key,
    this.controller,
    this.autofocus,
    this.hintText,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus ?? false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText ?? "search",
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.appMainColors,
        ),
        focusColor: AppColors.appMainColors,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor??Colors.transparent, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor??Colors.transparent, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),

        contentPadding: EdgeInsets.all(10.0),
      ),
      style: TextStyle(fontSize: 14),
      cursorColor: AppColors.appMainColors,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Enter text to search';
        }
        return null;
      },
      onChanged: (String text) {
        AppBloc.get(context).searchInUsersTbl(text);
      },
    );
  }
}
