import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:math';

import '../services/gps.dart';
import '../services/game.dart';

class GameReviewScreen extends StatefulWidget{
  final Game game;
  const GameReviewScreen({super.key, required this.game});

  @override
  State<GameReviewScreen> createState() => _GameReviewScreen(game: game);
}

class _GameReviewScreen extends State<GameReviewScreen>{
  late Stream<Position> positionStream;
  Position? curPos;
  Game game;

  _GameReviewScreen({required this.game});

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState(){
    super.initState();
    positionStream = getCurrentLocation();
  }

  void updateMap(Position? pos){
    curPos = pos ?? curPos;

    _markers = {
      Marker(
        markerId: MarkerId('start position'),
        position: LatLng(game.startPos!.latitude, game.startPos!.longitude),
      ),
    };
    if(curPos != null){
      _markers.add(Marker(
        markerId: MarkerId('current position'),
        position: LatLng(curPos!.latitude, curPos!.longitude),
      ));
    }
    if(game.endPos != null){
      _markers.add(Marker(
	markerId: MarkerId('end position'),
	position: LatLng(game.endPos!.latitude, game.endPos!.longitude),
      ));
    }
    if(game.solPos != null){
      _markers.add(Marker(
        markerId: MarkerId('solution position'),
        position: LatLng(game.solPos!.latitude, game.solPos!.longitude),
      ));
    }
    
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
              'Game Review', 
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('RL: ${game.radiusLimit}m'),
                Text('TL: ${game.timeLimit}min'),
                Text('Type: ${game.gameType}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Start Time: ${DateFormat.Hms().format(game.startTime!)}'),
                Text('End Time: ${game.solPos != null ? game.startTime!.compareTo(game.endTime!) < 0 ? DateFormat.Hms().format(game.endTime!) : "no submission :(" : "still playing..."}'),
              ],
            ),
            Text(
              'Score: ${game.score()}',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            StreamBuilder<Position>(
              stream: positionStream,
              builder: (context, snapshot){
                updateMap(snapshot.data ?? game.endPos);
		return SizedBox(
		  width: 300,
		  height: 300,
		  child: GoogleMap(
		    mapType: MapType.hybrid,
		    initialCameraPosition: CameraPosition(
		      target: LatLng(game.startPos!.latitude, game.startPos!.longitude),
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
              style: ElevatedButton.styleFrom(
	        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
	  ], 
	),
      ),
    );
  }
}
