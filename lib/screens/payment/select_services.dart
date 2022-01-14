import 'package:booking_app/models/institution.dart';
import 'package:booking_app/models/service.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/check_service_card.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class SelectService extends StatefulWidget {
  static const route = '/select-service';

  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> _subCategories = [];
  bool _firstTime = true;
  late final Institution _institution;
  List<Service> _services = [];
  late double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      _subCategories = _args!['subCategories'];
      _services = _args['services'];
      _institution = _args['institution'];
      _tabController = TabController(
        length: _subCategories.length,
        vsync: this,
      );

      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_height / 5.061818181818182),
        child: AppBar(
          backgroundColor: black,
          title: Text(
            'Services',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: _height / 34.512396694214877272727272727273,
            ),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              indicatorHeight: _height / 25.30909090909091,
              indicatorColor: Colors.white,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            labelStyle: TextStyle(
                fontFamily: 'OpenSans', fontSize: _height / 37.963636363636365),
            labelColor: black,
            unselectedLabelColor: kWhite,
            labelPadding: EdgeInsets.all(10),
            tabs: _subCategories
                .map(
                  (subCategory) => Text(subCategory),
                )
                .toList(),
            controller: _tabController,
            physics: BouncingScrollPhysics(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _subCategories.map(_buildListView).toList(),
      ),
    );
  }

  ListView _buildListView(subCategory) {
    return ListView(
      children: _filterServicesByCategory(subCategory)
          .map(_buildServiceCard)
          .toList(),
    );
  }

  List<Service> _filterServicesByCategory(subCategory) {
    return [
      ..._services.where(
        (service) => service.category == subCategory,
      )
    ];
  }

  ServiceCardCheck _buildServiceCard(service) {
    return ServiceCardCheck(
      details: false,
      institution: _institution,
      service: service,
      servicesListLength: _services.length,
    );
  }
}
