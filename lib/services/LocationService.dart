import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:get/get.dart';

class LocationService extends GetConnect{

  Future<Response> getLocation(latitude, longitude){
    return get("https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyC8kRImPuX2uzBQCU9Q1pD68fSjZuBUJMQ");
  }

}