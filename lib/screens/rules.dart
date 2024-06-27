import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget{
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
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
            Column(
              children: [
		Text.rich(
		  TextSpan(
		    children: [
		      TextSpan(
			text: 'There are two game modes you can play: '
		      ),
		      TextSpan(
			text: 'Timed',
			style: TextStyle(fontWeight: FontWeight.bold),
		      ),
		      TextSpan(
			text: ' and '
		      ),
		      TextSpan(
			text: 'Completion',
			style: TextStyle(fontWeight: FontWeight.bold),
		      ),
		      TextSpan(
			text: '. In both of these game modes you select a playing radius, are given Google Earth images from a random location within this radius, and are tasked with finding the location closest to the images given irl. You must physically walk to the guessed location and your submission is based off your final gps location.'
		      ),
		    ],
		  ),
		),
                SizedBox(height: 4.0),
                Text(
                  'Your are only able to cancel the game within the first 15sec of starting. Information on the differences between game modes is below.'
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              children: [
                Text(
                  'Timed',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'In this mode you have a time limit that you must give your best guess within. Your score is based only on the distance between the guessed location and actual image location.'
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              children: [
                Text(
                  'Completion',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'In this mode you have unlimitted time, but you must reach the exact location the provided image came from. Your score is based only on the amount of time it took to reach the location.'
                ),
              ],
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
