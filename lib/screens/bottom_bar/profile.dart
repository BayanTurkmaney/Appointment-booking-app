import 'dart:convert';
import 'dart:io';

import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/screens/bottom_bar/edit_profile_screen.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static final route = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _firstTime = true;
  late User _user;
  late double _height;
  String? _image;
  String? _chosenImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      _getUser();
      _firstTime = false;
    }
  }

  void _getUser() {
    _user = Provider.of<Auth>(
      context,
      listen: false,
    ).user!;

    setState(() {
      if (_user.photo != '') {
        _image = _user.photo;
      }
    });
  }

  Future<void> _getImage() async {
    final _tmpImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _chosenImage = _tmpImage!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_height / 7.592727272727273),
        child: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                var result = await Navigator.of(context)
                    .pushNamed(EditProfileScreen.route);
                if (result == 'refresh') {
                  setState(() {
                    _getUser();
                  });
                }
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ],
          title: Text(
            'Profile',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: _height / 31.6363636363636375,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 158, 216, 240),
                    kBlue,
                    Color.fromARGB(255, 158, 216, 240),
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: _height / 25.30909090909091,
            ),
            Stack(
              children: [
                Center(
                  child: Container(
                    width: _height / 6.9024793388429754545454545454545,
                    height: _height / 6.9024793388429754545454545454545,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: _image == null && _chosenImage == null
                        ? Icon(
                            FontAwesomeIcons.user,
                            color: kWhite,
                            size: _height / 37.963636363636365,
                          )
                        : _image != null
                            ? Image(
                                image: NetworkImage(_image!),
                                fit: BoxFit.cover,
                              )
                            : _chosenImage != null
                                ? Image.file(
                                    File(_chosenImage!),
                                  )
                                : Icon(
                                    FontAwesomeIcons.user,
                                    color: kWhite,
                                    size: _height / 37.963636363636365,
                                  ),
                  ),
                ),
                Positioned(
                  top: _height / 12.654545454545455,
                  left: _height / 3.4512396694214877272727272727273,
                  child: Container(
                    height: _height / 37.963636363636365,
                    width: _height / 37.963636363636365,
                    decoration: BoxDecoration(
                      color: kGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: kWhite,
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await _getImage();

                        if (_chosenImage != null) {
                          List<dynamic> _tmpList = await Provider.of<Auth>(
                            context,
                            listen: false,
                          ).updatePhoto(
                            userId: _user.idUser,
                            photo: base64Encode(
                              File(_chosenImage!).readAsBytesSync(),
                            ),
                          );

                          if (_tmpList[0]) {
                            setState(() {
                              _image = _chosenImage;
                            });
                          } else {
                            showMessage(
                              color: Colors.red,
                              context: context,
                              message: _tmpList[1],
                            );
                          }
                        }
                      },
                      icon: Icon(
                        FontAwesomeIcons.arrowUp,
                        size: _height / 37.963636363636365,
                        color: kWhite,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: _height / 37.963636363636365,
            ),
            Container(
              child: Divider(
                thickness: 3,
                color: Colors.black54,
              ),
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoEntry('Name:', _user.firstName + ' ' + _user.lastName),
                  Container(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  _infoEntry('Email:', _user.email),
                  Container(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  _infoEntry(
                    'Phone 1:',
                    _user.phone1 == '' ? 'No Phone 1' : _user.phone1,
                  ),
                  Container(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  _infoEntry(
                    'Phone 2:',
                    _user.phone2 == '' ? 'No Phone 2' : _user.phone2,
                  ),
                  Container(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  _infoEntry('Country:', _user.address['country']),
                  Container(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  _infoEntry('City:', _user.address['city']),
                  Container(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  _infoEntry('Location:', _user.address['location']),
                  Container(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  _infoEntry('Building:', _user.address['building']),
                ],
              ),
            ),
            SizedBox(
              height: _height / 37.963636363636365,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoEntry(String text, dynamic val) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: _height / 37.963636363636365,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            ' ' + val.toString(),
            style: TextStyle(
              fontSize: _height / 37.963636363636365,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
