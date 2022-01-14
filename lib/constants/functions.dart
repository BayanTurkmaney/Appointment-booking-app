import 'package:booking_app/models/category.dart';
import 'package:booking_app/models/plan.dart';
import 'package:booking_app/providers/institutionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showMessage({
  required String message,
  required Color color,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<List<Category>> getCategories({required BuildContext context}) async {
  print('2');
  return await Provider.of<InstitutionProvider>(
    context,
    listen: false,
  ).categories();
}

Future<List<Plan>> getPlans({required BuildContext context}) async {
  return await Provider.of<InstitutionProvider>(
    context,
    listen: false,
  ).plans();
}

// _height = 759.2727272727273
// 160 = _height / 4.745454545454545625
// 150 = _height / 5.061818181818182
// 75 = _height / 10.123636363636364
// 73 = _height / 10.400996264009963013698630136986
// 70 = _height / 10.846753246753247142857142857143
// 65 = _height / 11.681118881118881538461538461538
// 60 = _height / 12.654545454545455
// 55 = _height / 13.804958677685950909090909090909
// 50 = _height / 15.185454545454546
// 40 = _height / 18.9818181818181825
// 30 = _height / 25.30909090909091
// 25 = _height / 30.370909090909092
// 24 = _height / 31.6363636363636375
// 23 = _height / 33.011857707509882608695652173913
// 22 = _height / 34.512396694214877272727272727273
// 20 = _height / 37.963636363636365
// 18 = _height / 42.18181818181818333333333333333
