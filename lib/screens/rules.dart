import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget{
  const RulesScreen({super.key});

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
	    Text(
	      'Rules',
	      style: Theme.of(context).textTheme.headlineLarge, 
	    ),
            SizedBox(height: 16.0),
            Text(
              'There are two game modes you can play: Timed and Completion. In both of these game modes you select a playing radius, are given images from a random location within this radius, and are tasked with finding the location closes to the images given irl. You must physically walk to the guessed location and your submission is based off your final gps locationi.'
            ),
            SizedBox(height: 16.0),
	    ElevatedButton(
	      onPressed: (){
		Navigator.pop(context);
	      },
	      child: Text('Go Back'), 
	      style: ElevatedButton.styleFrom(
		backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
	      ),
	    ),
	  ],
	),
      ),
    );
  }
}
