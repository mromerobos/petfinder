import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petfinder/models/announcement.dart';
import 'package:petfinder/models/comment.dart';
import 'package:petfinder/services/announcement_service.dart';
import 'package:petfinder/services/comment_service.dart';
import 'package:petfinder/services/user_service.dart';
import 'package:petfinder/widgets/filter.dart';

class MapSearch extends StatefulWidget {
  MapSearch({Key? key, required this.callback}) : super(key: key);

  final callback;

  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch>
    with AutomaticKeepAliveClientMixin<MapSearch> {
  AnnouncementService announcementService = AnnouncementService();
  CommentService commentService = CommentService();
  UserService userService = UserService();

  late GoogleMapController mapController;

  late LatLng _center;

  bool loading = false;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Polyline>_polyline={};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    WidgetsBinding.instance?.addPostFrameCallback((_) => setCoordiantes());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _center = LatLng(
        userService.userCustom.latitude, userService.userCustom.longitude);
    return Column(
      children: [
        Filter( loading: loading,
          onPressed:
              (String? text, int? radius, DateTime? from, DateTime? to) =>
                  searchAction(text, radius, from, to),
        ),
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: _polyline,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> searchAction(
      String? text, int? radius, DateTime? from, DateTime? to) async {
    setState(() {
      loading=true;
    });
    Position position = await Geolocator.getCurrentPosition();
    List<Announcement> list = await announcementService.getAnnouncements(
        text, radius, position, from, to);
    addMarkers(list);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    List<Comment> listComments = await commentService.getComments(list);
    addMarkersComments(listComments, list);
    setState(() {loading=false;});
  }

  void addMarkers(List<Announcement> list) {
    markers.clear();
    _polyline.clear();
    for (Announcement announcement in list) {
      String markerIdVal = 'marker_id_${announcement.id}';
      MarkerId markerId = MarkerId(markerIdVal);

      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          announcement.latitude,
          announcement.longitude,
        ),
        infoWindow: InfoWindow(
            title: announcement.title,
            onTap: () {
              _onMarkerTapped(announcement.id);
            }),
        //onTap: ,
      );
      markers[markerId] = marker;
    }
  }

  void addMarkersComments(List<Comment> list, List<Announcement> listAnn) {
    for (Comment comment in list) {
      Announcement announcement = listAnn.firstWhere((element) => element.id == comment.announce_id);
      double dist =  Geolocator.distanceBetween(comment.latitude, comment.longitude, announcement.latitude, announcement.longitude);
      if(dist > 50) {
        String markerIdVal = 'marker_id_${comment.id}';
        MarkerId markerId = MarkerId(markerIdVal);
        Marker marker = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          markerId: markerId,
          position: LatLng(
            comment.latitude,
            comment.longitude,
          ),
          onTap: () => _onMarkerTapped(comment.announce_id),
        );
        markers[markerId] = marker;
        addPolyline(comment, announcement);
      }
    }
  }

  void addPolyline(Comment comment, Announcement announcement) {
    String polylineIdVal = '${comment.id}-${announcement.id}';
    Polyline polyline = Polyline(
        polylineId: PolylineId(polylineIdVal),
        visible: true,
        points: [LatLng(comment.latitude, comment.longitude),LatLng(announcement.latitude, announcement.longitude)],
        width: 1,
        color: Colors.green);
    _polyline.add(polyline);
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
