import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingWidget extends StatefulWidget {
  const RatingWidget({Key? key}) : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late double _height;
  double rating = 0.0;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBar.builder(
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          updateOnDrag: true,
          itemSize: _height / 151.8545454545455,
          itemPadding: EdgeInsets.symmetric(
            horizontal: 0,
          ),
          onRatingUpdate: (rating) => setState(() {
            this.rating = rating;
          }),
          minRating: 1,
        ),
      ],
    );
  }
}
