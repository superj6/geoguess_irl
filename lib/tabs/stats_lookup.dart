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

class StatsLookupTab extends StatefulWidget{
  const StatsLookupTab({super.key});

  @override
  State<StatsLookupTab> createState() => _StatsLookupTab();
}

class _StatsLookupTab extends State<StatsLookupTab>{
  late Future<List<Game>> gamesFuture;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();

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
                'User Lookup',
		style: Theme.of(context).textTheme.headlineLarge,
              ),
              Form(
	        key: _formKey,
	        child: Column(
		  children: [
		    TextFormField(
		      scrollPadding: EdgeInsets.only(bottom: 128),
		      keyboardType: TextInputType.number,
		      inputFormatters: <TextInputFormatter>[
			FilteringTextInputFormatter.digitsOnly
		      ],
		      controller: usernameController,
		      decoration: InputDecoration(
			hintText: 'username',
		      ),
		      validator: (String? value) {
			if (value == null || value.isEmpty) {
			  return 'Username required';
			}
			return null;
		      },
		    ),
                    ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){

                        }
                      },
                      child: Text('Get Stats'),
                    ),
		  ],
		),
              ),
              SizedBox(height: 16.0),
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
	],
      ),
    );
  }
}
