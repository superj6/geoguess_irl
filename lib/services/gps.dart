import 'package:geolocator/geolocator.dart';

Stream<Position> getCurrentLocation(){
  Geolocator.requestPermission();
  return Geolocator.getPositionStream();
}

double distanceBetweenPositions(Position x, Position y){
  return Geolocator.distanceBetween(x.latitude, x.longitude, y.latitude, y.longitude);
}
