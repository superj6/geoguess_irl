import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:math';

import '../components/games_overview.dart';
import '../services/game.dart';
import '../services/auth.dart';
import '../screens/game_review.dart';

class StatsSelfTab extends StatefulWidget{
  const StatsSelfTab({super.key});

  @override
  State<StatsSelfTab> createState() => _StatsSelfTab();
}

class _StatsSelfTab extends State<StatsSelfTab>{
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
                  
                  List<Game> timedGames = games.where((game) => game.gameType == 'timed').toList();
                  List<Game> completionGames = games.where((game) => game.gameType == 'completion').toList();
                  return Column(
                    children: [
                      GamesOverview(title: 'Timed', games: timedGames),
                      SizedBox(height: 8.0),
                      GamesOverview(title: 'Completion', games: completionGames),
                    ],
                  );  
                },
              ),
            ],
          ),
          SizedBox(height: 32.0),
          Column(
            children: [
	      Text(
		'Games',
		style: Theme.of(context).textTheme.headlineLarge,
	      ), 
	      Text('Click to view more details.'),
              SizedBox(height: 8.0),
	      FutureBuilder<List<Game>>(
		future: gamesFuture,
		builder: (context, snapshot){
		  if(!snapshot.hasData){
		    return CircularProgressIndicator();
		  }
		  
                  List<Game> games = snapshot.data!;
                  if(games.isEmpty){
                    return Text('No games played yet...');
                  }

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
			  width: 256.0,
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
