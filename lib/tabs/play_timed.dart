import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/game.dart';
import '../services/auth.dart';
import '../screens/game.dart';
import '../screens/game_end.dart';

class PlayTimedTab extends StatelessWidget{
  PlayTimedTab({super.key});
  
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
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 32.0),
      child: Column(
	mainAxisAlignment: MainAxisAlignment.spaceEvenly,
	children: [
	  Column(
	    children: [
	      Text(
		'Timed Game',
		style: Theme.of(context).textTheme.headlineLarge,
	      ),
	      Text(
		'Either pick a predefined time limit/radius pair or enter a custom pair to start.'
	      ),
	    ],
	  ),
	  SizedBox(height: 16.0),
	  GridView.count(
	    shrinkWrap: true,
	    primary: false,
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
		  child: Text('${timeLimit}min ${radiusLimit}m'),
		),
	      );
	    }).toList(),
	  ),
	  SizedBox(height: 16.0),
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
		      decoration: InputDecoration(
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
		      decoration: InputDecoration(
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
		  style: ElevatedButton.styleFrom(
		    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
		  ),
		),
	      ],
	    ),
	  ),
	],
      ),
    );
  }
}

