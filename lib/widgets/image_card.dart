import 'package:booking_app/models/institution.dart';
import 'package:booking_app/screens/users_screens/details.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final Institution institution;

  ImageCard({
    required this.institution,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            Details.route,
            arguments: {
              'institution': institution,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(
                  62,
                  168,
                  174,
                  201,
                ),
                offset: Offset(
                  0,
                  9,
                ),
                blurRadius: 14,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: <Widget>[
                Image(
                  image: NetworkImage(institution.photo),
                  height: double.infinity,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.025),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 5,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: institution.name,
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
