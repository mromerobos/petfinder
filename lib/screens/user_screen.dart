import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petfinder/commons/custom_alert.dart';
import 'package:petfinder/commons/custom_loading.dart';
import 'package:petfinder/commons/styles.dart';
import 'package:petfinder/models/user_custom.dart';
import 'package:petfinder/services/user_service.dart';
import 'package:petfinder/widgets/coordinates.dart';
import 'package:petfinder/widgets/icon_button_material.dart';
import 'package:petfinder/widgets/top_bar_custom.dart';
import 'package:petfinder/widgets/user_inputs.dart';

class UserScreen extends StatefulWidget {
  static const String id = 'user_screen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserService userService = UserService();

  late UserCustom userCustom;

  CustomLoading customLoading = CustomLoading();

  TextEditingController radiusController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  String userImage = '';
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    userCustom = userService.userCustom;
    refreshUI();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: (editMode)
            ? TopBarCustom(
                title: 'User screen', onTap: switchToEditMode, icon: Icons.save)
            : TopBarCustom(
                title: 'User screen',
                onTap: switchToEditMode,
                icon: Icons.edit),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    (userImage.length > 0)
                        ? userImage
                        : 'assets/images/abstract-866.png',
                    width: 125,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 200,
                          child: UserInput(
                            controller: nameController,
                            hintText: 'user name',
                            editMode: editMode,
                          )),
                      Container(
                          width: 200,
                          child: UserInput(
                            controller: emailController,
                            hintText: 'user email',
                            editMode: editMode,
                          )),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Update current location:',
                    style: normalText,
                  ),
                  IconButtonWithMaterial(
                      icon: Icons.add_location_alt_outlined,
                      onPressed: (editMode) ? updateLocation : () {}),
                ],
              ),
              Row(
                children: [
                  Text('Last location: ', style: sectionText,),
                  Coordinates(
                      lat: userCustom.latitude, lon: userCustom.longitude),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Radius distance of search: ',
                    style: sectionText,
                  ),
                  Expanded(
                      child: UserInput(
                    controller: radiusController,
                    type: TextInputType.number,
                    hintText: '1500 meters',
                    editMode: editMode,
                  )),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Phone number: ',
                    style: sectionText,
                  ),
                  Expanded(
                    child: UserInput(
                      controller: phoneController,
                      type: TextInputType.number,
                      hintText: 'phone number',
                      editMode: (editMode && userCustom.show),
                    ),
                  ),
                  Checkbox(
                      value: userCustom.show,
                      onChanged: (editMode)
                          ? (value) {
                              setState(() {
                                if (value != null) userCustom.show = value;
                              });
                            }
                          : null),
                ],
              ),
              if (editMode && userService.userCustom.password.length > 0)
                Text(
                  'Password changes: ',
                  style: sectionText,
                ),
              if (editMode && userService.userCustom.password.length > 0)
                UserInput(
                  hintText: 'New password',
                  controller: passwordController,
                  editMode: editMode,
                  obscure: true,
                ),
              if (editMode && userService.userCustom.password.length > 0)
                UserInput(
                  hintText: 'Confirm password',
                  controller: confirmController,
                  editMode: editMode,
                  obscure: true,
                ),
            ],
          ),
        ),
      ),
    );
  }

  switchToEditMode() {
    if(editMode && checker()) {
      setState(() {
        saveUserChanges();
        editMode = !editMode;
      });
    } else {
      setState(() {
        editMode = !editMode;
      });
    }
  }

  saveUserChanges() async {
    customLoading.showMyDialog(context);
    updateLocalUser();
    if (await userService.updateUser(userCustom)) {
      customLoading.closeAlert(context);
      CustomAlert().showMyDialog(context, 'Updating user failed',
          'Something went wrong while performing the call');
    } else {
      customLoading.closeAlert(context);
      userService.setCustomUser(userCustom);
    }
  }

  updateLocation() async {
    customLoading.showMyDialog(context);
    Position? position = await Geolocator.getCurrentPosition();
    customLoading.closeAlert(context);
    setState(() {
      userCustom.latitude = position.latitude;
      userCustom.longitude = position.longitude;
    });
  }

  void refreshUI() {
    nameController.text = userCustom.name;
    emailController.text = userCustom.email;
    passwordController.text = userCustom.password;
    confirmController.text = userCustom.password;
    radiusController.text = userCustom.radius.toString();
    phoneController.text = userCustom.telefon.toString();
  }

  void updateLocalUser() {
    userCustom.name = nameController.text;
    userCustom.email = emailController.text;
    userCustom.password = passwordController.text;
    if (radiusController.text.length > 0)
      userCustom.radius = int.parse(radiusController.text);
    if (phoneController.text.length > 0)
      userCustom.telefon = int.parse(phoneController.text);
  }

  @override
  void dispose() {
    radiusController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  bool checker() {
    String text = '';
    if (nameController.text.trim().length <= 0)
      text = 'No name defined';
    else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text))
      text = 'Malformed email';
    else if (phoneController.text.length != 9 && userCustom.show)
      text = 'Malformed phone';
    else if (passwordController.text.length < 6 &&
        userCustom.password.length > 0)
      text = 'Password lenght need to be 6 or more';
    else if (passwordController.text != confirmController.text)
      text = 'Passwords are not the same';

    if (text.length > 0) {
      CustomAlert().showMyDialog(context, 'Form error', text);
    }
    return text.length <= 0;
  }
}
