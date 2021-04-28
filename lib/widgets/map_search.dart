import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petfinder/models/announcement.dart';
import 'package:petfinder/services/announcement_service.dart';
import 'package:petfinder/services/user_service.dart';
import 'package:petfinder/widgets/filter.dart';

class MapSearch extends StatefulWidget {

  MapSearch({Key? key, required this.callback}) : super(key: key);

  final callback;

  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> with AutomaticKeepAliveClientMixin<MapSearch> {

  AnnouncementService announcementService = AnnouncementService();
  UserService userService = UserService();

  late GoogleMapController mapController;

  late LatLng _center;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    WidgetsBinding.instance?.addPostFrameCallback((_) => setCoordiantes());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _center = LatLng(userService.userCustom.latitude, userService.userCustom.latitude);
    return Column(
      children: [
        Filter(onPressed: (String? text, int? radius, DateTime? from, DateTime? to) => searchAction(text, radius, from, to),),
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> searchAction(String? text, int? radius, DateTime? from, DateTime? to) async {
    Position position = await Geolocator.getCurrentPosition();
    List<Announcement> list = await announcementService.getAnnouncements(text, radius, position, from, to);
    print(list.length);
    addMarkers(list);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  void addMarkers(List<Announcement> list) {
    markers.clear();
    for(Announcement announcement in list) {
      String markerIdVal = 'marker_id_${announcement.id}';
      MarkerId markerId = MarkerId(markerIdVal);

      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          announcement.latitude,
          announcement.longitude,
        ),
        infoWindow: InfoWindow(title: announcement.title,onTap: () {
          _onMarkerTapped(announcement.id);
        }),
        //onTap: ,
      );
      markers[markerId] = marker;
    }
  }

  void _onMarkerTapped(String id) {
     widget.callback(id);
  }


  @override
  bool get wantKeepAlive => true;

  setCoordiantes() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }
}
