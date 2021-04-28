import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petfinder/commons/custom_alert.dart';
import 'package:petfinder/commons/custom_loading.dart';
import 'package:petfinder/models/user_custom.dart';
import 'package:petfinder/screens/login_screen.dart';
import 'package:petfinder/services/user_service.dart';
import 'package:petfinder/widgets/input_from.dart';
import 'package:petfinder/widgets/login_button.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_Screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserService loginService = UserService();
  CustomLoading customLoading = CustomLoading();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign in formulary',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text('Create an acount',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
              InputForm(
                  hintText: 'Enter your name',
                  labelText: 'User name',
                  controller: nameController),
              InputForm(
                  hintText: 'Enter your emal',
                  labelText: 'Email',
                  controller: emailController),
              InputForm(
                hintText: 'Enter password',
                labelText: 'Password',
                controller: passwordController,
                obscure: true,
              ),
              InputForm(
                hintText: 'Confirm password',
                labelText: 'Password',
                controller: confirmationController,
                obscure: true,
              ),
              Center(
                  child: LoginButton(
                      text: 'Sign in', color: Colors.blue, onTap: register2))
            ],
          ),
        ),
      ),
    );
  }

  /*register() async {
    if (checker()) {
      customLoading.showMyDialog(context);
      UserCustom? user = await loginService.getUser(emailController.text);
      if (user == null) {
        user = await loginService.registerUser(await resumeInfo());
        if (user != null) {
          customLoading.closeAlert(context);
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.id, (Route<dynamic> route) => false);
        } else {
          customLoading.closeAlert(context);
          CustomAlert()
              .showMyDialog(context, 'Connection problem', 'Error adding user');
        }
      } else {
        customLoading.closeAlert(context);
        CustomAlert()
            .showMyDialog(context, 'Connection problem', 'User exists');
      }
    }
  }*/

  register2() async {
    if (checker()) {
      customLoading.showMyDialog(context);
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        UserCustom? user = await loginService.registerUser(await resumeInfo());
        if (user != null) {
          customLoading.closeAlert(context);
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.id, (Route<dynamic> route) => false);
        } else {
          customLoading.closeAlert(context);
          CustomAlert()
              .showMyDialog(context, 'Connection problem', 'Error adding user');
        }
      } on FirebaseAuthException catch (e) {
        customLoading.closeAlert(context);
        if (e.code == 'weak-password') {
          CustomAlert().showMyDialog(
              context, e.code, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          CustomAlert().showMyDialog(
              context, e.code, 'The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<UserCustom> resumeInfo() async {
    Position position = await Geolocator.getCurrentPosition();
    return UserCustom(
        nameController.text,
        emailController.text,
        passwordController.text,
        DateTime.now(),
        1500,
        0,
        false,
        position.latitude,
        position.longitude,
        0);
  }

  bool checker() {
    String text = '';
    if (nameController.text.trim().length <= 0)
      text = 'No name defined';
    else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text))
      text = 'malformed email';
    else if (passwordController.text.length < 6)
      text = 'Password lenght need to be 6 or more';
    else if (passwordController.text != confirmationController.text)
      text = 'Passwords are not the same';

    if (text.length > 0) {
      CustomAlert().showMyDialog(context, 'Form error', text);
    }
    return text.length <= 0;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmationController.dispose();
    super.dispose();
  }
}
