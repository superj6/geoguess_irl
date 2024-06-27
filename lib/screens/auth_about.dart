import 'package:flutter/material.dart';

import './rules.dart';

class AuthAboutScreen extends StatelessWidget{
  const AuthAboutScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.0),
	child: Column(
	  crossAxisAlignment: CrossAxisAlignment.center,
	  children: [
	    Column(
	      children: [
		Text(
		  'Geoguess irl',
		  style: Theme.of(context).textTheme.headlineLarge, 
		),
		Text(
		  'What is it?',
		  style: Theme.of(context).textTheme.headlineSmall,
		),
	      ],
	    ),
            SizedBox(height: 16.0),
	    Column(
	      children: [
		Text.rich(
		  TextSpan(
		    children: [
		      TextSpan(
			text: 'Geoguess irl',  
			style: TextStyle(fontWeight: FontWeight.bold),
		      ),
		      TextSpan(
			text: ' is a game very similar in spirit to the well known game ',
		      ),
		      TextSpan(
			text: 'Geoguessr',
			style: TextStyle(fontWeight: FontWeight.bold),
		      ),
		      TextSpan(
			text: ' in which the player is given pictures of a location from Google Earth and then challenged to mark where the picture came from.',
		      ),
		    ],
		  ),
		),
                SizedBox(height: 4.0),
	        Text.rich(
		  TextSpan(
		    children: [
		      TextSpan(
			text: 'However, as the name suggests, ',
		      ),
		      TextSpan(
			text: 'Geoguess irl',  
			style: TextStyle(fontWeight: FontWeight.bold),
		      ),
		      TextSpan(
			text: ' differs in that the player has to perform actions irl. Specifically, in this game the player is given a picture from Google Earth within a radius relative to them, and then they are tasked to find this location irl by physically walking to the guessed location.',
		      ),
		    ],
		  ),
		),
	      ],
	    ),
            SizedBox(height: 16.0),
            Text(
              'It is recommended to create an account in order to track your stats over time and see how you compare to other players. However, you can also play anonymously from the authentication screen. You can also view more comprehensive rules below.'
            ),
            SizedBox(height: 16.0),
            SizedBox(
	      width: 216.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
		children: [
		  ElevatedButton(
		    onPressed: (){
                      Navigator.pop(context);
                    },
		    child: Text('Back to Auth'), 
                    style: ElevatedButton.styleFrom(
		      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
		    ),
		  ),
		  ElevatedButton(
		    onPressed: (){
                      Navigator.push(
			context,
			MaterialPageRoute(builder: (context) => RulesScreen()),
		      ); 
                    },
		    child: Text('Rules'),
		  ),
		],
              ),
            ),
	  ],
	),
      ),
    );
  }
}
