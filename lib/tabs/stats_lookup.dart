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
  String? username;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();

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
                          setState((){
                            username = usernameController.text;
                          });
                        }
                      },
                      child: Text('Get Stats'),
                    ),
		  ],
		),
              ),
              SizedBox(height: 16.0),
	      Builder(
		builder: (context){
		  if(username == null){
		    return Text('Search by username to see stats.');
		  }

                  User currentUser = context.read<UserProvider>().currentUser!;
                  Future<List<Game>> gamesFuture = getUserScores(currentUser, username!);
                  return Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          style: Theme.of(context).textTheme.headlineLarge,
                          children: [
                            TextSpan(
                              text: '${username}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            TextSpan(
                              text: "'s Overview",
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<List<Game>>(
                        future: gamesFuture,
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
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
