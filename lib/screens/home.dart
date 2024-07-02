import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';

import './play.dart';
import './stats.dart';
import './rules.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    User currentUser = context.watch<UserProvider>().currentUser!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/earth_moon_background.jpg'),        
            fit: BoxFit.cover,
          ),
        ),
	child: SafeArea(
	  minimum: EdgeInsets.symmetric(horizontal: 16.0),
	  child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
	    crossAxisAlignment: CrossAxisAlignment.center,
	    children: [
              Column(
	        children: [
                  Text(
                    'Geoguess irl',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text.rich(
                    TextSpan(
		      style: Theme.of(context).textTheme.headlineSmall,
                      children: [
                        TextSpan(text: 'Hello '),
                        TextSpan(
                          text: '${currentUser.username!}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' :)'),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
		crossAxisAlignment: CrossAxisAlignment.stretch,
		children: [
		  ElevatedButton(
		    onPressed: (){
		      Navigator.push(
			context,
			MaterialPageRoute(builder: (context) => PlayScreen()),
		      );
		    }, 
		    child: Text('Play'),
		    style: ElevatedButton.styleFrom(
		      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
		    ),
		  ),
		  ElevatedButton(
		    onPressed: (){ 
		      Navigator.push(
			context,
			MaterialPageRoute(builder: (context) => StatsScreen()),
		      );
		    }, 
		    child: Text('Stats'),
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
              SizedBox(),
              SizedBox(),
              TextButton(
                onPressed: (){
                  context.read<UserProvider>().logoutUser(); 
                },
                child: Text(
                  'logout :(',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
	    ],
	  ),
	),
      ),
    );
  }
}
