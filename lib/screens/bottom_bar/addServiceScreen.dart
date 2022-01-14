import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/institution.dart';
import 'package:booking_app/models/plan.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/institutionProvider.dart';
import 'package:booking_app/screens/bottom_bar/profile.dart';
import 'package:booking_app/screens/service_form/addInstitution.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:booking_app/widgets/custom_drawer.dart';
import 'package:booking_app/widgets/institution_card.dart';
import 'package:booking_app/widgets/plan_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddServiceScreen extends StatefulWidget {
  static final route = '/add-ser';

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddServiceScreen> {
  late String _name;
  bool _firstTime = true;
  List<Institution> _institutions = [];
  bool _isLoading = false;
  String? _val;
  List<Plan> _plans = [];
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

      _institutions = Provider.of<InstitutionProvider>(
        context,
        listen: false,
      ).institutions;
      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_height / 7.592727272727273),
        child: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Profile.route,
                );
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ],
          title: Text('Welcome $_name'),
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
      drawer: CustomDrawer(),
      body: _institutions.isEmpty
          ? Center(
              child: Text(
                'Tap + To Add Your Institution',
                style: TextStyle(
                  fontSize: _height / 37.963636363636365,
                  color: Colors.grey,
                ),
              ),
            )
          : _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: black,
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => InstitutionCard(
                    institution: _institutions[index],
                    delete: () => _deleteInstitution(
                      institutionId: _institutions[index].id,
                    ),
                    choosePlan: () async {
                      _plans = await getPlans(context: context);
                      _choosePlan(
                        plans: _plans,
                        institutionId: _institutions[index].id,
                      );
                    },
                    height: MediaQuery.of(context).size.height,
                  ),
                  itemCount: _institutions.length,
                  physics: BouncingScrollPhysics(),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddInstitution.route);
        },
        backgroundColor: black,
      ),
    );
  }

  Future<void> _deleteInstitution({
    required String institutionId,
  }) async {
    Navigator.of(context).pop();

    setState(() {
      _isLoading = true;
    });

    Auth _auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    String? _token = _auth.token;

    List<dynamic> _deletedList = await Provider.of<InstitutionProvider>(
      context,
      listen: false,
    ).deleteInstitution(
      institutionId: institutionId,
      token: _token!,
    );

    setState(() {
      _isLoading = false;
    });

    if (_deletedList[0]) {
      showMessage(
        color: Colors.green,
        message: 'Institution Deleted Successfully.',
        context: context,
      );
    } else {
      showMessage(
        color: Colors.red,
        message: _deletedList[1],
        context: context,
      );
    }
  }

  void _choosePlan({
    required List<Plan> plans,
    required String institutionId,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      builder: (context) => _buildModalContent(
        height: MediaQuery.of(context).size.height,
        context: context,
        institutionId: institutionId,
        plans: plans,
      ),
    );
  }

  Container _buildModalContent({
    required double height,
    required BuildContext context,
    required List<Plan> plans,
    required String institutionId,
  }) {
    return Container(
      height: height * .8,
      child: StatefulBuilder(
        builder: (context, setState) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: _height / 13.804958677685950909090909090909,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: _height / 37.963636363636365,
                              ),
                              _buildDetails(
                                height: height,
                                plans: plans,
                                setState: setState,
                              ),
                              SizedBox(
                                height: _height / 37.963636363636365,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: _height / 12.654545454545455,
                    color: black,
                    child: ElevatedButton(
                      onPressed: _val == null
                          ? null
                          : () => _subscribeToPlan(
                                institutionId: institutionId,
                              ),
                      child: Text('Choose Plan'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Padding _buildDetails({
    required double height,
    required List<Plan> plans,
    required StateSetter setState,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...plans.map(
            (plan) => Column(
              children: [
                ListTile(
                  tileColor: black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: black,
                      width: 2,
                    ),
                  ),
                  title: PlanItem(
                    plan: plan,
                  ),
                  onTap: () {
                    setState(() {
                      _val = plan.id;
                    });
                  },
                  leading: Radio(
                    value: plan.id,
                    groupValue: _val,
                    onChanged: (value) {
                      setState(() {
                        _val = value as String?;
                      });
                    },
                    activeColor: Colors.white,
                    fillColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: _height / 37.963636363636365,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _subscribeToPlan({
    required String institutionId,
  }) async {
    Navigator.of(context).pop();

    setState(() {
      _isLoading = true;
    });

    Auth _auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    InstitutionProvider _institutionProvider = Provider.of<InstitutionProvider>(
      context,
      listen: false,
    );

    String? _token = _auth.token;

    List<dynamic> _subscribeToPlanList =
        await _institutionProvider.subscribeToPlan(
      institutionId: institutionId,
      token: _token!,
      ownerId: _auth.user!.idUser,
      planId: _val!,
    );

    _val = null;

    if (_subscribeToPlanList[0]) {
      showMessage(
        message: 'Subscribed To Plan Successfully.',
        color: Colors.green,
        context: context,
      );

      await Provider.of<InstitutionProvider>(
        context,
        listen: false,
      ).getInstitutionById(
        institutionId: '615754319387d90016ba890e',
      );

      setState(() {
        _institutions = Provider.of<InstitutionProvider>(
          context,
          listen: false,
        ).institutions;

        _isLoading = false;
      });
    } else {
      showMessage(
        message: _subscribeToPlanList[1],
        color: Colors.red,
        context: context,
      );
    }
  }
}
