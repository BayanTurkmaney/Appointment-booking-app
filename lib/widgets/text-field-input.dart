import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  TextInputField({
    required this.icon,
    required this.hint,
    this.inputType,
    this.inputAction,
  });

  final IconData icon;
  final String hint;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  late double _height;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _height = size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _height / 75.92727272727273),
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[500]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(_height / 50.61818181818182),
        ),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: _height / 37.963636363636365),
                child: Icon(
                  icon,
                  size: 28,
                  color: kWhite,
                ),
              ),
              hintText: hint,
              hintStyle: kBodyText,
            ),
            style: kBodyText,
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}
