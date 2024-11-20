import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:test_4/pages/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade300),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  void initialization() async {
    if (await hasCacheData()) {
      if (mounted) {
        navigateWithoutMap(context);
      }
    }
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  //properties
  TextEditingController tfUsernameController = TextEditingController();
  TextEditingController tfEmailController = TextEditingController();
  TextEditingController tfPasswordController = TextEditingController();
  TextEditingController tfAgeController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Map map = {'Username': "", 'Age': "", 'Password': "", "Email": ""};

// ui start
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(children: [
        Form(
            key: formkey,
            child: Column(
              children: [
                inputTextForm(
                    "Username", "Please fill Username", tfUsernameController),
                inputTextForm("Email", "Please fill email", tfEmailController),
                inputTextForm(
                    "Password", "Please fill password", tfPasswordController),
                inputTextForm("Age", "Please fill Age", tfAgeController)
              ],
            )),
        TextButton(
            onPressed: () {
              if (formkey.currentState!.validate()) {
                setCacheData(tfUsernameController.text, tfAgeController.text,
                    tfEmailController.text, tfPasswordController.text);
                map.addAll(({
                  'Username': tfUsernameController.text,
                  'Age': tfEmailController.text,
                  'Email': tfPasswordController.text,
                  'Password': tfAgeController.text
                }));
                navigateToDetailsPageWithMap(map);
              }
            },
            child: const Text("register")),
      ]),
    );
  }

  //UI End
  Map mapCachedUserInformation = {};
//fucntions

  void setCacheData(
      String userName, String age, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('Username', userName);
    await prefs.setString('Age', age);
    await prefs.setString('Email', email);
    await prefs.setString('Password', password);
  }

  Future<bool> hasCacheData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('Username') != null &&
        prefs.getString('Age') != null &&
        prefs.getString('Email') != null &&
        prefs.getString('Password') != null) {
      return true;
    }
    return false;
  }

  Container inputTextForm(String formlabelText, String errorMessageIfEmpty,
      TextEditingController txtController) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: txtController,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: formlabelText),
        validator: (value) {
          if (validateValue(value!, formlabelText)) {
            return errorMessageIfEmpty;
          }
          return null;
        },
      ),
    );
  }

  void navigateToDetailsPageWithMap(Map map) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DetailsPage(
          map: map,
        ),
      ),
    );
  }

  void navigateWithoutMap(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DetailsPage(),
      ),
    );
  }

//start validate functions
  bool validateEmail(String email) {
    // Regular expression for validating an email
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegex.hasMatch(email);
  }

  bool containsNumbers(String input) {
    final RegExp numberRegex = RegExp(r'[0-9]');
    return numberRegex.hasMatch(input);
  }

  bool validatePassword(String password) {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.*\d)[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  bool validateValue(String value, String textLabel) {
    switch (textLabel) {
      case "Username":
        if (value.isEmpty) {
          return true;
        }
      case "Email":
        if (!validateEmail(value)) {
          return true;
        }
      case "Age":
        if (!containsNumbers(value)) {
          return true;
        }
      case "Password":
        if (!validatePassword(value)) {
          return true;
        }
        break;
      default:
        return false;
    }
    return false;
  }
//end validate functions
}
