import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:math';

import '../services/auth.dart';
import '../services/gps.dart';
import '../services/game.dart';
import './game_review.dart';

class GameScreen extends StatefulWidget{
  final Game game;
  const GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreen(game: game);
}

class _GameScreen extends State<GameScreen>{
  late Stream<Position> positionStream;
  Completer<Game> gameFuture = Completer<Game>();
  Position? curPos;
  Game game;

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  _GameScreen({required this.game});

  @override
  void initState(){
    super.initState();
    User? currentUser = context.read<UserProvider>().currentUser;
    
    positionStream = getCurrentLocation();
    positionStream.first.then((pos){
      _controller.future.then((controller){
        var curCamPos = CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: log(500.0 * pow(2, 15) / game.radiusLimit) / log(2),
        );
        controller.animateCamera(CameraUpdate.newCameraPosition(curCamPos));  
      });

      game.startPos = pos;
      gameFuture.complete(game.start(currentUser));
    });
  }

  void updateMap(Position pos){
    if(game.startPos == null) game.startPos = pos;
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
    };
    
    _circles = {
      Circle(
	circleId: CircleId('game circle'),
	center: LatLng(game.startPos!.latitude, game.startPos!.longitude), 
	radius: game.radiusLimit.toDouble(),
      ),
    };
  }


  void quitGame(context){
    gameFuture.future.then((_){
      game.quit().then((_){
        Navigator.pop(context);
      });
    });
  }

  void finishGame(context){
    gameFuture.future.then((_){
      game.submit(curPos!).then((_){
	Navigator.pushReplacement(
	  context,
	  MaterialPageRoute(builder: (context) => GameReviewScreen(game: game)),
	);
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: EdgeInsets.only(top: 32.0),
        child: Column(
	  children: [
            SizedBox(height: 16.0),
	    Text(
              'Game Started!', 
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
            FutureBuilder<Game>(
	      future: gameFuture.future,
	      builder: (context, snapshot) {
		if(!snapshot.hasData){
		  return Column(
		    children: [
		      Text('Loading...'),
		      SizedBox(
			width: 300,
			height: 300,
			child: CircularProgressIndicator(),
		      ),
		    ],
		  );
		}
		return Column(
		  children: [
                    Row(
		      mainAxisAlignment: MainAxisAlignment.center,
		      children: [
			Text('Time left: '),
			TimerCountdown(
			  format: CountDownTimerFormat.minutesSeconds,
			  endTime: DateTime.now().add(Duration(minutes: game.timeLimit)),
			  enableDescriptions: false,
			  spacerWidth: 0,
                          onEnd: (){
                            game.getGameStats().then((_){
			      Navigator.pushReplacement(
				context,
				MaterialPageRoute(builder: (context) => GameReviewScreen(game: game)),
			      );
                            });
                          },
			),
		      ],
		    ),
		    CarouselSlider(
		      options: CarouselOptions(height: 300.0),
		      items: [0, 90, 180, 270].map((i){ 
			return GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => 
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
				  child: InteractiveViewer(
                                    minScale: 1,
                                    maxScale: 4,
				    child: Hero(
				      tag: 'streetImage ${i}',
                                      child: Image.network(
                                        game.imageUrl(i),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
				  ),
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'streetImage ${i}',
                            child: Image.network(game.imageUrl(i)),
                          ),
                        );
		      }).toList(),
		    ),
		  ],
		);
	      },
	    ),
            SizedBox(height: 16.0),
            StreamBuilder<Position>(
              stream: positionStream,
              builder: (context, snapshot){
                if(snapshot.hasData) updateMap(snapshot.data!);
		return SizedBox(
		  width: 300,
		  height: 300,
		  child: GoogleMap(
		    mapType: MapType.hybrid,
		    initialCameraPosition: CameraPosition(
		      target: LatLng(0, 0),
		      zoom: 1,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
		ElevatedButton(
		  onPressed: () => finishGame(context),
		  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
		    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
		  ),
		),
		FutureBuilder(
		  future: gameFuture.future.then((game){
                    Duration durTime = DateTime.now()
                        .add(Duration(seconds: 15))
                        .difference(DateTime.now());
                    return Future.delayed(durTime);
                  }),
		  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return ElevatedButton(
                        onPressed: () => quitGame(context),
                        child: Text('Quit'),
                      );
                    } 
                               
		    return ElevatedButton(
		      onPressed: (){},
		      child: Text('Quit'),
                      style: ElevatedButton.styleFrom(
		        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
		      ),
		    );
                  },
		),
              ],
            ),
	  ], 
	),
      ),
    );
  }
}
