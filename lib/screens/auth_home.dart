import 'package:flutter/material.dart';

import './login.dart';
import './register.dart';
import './auth_about.dart';
import './play.dart';

class AuthHomeScreen extends StatelessWidget{
  const AuthHomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
		      color: Colors.blue.shade300,
		      fontSize: 50,
		      fontWeight: FontWeight.bold,
		    ), 
                  ),
                  Text(
                    'Explore your world.',
                    style: TextStyle(
                      color: Colors.blue.shade300,
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
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      }, 
		      child: Text(
                        'Login',
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
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
		      child: Text(
                        'Register',
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
	      ElevatedButton(
		onPressed: (){
		  Navigator.push(
		    context,
		    MaterialPageRoute(builder: (context) => PlayScreen()),
		  );
		},
		child: Text(
		  'Play Anonymous',
		  style: TextStyle(
		    color: Colors.blue.shade50,
		  ),
		),
		style: ButtonStyle(
		  backgroundColor: MaterialStatePropertyAll<Color>(Colors.green.shade700),
		),
	      ),
              SizedBox(),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthAboutScreen()),
                  );
                },
                child: Text(
                  'What is this app?',
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
