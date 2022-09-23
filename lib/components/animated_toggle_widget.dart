import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedToggle extends StatelessWidget {

  final List<String>? values;
  final Function() onToggleCallback;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? textColor;
  final bool? isDark;

  AnimatedToggle({
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.33,
      height: Get.width * 0.10,
      // margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: onToggleCallback,
            child: Container(
              width: Get.width * 0.33,
              height: Get.width * 0.10,
              decoration: ShapeDecoration(
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Get.width * 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  values!.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                    child: Text(
                      values![index],
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: Get.width * 0.045,
                        // fontWeight: FontWeight.bold,
                        color: const Color(0xAA000000),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                isDark! ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: Get.width * 0.14,
              height: Get.width * 0.10,
              decoration: ShapeDecoration(
                color: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Get.width * 0.1),
                ),
              ),
              child: Text(
                !isDark! ? "Light" : "Dark",
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: Get.width * 0.040,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}