import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  final String image;
  final String name;

  IconCard({
    required this.image,
    required this.name,
  });
  late double _height;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double size = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(_height / 31.6363636363636375),
      width: width * 0.45,
      height: screenHeight * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_height / 50.61818181818182),
        image: DecorationImage(
          image: NetworkImage(
            image,
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        height: 3 * size,
        child: Text(
          name,
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.white,
            fontSize: _height / 37.963636363636365,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
