import 'package:flutter/cupertino.dart';

class Degree with ChangeNotifier {
  List _intiList = [
    {
      "display": "MBBS",
      "value": "MBBS",
    },
    {
      "display": "BDS",
      "value": "BDS",
    },
    {
      "display": "BHMS",
      "value": "BHMS",
    },
    {
      "display": "B.Pharm",
      "value": "B.Pharm",
    },
    {
      "display": "BYNS",
      "value": "BYNS",
    },
    {
      "display": "MD",
      "value": "MD",
    },
    {
      "display": "MS",
      "value": "MS",
    },
  ];

  List get items {
    return [..._intiList];
  }
}
