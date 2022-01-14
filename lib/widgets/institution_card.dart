import 'package:booking_app/models/institution.dart';
import 'package:booking_app/screens/bottom_bar/institution_details_screen.dart';
import 'package:flutter/material.dart';

class InstitutionCard extends StatefulWidget {
  final Institution institution;
  final Function delete;
  final Function choosePlan;
  final double height;

  InstitutionCard({
    required this.institution,
    required this.delete,
    required this.choosePlan,
    required this.height,
  });

  @override
  _InstitutionCardState createState() => _InstitutionCardState();
}

class _InstitutionCardState extends State<InstitutionCard> {
  late double _height;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        if (widget.institution.planId == null) {
          widget.choosePlan();
        } else {
          Navigator.of(context).pushNamed(
            InstitutionDetailsScreen.route,
            arguments: {
              'institution': widget.institution,
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        width: double.infinity,
        height: _height / 6.3272727272727275,
        //  height: _height / 5.061818181818182,
        child: Card(
          elevation: 5,
          child: ListTile(
            isThreeLine: true,
            leading: Container(
              width: _height / 9.49090909090909125,
              height: _height / 9.49090909090909125,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      _height / 13.804958677685950909090909090909)),
              child: Image(
                image: NetworkImage(widget.institution.photo),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              widget.institution.name,
              style: Theme.of(context).textTheme.headline1,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    'Email: ' + widget.institution.email,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: _height / 50.61818181818182),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Text(
                    'Category: ' + widget.institution.category,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: _height / 50.61818181818182),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Are you sure you want to '
                      'delete this institution?',
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: _height / 37.963636363636365,
                          ),
                        ),
                        onPressed: () => widget.delete(),
                      ),
                      TextButton(
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontSize: _height / 37.963636363636365,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Padding(
                padding: EdgeInsets.only(
                    top: _height / 42.18181818181818333333333333333),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
