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
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    'Explore your world.',
                    style: Theme.of(context).textTheme.headlineSmall,
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
		      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
		    ),
		    ElevatedButton(
		      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
		      child: Text('Register'),
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
		child: Text('Play Anonymous'),
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
