import 'dart:async';
import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/GeoCoderModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/services/LocationService.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_picker/google_places_picker.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreen createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  CheckAdminController checkAdminController = Get.find();
  var utils = AppUtils();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Place _place = Place();
  String? addressString;

  CameraPosition? _kGooglePlex;

  late CameraPosition _kLake;

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  getLocation() async {
    LocationPermission permission = await GeolocatorPlatform.instance.requestPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      return;
    }
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high
    ));
    var currentPostion = LatLng(position.latitude, position.longitude);
    _kGooglePlex = CameraPosition(
    target: currentPostion,
    zoom: 14.4746,
    );
    _add(currentPostion);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _place);
        return false;
      },
      child: Scaffold(
        body: Container(
          width: Get.width,
          height: Get.height,
          child: Stack(
            children: [
              if(_kGooglePlex != null) GoogleMap(
                mapType: MapType.terrain,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: _kGooglePlex!,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setState(() {
                  });
                }, markers: Set<Marker>.of(markers.values),
                onTap: (latlng){
                  _place = Place();
                  _place.latitude = latlng.latitude;
                  _place.longitude = latlng.longitude;
                  _add(latlng);
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 70,),
                  if(addressString != null) Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Container(
                        width: Get.width,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: whiteColor
                        ),
                        child: Text("$addressString", style: utils.smallLabelStyle(blackColor),),
                      )),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context, _place);
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: checkAdminController.system.mainColor
                          ),
                          child: Text("Save" , style: utils.smallLabelStyle(whiteColor),),
                        ),
                      ),
                      SizedBox(width: 12,)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: checkAdminController.system.mainColor,
          onPressed: _showAutocomplete,
          label: Text('Search' , style: utils.smallLabelStyle(whiteColor)),
          icon: Icon(Icons.search , color: whiteColor),
        ),
      ),
    );
  }

  _showAutocomplete() async {
    String placeName;
    var locationBias = LocationBias()
      ..northEastLat = 20.0
      ..northEastLng = 20.0
      ..southWestLat = 0.0
      ..southWestLng = 0.0;

    var locationRestriction = LocationRestriction()
      ..northEastLat = 20.0
      ..northEastLng = 20.0
      ..southWestLng = 0.0
      ..southWestLat = 0.0;

    var country = "PK";

    // Platform messages may fail, so we use a try/catch PlatformException.
    var place = await PluginGooglePlacePicker.showAutocomplete(
        mode: PlaceAutocompleteMode.MODE_OVERLAY,
        countryCode: country,
        typeFilter: TypeFilter.ESTABLISHMENT);
    _place = place;
    _add(LatLng(place.latitude,place.longitude));
    _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(_place.latitude, _place.longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    _goToTheLake();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
      _place = place;
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }


  void _add(LatLng latLng) async {
    var markerIdVal = "${DateTime.now().second}";
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        latLng.latitude,
        latLng.longitude,
      ),
      infoWindow: InfoWindow(title: "", snippet: '*'),
      onTap: () {

      },
    );
    getUserLocation(latLng);
    setState(() {
      markers = Map();
      markers[markerId] = marker;
    });
  }

  getUserLocation(LatLng latLng) async {
    print("${latLng.longitude} ${latLng.latitude} latLng");
    LocationService locationService = LocationService();
    Response geoCode = await locationService.getLocation(latLng.latitude, latLng.longitude);
    print(geoCode.body);
    if(geoCode.statusCode == 200) {
      print("200");
      GeoCoderModel coderModel = GeoCoderModel.fromJson(
          jsonDecode(jsonEncode(geoCode.body)));
      if(coderModel.results != null && coderModel.results!.length > 0 ){
        _place.address  = coderModel.results![0].formattedAddress;
        _place.latitude  = latLng.latitude;
        _place.longitude  = latLng.longitude;
        addressString  = coderModel.results![0].formattedAddress;
        setState(() {});
      }
    }
    /*try {
      Address address = await geoCode.reverseGeocoding(
          latitude: latLng.latitude, longitude: latLng.longitude);
      addressString = "${address.streetAddress}, ${address.postal}";

    }catch(e){

    }*/
  }
}