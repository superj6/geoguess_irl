import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
	  style: TextStyle(
	    fontSize: 40,
	  ),
        ),
        FutureBuilder<List<Game>>(
          future: gamesFuture,
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            List<Game> games = snapshot.data!;
            return ListView.builder(
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
                  child: Text('${game.gameId!}'),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
