import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/game.dart';
import '../services/auth.dart';
import '../screens/game_review.dart';

class StatsTab extends StatefulWidget{
  const StatsTab({super.key});

  @override
  State<StatsTab> createState() => _StatsTab();
}

class _StatsTab extends State<StatsTab>{
  late Future<List<Game>> gamesFuture;

  @override 
  void initState(){
    super.initState();
    User currentUser = context.read<UserProvider>().currentUser!;
    gamesFuture = getUserGames(currentUser);
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
	children: [
          Column(
            children: [
              Text(
                'Overview',
		style: Theme.of(context).textTheme.headlineLarge,
              ),
	      FutureBuilder<List<Game>>(
		future: gamesFuture,
		builder: (context, snapshot){
		  if(!snapshot.hasData){
		    return CircularProgressIndicator();
		  }
		  List<Game> games = snapshot.data!;
		  games.sort((x, y) => x.startTime!.compareTo(y.startTime!));
                  return Column(
                    children: [
                      Row(

                      ),
                    ],
                  ),  
                },
              );
            ],
          ),
          Column(
            children: [
	      Text(
		'Previous Games',
		style: Theme.of(context).textTheme.headlineLarge,
	      ), 
	      Text('Click to view more details.'),
	      FutureBuilder<List<Game>>(
		future: gamesFuture,
		builder: (context, snapshot){
		  if(!snapshot.hasData){
		    return CircularProgressIndicator();
		  }
		  List<Game> games = snapshot.data!;
		  games.sort((x, y) => x.startTime!.compareTo(y.startTime!));
		  return ListView.builder(
		    reverse: true,
		    scrollDirection: Axis.vertical,
		    shrinkWrap: true,
		    physics: const NeverScrollableScrollPhysics(),
		    itemCount: games.length,
		    itemBuilder: (context, index){
		      Game game = games[index];
		      return TextButton(
			onPressed: (){
			  Navigator.push(
			    context,
			    MaterialPageRoute(builder: (context) => GameReviewScreen(game: game)),
			  );
			},
			child: SizedBox(
			  width: 216.0,
			  child: Column(
			    children: [
			      Text(
				'Game ${index + 1}',
				style: Theme.of(context).textTheme.titleSmall,
			      ),
			      Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
				  Text('Date: ${DateFormat.yMd().format(game.startTime!)}'),
                                  Text('Type: ${game.gameType}'),
                                ],
			      ),
			      Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
				  Text('TL: ${game.timeLimit}min'), 
				  Text('RL: ${game.radiusLimit}m'),
				  Text('Score: ${game.score()}'),
				],
			      ),
			    ],
			  ),
			),
		      );
		    },
		  );
		},
	      ),
            ],
          ),
	],
      ),
    );
  }
}
