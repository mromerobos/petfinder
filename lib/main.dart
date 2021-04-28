import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petfinder/screens/add_screen.dart';
import 'package:petfinder/screens/announcement_screen.dart';
import 'package:petfinder/screens/login_screen.dart';
import 'package:petfinder/screens/nav_screen.dart';
import 'package:petfinder/screens/other_user_screen.dart';
import 'package:petfinder/screens/register_screen.dart';
import 'package:petfinder/screens/user_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PetFinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        NavigationScreen.id: (context) => NavigationScreen(),
        UserScreen.id: (context) => UserScreen(),
        OtherUserScreen.id: (context) => OtherUserScreen(),
        AddScreen.id: (context) => AddScreen(),
        AnnouncementScreen.id: (context) => AnnouncementScreen(),
      },
      home: LoginScreen(),
    );
  }
}
