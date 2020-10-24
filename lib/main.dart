import 'package:MiniProjectdoc/screen/login_page.dart';
import 'package:MiniProjectdoc/screen/signup_screen.dart';
import 'package:MiniProjectdoc/provider/degree.dart';
import 'package:MiniProjectdoc/provider/signin_signup.dart';
import 'package:MiniProjectdoc/screen/dashbord.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:MiniProjectdoc/screen/personal_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screen/profetional_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    getLoginUser();
  }

  getLoginUser() async {
    final pre = await SharedPreferences.getInstance();
    if (pre.getBool('isLogin') == null) {
      setState(() {
        _isLogin = false;
      });
    } else {
      setState(() {
        _isLogin = pre.getBool('isLogin');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snap) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Degree()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Color(0xFF6270DD),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home:
              // StreamBuilder(
              //     stream: FirebaseAuth.instance.onAuthStateChanged,
              // builder: (ctx, userSnapshot) {
              // if (userSnapshot.hasData) {
              // return
              _isLogin ? Dashbord() : LoginPage(),
          // }
          // return LoginPage();
          // }),
          routes: {
            SingupScreen.routeName: (context) => SingupScreen(),
            PersonalDetailScreen.routeName: (context) => PersonalDetailScreen(),
            ProfessionalDetail.routeName: (context) => ProfessionalDetail(),
            Dashbord.routeName: (context) => Dashbord(),
          },
        ),
      ),
    );
  }
}
