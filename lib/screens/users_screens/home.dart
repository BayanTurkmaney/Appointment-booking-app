import 'package:animated_text/animated_text.dart';
import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/category.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/screens/users_screens/institutions_screen.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:booking_app/widgets/icon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static final route = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _name;
  List<Category> _categories = [];

  bool _firstTime = true, _isLoading = true;
  late User _user;
  bool _pinned = true;
  late double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      _name = Provider.of<Auth>(
        context,
        listen: false,
      ).user!.firstName;
      _user = Provider.of<Auth>(
        context,
        listen: false,
      ).user!;
      _setUser();
      _getCategories();
      print('cattegory length is :' + _categories.length.toString());
      _firstTime = false;
    }
  }

  void _setUser() {
    Provider.of<Appointments>(
      context,
      listen: false,
    ).setValue(
      key: 'userId',
      value: _user.idUser,
    );
  }

  Future<void> _getCategories() async {
    print('1');
    _categories = await getCategories(context: context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text(
              'Home',
              style: TextStyle(
                color: kWhite,
                fontWeight: FontWeight.bold,
                fontSize: _height / 34.512396694214877272727272727273,
              ),
            ),
            expandedHeight: _height / 2.1693506493506494285714285714286,
            floating: true,
            pinned: _pinned,
            backgroundColor: kGreen1,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: ClipPath(
                  clipper: MyCustomClipper(),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    height: _height / 2.1693506493506494285714285714286,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/smile.jpg'),
                        fit: BoxFit.cover,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: kBlue,
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 15.0,
                                  top: _height / 37.963636363636365,
                                ),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      width: double.infinity,
                                      height: 40,
                                      child: AnimatedText(
                                        alignment: Alignment.centerLeft,
                                        speed: Duration(milliseconds: 1000),
                                        controller: AnimatedTextController.play,
                                        repeatCount: 1,
                                        displayTime:
                                            Duration(milliseconds: 1000),
                                        wordList: [
                                          'hello $_name',
                                          'what are you looking for?'
                                        ],
                                        textStyle: TextStyle(
                                            color: black,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700),
                                        onAnimate: (index) {},
                                        onFinished: () {
                                          setState(() {
                                            controller:
                                            AnimatedTextController.stop;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _height / 15.185454545454546,
                            ),
                            Container(
                              height:
                                  _height / 2.4103896103896104761904761904762,
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 4000),
                                      child: SlideAnimation(
                                        verticalOffset: 75.0,
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                  InstitutionsScreen.route,
                                                  arguments: {
                                                    'category':
                                                        _categories[index].name,
                                                  },
                                                );
                                              },
                                              child: IconCard(
                                                image: _categories[index].image,
                                                name: _categories[index].name,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: _categories.length,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
