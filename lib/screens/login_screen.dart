import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:petfinder/commons/custom_alert.dart';
import 'package:petfinder/commons/custom_loading.dart';
import 'package:petfinder/models/user_custom.dart';
import 'package:petfinder/screens/nav_screen.dart';
import 'package:petfinder/screens/register_screen.dart';
import 'package:petfinder/services/user_service.dart';
import 'package:petfinder/widgets/input_from.dart';
import 'package:petfinder/widgets/login_button.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_Screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserService userService = UserService();

  CustomLoading customLoading = CustomLoading();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  String? _token;

  double latitude = 0;
  double longitude = 0;
  bool loged = false;
  bool withGoogle = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => checkLogIn2(context));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('something recibed?');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // ToDO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message.toString());
    });
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token!),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset(
                        'assets/images/ginger-cat-robot-cat-twin.png')),
              ),
            ),
            if (!loged)
              InputForm(
                  hintText: 'Enter valid email id as abc@gmail.com',
                  labelText: 'Email',
                  controller: emailController),
            if (!loged)
              InputForm(
                  hintText: 'Enter secure password',
                  labelText: 'Password',
                  controller: passwordController,
                  obscure: true),
            (!loged)
                ? LoginButton(
                    text: 'Login',
                    color: Colors.blue,
                    onTap: () =>
                        login2(emailController.text, passwordController.text))
                : (!withGoogle)
                    ? LoginButton(
                        text: 'Log out',
                        color: Colors.blue,
                        onTap: () => logout2())
                    : Container(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 1,
                width: 400,
                color: Colors.black,
              ),
            ),
            (!loged)
                ? LoginButton(
                    text: 'Sign up with google',
                    color: Colors.red,
                    imageSrc: 'assets/images/google-logo.png',
                    onTap: () => loginWithGoogle())
                : (withGoogle)
                    ? LoginButton(
                        text: 'Sign out',
                        color: Colors.red,
                        imageSrc: 'assets/images/google-logo.png',
                        onTap: () => signOut())
                    : Container(),
            Flexible(
              child: Container(),
              fit: FlexFit.loose,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextButton(
                  onPressed: () => signinPage(),
                  //onPressed: () => sendPushMessage(),
                  child: Text(
                    'New User? Create Account',
                    style: TextStyle(
                        color: Colors.blueAccent, fontStyle: FontStyle.italic),
                  )),
            )
          ],
        ),
      ),
    );
  }

  /*login() async {
    customLoading.showMyDialog(context);
    UserCustom? user = await userService.getUser(emailController.text);
    if (user != null) {
      if (user.password == passwordController.text) {
        FirebaseAuth mAuth = FirebaseAuth.instance;
        User? userAuth = mAuth.currentUser;
        if (userAuth == null) await mAuth.signInAnonymously();
        userService.setCustomUser(user);
        customLoading.closeAlert(context);
        Navigator.pushNamed(context, NavigationScreen.id);
        setState(() {
          storage.write(key: 'email', value: emailController.text);
          loged = true;
          withGoogle = false;
        });
      } else {
        customLoading.closeAlert(context);
        CustomAlert()
            .showMyDialog(context, 'Credentials problem', 'wrong password');
      }
    } else {
      customLoading.closeAlert(context);
      CustomAlert().showMyDialog(
          context, 'Login call failed', 'Wrong email or empty input');
    }
  }*/

  login2(String email, String password) async {
    if ((RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email))) {
      customLoading.showMyDialog(context);
      User? user = await signInWithEmailAndPassword(email, password);
      if (user != null) {
        UserCustom? userCustom = await userService.getUser(user.email!);
        if (userCustom != null) {
          userService.setCustomUser(userCustom);
          //_token = await FirebaseMessaging.instance.getToken();
          print("FirebaseMessaging token: $_token");
          await FirebaseMessaging.instance.subscribeToTopic(userCustom.id);
          await storage.write(key: 'email', value: email);
          await storage.write(key: 'password', value: password);
          customLoading.closeAlert(context);
          await Navigator.pushNamed(context, NavigationScreen.id);
          setState(() {
            loged = true;
            withGoogle = false;
          });
        } else {
          CustomAlert().showMyDialog(context, 'Synchronization error',
              'Error getting user ${userCustom!.email} from database');
        }
      }
    } else {
      CustomAlert().showMyDialog(context, 'Email field', 'Malformed email');
    }
  }

  /*checkLogIn(BuildContext context) async {
    customLoading.showMyDialog(context);

    Position? pos = await Geolocator.getLastKnownPosition();
    if (pos != null) {
      latitude = pos.latitude;
      longitude = pos.longitude;
    }
    String? email = await storage.read(key: 'email');
    String? google = await storage.read(key: 'google');

    customLoading.closeAlert(context);

    if (email != null) {
      if (google != null) {
        loginWithGoogle();
      } else {
        customLoading.showMyDialog(context);
        UserCustom? user = await userService.getUser(email);
        if (user != null) {
          FirebaseAuth mAuth = FirebaseAuth.instance;
          User? userAuth = mAuth.currentUser;
          if (userAuth == null) await mAuth.signInAnonymously();
          userService.setCustomUser(user);
          customLoading.closeAlert(context);
          await Navigator.pushNamed(context, NavigationScreen.id);
          setState(() {
            loged = true;
            withGoogle = false;
          });
        } else {
          customLoading.closeAlert(context);
          CustomAlert().showMyDialog(
              context, 'Authentication error', 'Error getting user $email');
        }
      }
    }
  }*/

  checkLogIn2(BuildContext context) async {
    customLoading.showMyDialog(context);
    _token = await FirebaseMessaging.instance.getToken();
    print("FirebaseMessaging token: $_token");
    Position? pos = await Geolocator.getLastKnownPosition();
    if (pos != null) {
      latitude = pos.latitude;
      longitude = pos.longitude;
    }
    String? email = await storage.read(key: 'email');
    String? password = await storage.read(key: 'password');
    String? google = await storage.read(key: 'google');

    customLoading.closeAlert(context);
    if (email != null) {
      if (google != null) {
        loginWithGoogle();
      } else {
        if (password != null) login2(email, password);
      }
    }
  }

  signinPage() {
    Navigator.pushNamed(context, RegisterScreen.id);
  }

  Future<void> loginWithGoogle() async {
    customLoading.showMyDialog(context);
    User? user = await signInWithGoogle();
    if (user != null) {
      String? phone = user.phoneNumber;

      if (phone == null) phone = '0';
      UserCustom userG = UserCustom(
          user.displayName!,
          user.email!,
          '',
          DateTime.now(),
          1500,
          int.parse(phone),
          phone.length > 1,
          latitude,
          longitude,
          0);

      UserCustom? userCustom = await userService.addGoogleUser(userG);
      if (userCustom != null) {
        userService.setCustomUser(userCustom);

        //_token = await FirebaseMessaging.instance.getToken();
        print("FirebaseMessaging token: $_token");
        await FirebaseMessaging.instance.subscribeToTopic(userCustom.id);
        await storage.write(key: 'email', value: emailController.text);
        await storage.write(key: 'google', value: 'google');

        customLoading.closeAlert(context);

        await Navigator.pushNamed(context, NavigationScreen.id);
        setState(() {
          loged = true;
          withGoogle = true;
        });
      } else {
        CustomAlert().showMyDialog(context, 'Synchronization error',
            'Error getting user ${userCustom!.email} from database');
      }
    } else {
      customLoading.closeAlert(context);
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        customLoading.closeAlert(context);
        CustomAlert()
            .showMyDialog(context, e.code, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        customLoading.closeAlert(context);
        CustomAlert().showMyDialog(
            context, e.code, 'Wrong password provided for that user.');
      }
    }
  }

  Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          CustomAlert().showMyDialog(context, 'Authentication error', e.code);
        } else if (e.code == 'invalid-credential') {
          CustomAlert().showMyDialog(context, 'Authentication error', e.code);
        }
      } catch (e) {
        CustomAlert().showMyDialog(context, 'SignIn call failed', e.toString());
      }
    }
    return user;
  }

  /*logout() async {
    FirebaseAuth mAuth = FirebaseAuth.instance;
    User? user = mAuth.currentUser;
    if (user == null) await mAuth.signOut();
    setState(() {
      loged = false;
      storage.delete(key: 'email');
      storage.delete(key: 'google');
      emailController.text = '';
      passwordController.text = '';
    });
  }*/

  logout2() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(userService.userCustom.id);
    await FirebaseAuth.instance.signOut();
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
    await storage.delete(key: 'google');
    setState(() {
      loged = false;
      emailController.text = '';
      passwordController.text = '';
    });
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseMessaging.instance.unsubscribeFromTopic(userService.userCustom.id);
      await FirebaseAuth.instance.signOut();
      await storage.delete(key: 'email');
      await storage.delete(key: 'google');
      await storage.delete(key: 'password');
      setState(() {
        loged = false;
        emailController.text = '';
        passwordController.text = '';
      });
    } catch (e) {
      CustomAlert().showMyDialog(context, 'SignOut call failed', e.toString());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
