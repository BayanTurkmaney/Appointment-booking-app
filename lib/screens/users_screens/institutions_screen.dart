import 'package:booking_app/models/institution.dart';
import 'package:booking_app/providers/institutionProvider.dart';
import 'package:booking_app/screens/users_screens/details.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class InstitutionsScreen extends StatefulWidget {
  static const String route = 'institutions-screen';

  @override
  _InstitutionsScreenState createState() => _InstitutionsScreenState();
}

class _InstitutionsScreenState extends State<InstitutionsScreen> {
  List<Institution> _institutions = [];
  late String _category;
  bool _loadingMore = false,
      _firstTime = true,
      _isLoading = true,
      _hasNextPage = true;
  ScrollController _scrollController = ScrollController();
  int _page = 0;
  late double _height;

  @override
  void initState() {
    _scrollController.addListener(_loadMore);

    super.initState();
  }

  Future<void> _loadMore() async {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
      } else {
        if (_hasNextPage) {
          _page += 1;
          setState(() {
            _loadingMore = true;
          });

          await _getInstitutionsByCategory(
            category: _category,
            page: _page,
          );

          setState(() {
            _loadingMore = false;
          });
        }
      }
    }
  }

  String family = 'OpenSans';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      _category = _args!['category'];

      _getInstitutionsByCategory(
        category: _category,
        page: 0,
      );
      _firstTime = false;
    }
  }

  Future<void> _getInstitutionsByCategory({
    required String category,
    required int page,
  }) async {
    List<Institution> _tmpInstitutions = await Provider.of<InstitutionProvider>(
      context,
      listen: false,
    ).getInstitutionsByCategory(
      category: category,
      page: _page,
    );

    setState(() {
      _institutions.addAll(_tmpInstitutions);

      if (_tmpInstitutions.length < 10) {
        _hasNextPage = false;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_height / 7.592727272727273),
        child: AppBar(
          title: Text(
            'Institutions Under $_category',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: kWhite,
              fontSize: _height / 33.011857707509882608695652173913,
              fontFamily: 'Quicksand',
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: black,
                ),
              )
            : _institutions.isEmpty
                ? Center(
                    child: Text(
                      'No Institutions Found',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: family,
                        fontSize: _height / 37.963636363636365,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView(
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    children: [
                      AnimationLimiter(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: _institutions.length,
                          itemBuilder: (context, index) =>
                              AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount: 4,
                            child: ScaleAnimation(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      Details.route,
                                      arguments: {
                                        'institutionId':
                                            _institutions[index].id,
                                      },
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Hero(
                                            tag: _institutions[index].id,
                                            child: FadeInImage(
                                              placeholder: AssetImage(
                                                'assets/images/loading.gif',
                                              ),
                                              imageErrorBuilder: (context,
                                                      error, stackTrace) =>
                                                  Image(
                                                image: AssetImage(
                                                  'assets/images/logo.png',
                                                ),
                                              ),
                                              image: NetworkImage(
                                                _institutions[index].photo,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        color: Colors.white.withOpacity(0.25),
                                        padding: const EdgeInsets.all(5),
                                        child: Center(
                                          child: Container(
                                            child: Text(
                                              _institutions[index].name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: family,
                                                fontSize: _height /
                                                    37.963636363636365,
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
                          ),
                        ),
                      ),
                      if (_loadingMore)
                        Container(
                          margin: EdgeInsets.only(
                            bottom: _height / 37.963636363636365,
                            top: _height / 37.963636363636365,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: black,
                            ),
                          ),
                        ),
                      if (!_hasNextPage)
                        Container(
                          margin: EdgeInsets.only(
                            top: _height / 37.963636363636365,
                            bottom: _height / 37.963636363636365,
                          ),
                          child: Center(
                            child: Text(
                              'You have reached the end of the list',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: family,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}
