import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/game.dart';
import '../services/auth.dart';
import '../screens/game.dart';

class PlayCompletionTab extends StatelessWidget{
  PlayCompletionTab({super.key});
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController radiusLimitController = TextEditingController();   

  void startGame(BuildContext context, int radiusLimit){
    Game game = Game(
      timeLimit: 60, 
      radiusLimit: radiusLimit,
      gameType: 'completion', 
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(game: game))
    );
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
	mainAxisAlignment: MainAxisAlignment.spaceEvenly,
	children: [
	  Column(
	    children: [
	      Text(
		'Completion Game',
		style: Theme.of(context).textTheme.headlineLarge,
	      ),
	      Text(
		'Either pick a predefined radius or enter a custom radius to start.'
	      ),
	    ],
	  ),
	  SizedBox(height: 16.0),
	  GridView.count(
	    shrinkWrap: true,
	    primary: false,
	    crossAxisSpacing: 10,
	    mainAxisSpacing: 10,
	    crossAxisCount: 2,
	    children: [
	      125, 250,
              500, 1000,
	    ].map((radiusLimit){
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
		  onPressed: () => startGame(context, radiusLimit),
		  child: Text('${radiusLimit}m'),
		),
	      );
	    }).toList(),
	  ),
	  SizedBox(height: 16.0),
	  Form(
	    key: _formKey,
	    child: Column( 
	      children: [
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
		    int radiusLimit = int.parse(radiusLimitController.text);
		    if(radiusLimit < 75){
		      return 'Radius limit must be at least 50';
		    }
		    return null;
		  },
		),
		ElevatedButton(
		  onPressed: (){
		    if (_formKey.currentState!.validate()) {
		      int radiusLimit = int.parse(radiusLimitController.text);
		      startGame(context, radiusLimit);
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

