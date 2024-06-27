import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../services/game.dart';
import '../services/auth.dart';
import '../screens/game_end.dart';

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
    return Column(
      children: [
	Text(
	  'stats',
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
            return ListView.builder(
              reverse: true,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: games.length,
              itemBuilder: (context, index){
                Game game = games[index];
                return TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameEndScreen(game: game)),
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
			    Text('${DateFormat.yMd().add_Hm().format(game.startTime!)}'),
			    Text('Score: 69'),
			  ],
			),
			Row(
			  mainAxisAlignment: MainAxisAlignment.spaceBetween,
			  children: [
			    Text('TL: ${game.timeLimit!}min'), 
			    Text('RL: ${game.radiusLimit!}m'),
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
    );
  }
}
