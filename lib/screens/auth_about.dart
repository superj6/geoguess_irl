import 'package:flutter/material.dart';


class AuthAboutScreen extends StatelessWidget{
  const AuthAboutScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/earth_background.jpg'),        
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
		      color: Colors.blue,
		      fontSize: 50,
		      fontWeight: FontWeight.bold,
		    ), 
                  ),
                  Text(
                    'Explore your own world.',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                  'Go back.',
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
