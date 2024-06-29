import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:math';

import '../services/game.dart';

class GamesOverview extends StatelessWidget{
  final String title;
  final List<Game> games;
  const GamesOverview({super.key, required this.title, required this.games});

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
	Text(
	  '${title}',
	  style: Theme.of(context).textTheme.titleLarge,
	),
        Builder(
          builder: (context){
            if(games.isEmpty){
              return Text('No games played yet...');
            }
            games.sort((x, y) => x.startTime!.compareTo(y.startTime!));
            Duration gameTimeDur = games.length > 1 ? games.last.startTime!.difference(games.first.startTime!) : Duration(minutes: 1);
            List<FlSpot> gameScoreSpots = games.map((game) => FlSpot(
	      game.startTime!.millisecondsSinceEpoch.toDouble(), 
	      game.score().toDouble(),
	    )).toList();
            return Column(
              children: [
		Row(
		  mainAxisAlignment: MainAxisAlignment.spaceAround,
		  children: [
		    Text('Num Games: ${games.length}'),
		    Text('Avg Score: ${gameListScoreAvg(games).toStringAsFixed(1)}'),
		  ],
		),
		SizedBox(height: 16.0),
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
      ],
    );
  }
}
