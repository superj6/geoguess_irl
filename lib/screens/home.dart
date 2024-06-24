import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';

import './play.dart';
import './stats.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    User currentUser = context.watch<UserProvider>().currentUser!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/earth_moon_background.jpg'),        
            fit: BoxFit.cover,
          ),
        ),
	child: SafeArea(
	  child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
	    crossAxisAlignment: CrossAxisAlignment.center,
	    children: [
              Column(
	        children: [
                  Text(
                    'Geoguess irl',
                    style: TextStyle(
		      color: Colors.blue.shade300,
		      fontSize: 50,
		      fontWeight: FontWeight.bold,
		    ), 
                  ),
                  RichText(
                    text: TextSpan(
		      style: TextStyle(
			color: Colors.blue.shade300,
		      ),
                      children: [
                        TextSpan(text: 'Hello '),
                        TextSpan(
                          text: '${currentUser.username!}',
                          style: TextStyle(
                            color: Colors.blue.shade50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' :)'),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
		child: Column(
		  crossAxisAlignment: CrossAxisAlignment.stretch,
		  children: [
		    ElevatedButton(
		      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlayScreen()),
                        );
                      }, 
		      child: Text(
                        'Play',
                        style: TextStyle(
                          color: Colors.blue.shade50,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue.shade700),
                      ),
		    ),
		    ElevatedButton(
		      onPressed: (){ 
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StatsScreen()),
                        );
                      }, 
		      child: Text(
                        'Stats',
                        style: TextStyle(
                          color: Colors.blue.shade50,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.green.shade700),
                      ),
		    ),
		    ElevatedButton(
		      onPressed: (){
                      
                      }, 
		      child: Text(
                        'Rules',
                        style: TextStyle(
                          color: Colors.blue.shade50,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.green.shade700),
                      ),
		    ),
		  ],
		),
              ),
              SizedBox(),
              SizedBox(),
              TextButton(
                onPressed: (){
                  context.read<UserProvider>().logoutUser(); 
                },
                child: Text(
                  'logout :(',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
	    ],
	  ),
	),
      ),
    );
  }
}
