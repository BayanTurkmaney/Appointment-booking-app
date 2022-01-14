import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextInputType? inputType;
  final TextInputAction? inputAction;

  PasswordInput({
    required this.icon,
    required this.hint,
    this.inputType,
    this.inputAction,
  });

  late double _height;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _height = MediaQuery.of(context).size.height;
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  icon,
                  size: 28,
                  color: kWhite,
                ),
              ),
              hintText: hint,
              hintStyle: kBodyText,
            ),
            obscureText: true,
            style: kBodyText,
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}
