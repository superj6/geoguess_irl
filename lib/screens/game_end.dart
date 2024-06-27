import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:math';

import '../services/gps.dart';
import '../services/game.dart';

class GameEndScreen extends StatefulWidget{
  final Game game;
  const GameEndScreen({super.key, required this.game});

  @override
  State<GameEndScreen> createState() => _GameEndScreen(game: game);
}

class _GameEndScreen extends State<GameEndScreen>{
  late Stream<Position> positionStream;
  Position? curPos;
  Game game;

  _GameEndScreen({required this.game});

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState(){
    super.initState();
    positionStream = getCurrentLocation();
  }

  void updateMap(Position pos){
    curPos = pos;

    _markers = {
      Marker(
        markerId: MarkerId('start position'),
        position: LatLng(game.startPos!.latitude, game.startPos!.longitude),
      ),
      Marker(
        markerId: MarkerId('current position'),
        position: LatLng(curPos!.latitude, curPos!.longitude),
      ),
      Marker(
        markerId: MarkerId('end position'),
        position: LatLng(game.endPos!.latitude, game.endPos!.longitude),
      ),
      Marker(
        markerId: MarkerId('solution position'),
        position: LatLng(game.solPos!.latitude, game.solPos!.longitude),
      ),
    };
    
    _circles = {
      Circle(
	circleId: CircleId('game circle'),
	center: LatLng(game.startPos!.latitude, game.startPos!.longitude), 
	radius: game.radiusLimit.toDouble(),
      ),
    };
  }

  void goHome(context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(top: 32.0),
        child: Column(
	  children: [
            SizedBox(height: 16.0),
	    Text(
              'Game Ended!', 
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Radius Limit: ${game.radiusLimit}m'),
                Text('Time Limit: ${game.timeLimit}min'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Start Time: ${DateFormat("hh:mm:ss").format(game.startTime!)}'),
                Text('End Time: ${DateFormat("hh:mm:ss").format(game.endTime!)}'),
              ],
            ),
            SizedBox(height: 16.0),
            StreamBuilder<Position>(
              stream: positionStream,
              builder: (context, snapshot){
                updateMap(snapshot.data ?? game.endPos!);
		return SizedBox(
		  width: 300,
		  height: 300,
		  child: GoogleMap(
		    mapType: MapType.hybrid,
		    initialCameraPosition: CameraPosition(
		      target: LatLng(game.startPos!.latitude, game.endPos!.longitude),
		      zoom: log(500.0 * pow(2, 15) / game.radiusLimit) / log(2),
		    ),
		    markers: _markers,
                    circles: _circles,
		    onMapCreated: (GoogleMapController controller) {
		      _controller.complete(controller);
		    },
		  ),
		);
              }
            ),
            ElevatedButton(
              onPressed: () => goHome(context),
              child: Text('Finish'),
            ),
	  ], 
	),
      ),
    );
  }
}
