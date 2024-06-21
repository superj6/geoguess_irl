import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/game.dart';
import '../services/auth.dart';
import './game.dart';
import './game_end.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.blue,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.gamepad),
              ),
              Tab(
                icon: Icon(Icons.auto_graph),
              ),
            ],
          ),
        ),
	backgroundColor: Colors.green,
	body: TabBarView(
	  children: [
            GameTab(),
            StatsTab(),
          ],
	),
      ),
    );
  }
}

class GameTab extends StatelessWidget{
  GameTab({super.key});
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController timeLimitController = TextEditingController();
  TextEditingController radiusLimitController = TextEditingController();   

  void startGame(BuildContext context, int timeLimit, int radiusLimit){
    Game game = Game(
      timeLimit: timeLimit, 
      radiusLimit: radiusLimit, 
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(game: game))
    );
  }

  @override
  Widget build(BuildContext context){
    User currentUser = context.watch<UserProvider>().currentUser!;
    return Center(
      child: SingleChildScrollView(
	child: Column(
	  mainAxisAlignment: MainAxisAlignment.center,
	  children: [
	    Text(
	      'Hello ${currentUser.username}',
	      style: TextStyle(
		fontSize: 40,
	      ),
	    ),
	    Text(
	      'Play a game!'
	    ),
	    GridView.count(
	      shrinkWrap: true,
	      primary: false,
	      padding: const EdgeInsets.all(20),
	      crossAxisSpacing: 10,
	      mainAxisSpacing: 10,
	      crossAxisCount: 3,
	      children: [
		(1, 125), (5, 250), (10, 250),
		(10, 500), (15, 500), (20, 500),
		(10, 1000), (20, 1000), (30, 1000),
	      ].map((rec){
		var (timeLimit, radiusLimit) = rec;
		return SizedBox(
		  width: 125,
		  height: 125,
		  child: ElevatedButton(
		    style: ElevatedButton.styleFrom(
		      padding: EdgeInsets.zero,
		      shape: RoundedRectangleBorder(
			borderRadius: BorderRadius.zero,
		      ),
		    ),
		    onPressed: () => startGame(context, timeLimit, radiusLimit),
		    child: Text('${timeLimit} ${radiusLimit}'),
		  ),
		);
	      }).toList(),
	    ),
	    Form(
	      key: _formKey,
	      child: Column( 
		children: [
		  Column(
		    children: [
		      TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: 128),
			keyboardType: TextInputType.number,
			inputFormatters: <TextInputFormatter>[
			  FilteringTextInputFormatter.digitsOnly
			],
			controller: timeLimitController,
			decoration: const InputDecoration(
			  hintText: 'Time Limit',
			),
			validator: (String? value) {
			  if (value == null || value.isEmpty) {
			    return 'Time limit required';
			  }
			  return null;
			},
		      ),
		      TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: 64),
			keyboardType: TextInputType.number,
			inputFormatters: <TextInputFormatter>[
			  FilteringTextInputFormatter.digitsOnly
			],
			controller: radiusLimitController,
			decoration: const InputDecoration(
			  hintText: 'Radius Limit',
			),
			validator: (String? value) {
			  if (value == null || value.isEmpty) {
			    return 'Radius limit required';
			  }
			  return null;
			},
		      ),
		    ],
		  ),
		  ElevatedButton(
		    onPressed: (){
		      if (_formKey.currentState!.validate()) {
			int timeLimit = int.parse(timeLimitController.text);
			int radiusLimit = int.parse(radiusLimitController.text);
			startGame(context, timeLimit, radiusLimit);
		      }
		    },
		    child: Text('Custom'),
		  ),
		],
	      ),
	    ),
            TextButton(
              onPressed: (){
                context.read<UserProvider>().logoutUser();
              },
              child: Text('Logout'),
            ),
	  ],
	),
      ),
    );
  }
}


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
