import 'package:geolocator/geolocator.dart';

Stream<Position> getCurrentLocation(){
  Geolocator.requestPermission();
  return Geolocator.getPositionStream();
}
