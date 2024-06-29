import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:math';

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
                  Duration gameTimeDur = games.last.startTime!.difference(games.first.startTime!);
                  return Column(
                    children: [
                      Builder(
                        builder: (context){
                          List<Game> timedGames = games.where((game) => game.gameType == 'timed').toList();
                          List<FlSpot> gameScoreSpots = timedGames.map((game) => FlSpot(
                            game.startTime!.millisecondsSinceEpoch.toDouble(), 
                            game.score().toDouble(),
                          )).toList();
                          return Column(
			    children: [
			      Text(
				'Timed',
				style: Theme.of(context).textTheme.titleLarge,
			      ),
			      Row(
				mainAxisAlignment: MainAxisAlignment.spaceAround,
				children: [
				  Text('Num Games: ${timedGames.length}'),
				  Text('Avg Score: ${gameListScoreAvg(timedGames)}'),
				],
			      ),
                              SizedBox(height: 8.0),
		              Container(
                                margin: EdgeInsets.only(right: 12.0), 
				height: 178.0,
				child: LineChart(
				  LineChartData(

                                    baselineX: games.first.startTime!.millisecondsSinceEpoch.toDouble(),
                                    minX: games.first.startTime!.millisecondsSinceEpoch.toDouble(),
                                    maxX: games.last.startTime!.millisecondsSinceEpoch.toDouble(),
				    minY: 0,
				    maxY: 1000, 
				    gridData: FlGridData(
				      verticalInterval: gameTimeDur.inMilliseconds / 4,
                                      horizontalInterval: 1000 / 4,
				    ),
				    titlesData: FlTitlesData(
				      topTitles: AxisTitles(
					sideTitles: SideTitles(showTitles: false),
				      ),
				      rightTitles: AxisTitles(
					sideTitles: SideTitles(showTitles: false),
				      ),
                                      bottomTitles: AxisTitles(
					sideTitles: SideTitles(
					  showTitles: true,
                                          interval: gameTimeDur.inMilliseconds / 2,
					  getTitlesWidget: (value, meta){
                                            return SideTitleWidget(
                                              axisSide: meta.axisSide,
                                              child: Text(
                                                '${DateFormat("M/d/yy").format(DateTime.fromMillisecondsSinceEpoch(value.toInt()))}',
                                              ),
                                              space: 4.0,
                                              fitInside: SideTitleFitInsideData.fromTitleMeta(
                                                meta,
                                                distanceFromEdge: -12.0,
                                              ),
                                            );
                                          },
					),
				      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 1000 / 2,
                                          reservedSize: 48.0,
                                          getTitlesWidget: (value, meta){
                                            return SideTitleWidget(
                                              axisSide: meta.axisSide,
                                              child: Text('${value.toInt()}'),
                                              space: 4.0,
                                              fitInside: SideTitleFitInsideData.fromTitleMeta(
                                                meta,
                                                distanceFromEdge: -6.0,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
				    ),
				    lineBarsData: [
				      LineChartBarData(
					spots: gameScoreSpots,
				      ),
				    ],
				  ),
                                ),
                              ),
			    ],
		          );
                        },
                      ),
                      SizedBox(height: 8.0),
                      Builder(
                        builder: (context){
                          List<Game> completionGames = games.where((game) => game.gameType == 'completion').toList();
                          return Column(
			    children: [
			      Text(
				'Completion',
				style: Theme.of(context).textTheme.titleLarge,
			      ),
			    ],
		          );
                        },
                      ),
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
