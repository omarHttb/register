import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class DetailsPage extends StatelessWidget {
//   Map map = {'Username': "", 'Age': "", 'Password': "", "Email": ""};
//   DetailsPage({required this.map});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         children: [
//           const Text("Data sent by map"),
//           Text("Username  : ${map['Username']}"),
//           Text("Age  : ${map['Age']}"),
//           Text("Email  : ${map['Email']}"),
//           Text("Password  : ${map['Password']}"),
//           const Text("\n\nData sent by shared prefrence"),
//         ],
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
class DetailsPage extends StatefulWidget {
  Map map = {'Username': "", 'Age': "", 'Password': "", "Email": ""};
  DetailsPage({this.map = const {}});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    getData();

    if (widget.map.isEmpty) {
      widget.map = mapCachedUserInformation;
    }
  }

  List<String?> sharedPrefsList = [];
  Map mapCachedUserInformation = {
    'Username': "",
    'Age': "",
    'Password': "",
    "Email": ""
  };
  Map map = {};

  //functions
  Future getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getString('Username') != null &&
          prefs.getString('Age') != null &&
          prefs.getString('Email') != null &&
          prefs.getString('Password') != null) {
        mapCachedUserInformation.addAll({
          'Username': prefs.getString('Username'),
          'Age': prefs.getString('Age'),
          'Email': prefs.getString('Email'),
          'Password': prefs.getString('Password'),
        });
      }
    });
  }

  Future<void> clearCachedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.clear()) {
      print("true");
      setState(() {
        mapCachedUserInformation = {
          'Username': "",
          'Age': "",
          'Password': "",
          "Email": ""
        };
      });
    }
  }

// ui start
  @override
  Widget build(BuildContext context) {
    map = widget.map;
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          const Text("Data sent by map"),
          Text("Username  : ${map['Username']}"),
          Text("Age  : ${map['Age']}"),
          Text("Email  : ${map['Email']}"),
          Text("Password  : ${map['Password']}"),
          const Text("\n\nData sent by shared prefrence"),
          Text("Username  : ${mapCachedUserInformation['Username']} "),
          Text("Age  : ${mapCachedUserInformation['Age']} "),
          Text("Email  : ${mapCachedUserInformation['Email']} "),
          Text("Password  : ${mapCachedUserInformation['Password']} "),
          InkWell(
            onTap: () {
              clearCachedData();

              print("$mapCachedUserInformation");
            },
            child: const Text(
              "Click To Clear Cached Data",
              style: TextStyle(color: (Colors.red), fontSize: 40),
            ),
          )
        ]));
  }
}
