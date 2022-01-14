import 'package:flutter/material.dart';

class Arrows extends StatelessWidget {
  final String bRoute;
  final String fRoute;
  late double __height;

  Arrows(this.bRoute, this.fRoute);

  @override
  Widget build(BuildContext context) {
    __height = MediaQuery.of(context).size.height;
    return Container(
      child: Row(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(bRoute);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(__height / 75.92727272727273),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(fRoute);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(__height / 75.92727272727273),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
