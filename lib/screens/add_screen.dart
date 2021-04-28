import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:petfinder/commons/arguments.dart';
import 'package:petfinder/commons/custom_alert.dart';
import 'package:petfinder/commons/custom_loading.dart';
import 'package:petfinder/commons/styles.dart';
import 'package:petfinder/models/announcement.dart';
import 'package:petfinder/models/comment.dart';
import 'package:petfinder/models/user_custom.dart';
import 'package:petfinder/screens/user_screen.dart';
import 'package:petfinder/services/announcement_service.dart';
import 'package:petfinder/services/comment_service.dart';
import 'package:petfinder/services/user_service.dart';
import 'package:petfinder/widgets/coordinates.dart';
import 'package:petfinder/widgets/icon_button_material.dart';
import 'package:petfinder/widgets/login_button.dart';
import 'package:petfinder/widgets/top_bar_custom.dart';
import 'package:petfinder/widgets/user_inputs.dart';

class AddScreen extends StatefulWidget {
  static const String id = 'add_screen';

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final CustomLoading customLoading = CustomLoading();
  final UserService userService = UserService();
  final AnnouncementService announcementService = AnnouncementService();
  final CommentService commentService = CommentService();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final List<File> imgList = [];

  bool isAdd = true;
  String announce_id = '';
  double lat = 41.922253;
  double lon = 2.800897;

  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => updateUbication());
  }

  @override
  Widget build(BuildContext context) {
    final AddScreenArguments? args =
        ModalRoute.of(context)!.settings.arguments as AddScreenArguments;
    isAdd = args!.isAdd;
    if (!isAdd) announce_id = args.id;
    lat = userService.userCustom.latitude;
    lon = userService.userCustom.longitude;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: TopBarCustom(
          icon: Icons.person,
          title: (isAdd) ? 'Add an announcement' : 'Add a comment',
          onTap: goToUserProfile,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              (isAdd) ? titelInput() : Container(),
              (imgList.length <= 0)
                  ? Container()
                  : CarouselSlider(
                      options: CarouselOptions(),
                      items: imgList
                          .map((item) => Container(
                                child: Center(
                                    child: Image.file(item,
                                        fit: BoxFit.contain, width: 350)),
                              ))
                          .toList(),
                    ),
              Row(
                children: [
                  Text('Add image(camera/file, max 5):', style: sectionText),
                  (imgList.length < 5)
                      ? IconButtonWithMaterial(
                          icon: Icons.add_a_photo_outlined,
                          onPressed: pickImageFromCamera)
                      : Container(),
                  (imgList.length < 5)
                      ? IconButtonWithMaterial(
                          icon: Icons.add_photo_alternate_outlined,
                          onPressed: pickImageFromGallery)
                      : Container(),
                ],
              ),
              Row(
                children: [
                  Text('Remove last image picked:', style: sectionText),
                  IconButtonWithMaterial(
                      icon: Icons.highlight_remove_outlined,
                      onPressed: () {
                        setState(() {
                          if (imgList.length > 0)
                            imgList.removeAt(imgList.length - 1);
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  Text('Time: ', style: sectionText),
                  Expanded(
                    child: Center(
                      child: Text(
                        DateFormat('HH:mm dd/MM/yyyy').format(currentDate),
                        style: normalText,
                      ),
                    ),
                  ),
                  IconButtonWithMaterial(
                      icon: Icons.calendar_today,
                      onPressed: () => onPressedDate(context))
                ],
              ),
              Row(
                children: [
                  Text(
                    'Update location:',
                    style: sectionText,
                  ),
                  IconButtonWithMaterial(
                      icon: Icons.add_location_alt_outlined,
                      onPressed: updateUbication),
                ],
              ),
              Row(
                children: [
                  Text('Last location: ', style: sectionText,),
                  Coordinates(lat: lat, lon: lon),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Description:',
                      style: sectionText,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                ),
              ),
              LoginButton(
                  text: 'Save',
                  color: Colors.blue,
                  onTap: () => saveAction())
            ],
          ),
        ),
      ),
    );
  }

  onPressedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null) {
      setState(() {
        currentDate = picked;
      });
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      );
      if (timeOfDay != null) {
        setState(() {
          currentDate = DateTime(currentDate.year, currentDate.month,
              currentDate.day, timeOfDay.hour, timeOfDay.minute);
        });
      }
    }
  }

  titelInput() {
    return Row(
      children: [
        Text('Title:', style: sectionText),
        Expanded(
          child: UserInput(
            hintText: 'Title for the add',
            controller: titleController,
            editMode: true,
          ),
        ),
      ],
    );
  }

  updateUbication() async {
    Position? pos = await Geolocator.getLastKnownPosition();
    if (pos != null) {
      setState(() {
        lat = pos.latitude;
        lon = pos.longitude;
      });
    }
  }

  saveAction() {
    if(isAdd) {
      saveAnnouncement();
    } else {
      saveComment();
    }
  }

  saveComment() async {
    if (checker()) {
      customLoading.showMyDialog(context);
      List<String> images = await announcementService.saveImagesToStorage(
          imgList, userService.userCustom.id);
      UserCustom user = userService.userCustom;
      Comment comment = Comment(descriptionController.text, announce_id,
          user.email, user.name, currentDate, lat, lon, images);
      String? id = await commentService.addComment(comment);
      customLoading.closeAlert(context);
      if (id == null) {
        CustomAlert().showMyDialog(
            context, 'Adding error', 'adding comment process failed');
      } else {
        Navigator.pop(context, id);
      }
    }
  }

  saveAnnouncement() async {
    if (checker()) {
      customLoading.showMyDialog(context);
      List<String> images = await announcementService.saveImagesToStorage(
          imgList, userService.userCustom.id);
      UserCustom user = userService.userCustom;
      Announcement announcement = Announcement(
          user.email,
          user.name,
          user.telefon.toString(),
          user.show,
          titleController.text,
          descriptionController.text,
          currentDate,
          lat,
          lon,
          images);
      String? id = await announcementService.addAnnouncement(announcement);
      customLoading.closeAlert(context);
      if (id == null) {
        CustomAlert().showMyDialog(
            context, 'Adding error', 'adding announcement process failed');
      } else {
        Navigator.pop(context, id);
      }
    }
  }

  pickImageFromCamera() async {
    PickedFile? image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      setState(() {
        imgList.add(File(image.path));
      });
    }
  }

  pickImageFromGallery() async {
    PickedFile? image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        imgList.add(File(image.path));
      });
    }
  }

  Future<List<String>> saveImagesToStorage() async {
    List<String> result = [];
    for (File file in imgList) {
      String imageName = file.path
          .substring(file.path.lastIndexOf('/'), file.path.lastIndexOf('.'))
          .replaceAll('/', '');
      TaskSnapshot snapshot = await firebaseStorage
          .ref()
          .child("${userService.userCustom.id}/$imageName")
          .putFile(file);
      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        result.add(downloadUrl);
      }
    }
    return result;
  }

  goToUserProfile() {
    Navigator.pushNamed(context, UserScreen.id);
  }

  bool checker() {
    String text = '';
    if (isAdd && titleController.text.length <= 4)
      text = 'title needs an improve (length > 4)';
    else if (isAdd && imgList.length <= 0)
      text = 'At least put an image of the pet';
    else if (descriptionController.text.length < 100)
      text = 'Description has to be 100 character length or more';
    if (text.length > 0) {
      CustomAlert().showMyDialog(context, 'Form error', text);
    }
    return text.length <= 0;
  }
}
