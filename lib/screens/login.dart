import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({ super.key });

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
	  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
	  children: [
	    Text(
              'Welcome Back!', 
              style: TextStyle(
                color: Colors.blue,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
	      child: Form(
		key: _formKey,
		child: Column(
		  crossAxisAlignment: CrossAxisAlignment.stretch,
		  children: [
		    TextFormField(
                      autofocus: true,
                      controller: usernameController,
		      decoration: const InputDecoration(
			hintText: 'Username',
		      ),
		      validator: (String? value) {
			if (value == null || value.isEmpty) {
			  return 'Please enter your username';
			}
			return null;
		      },
		    ),
                    SizedBox(height: 10),
		    TextFormField(
                      controller: passwordController,
                      obscureText: true,
		      enableSuggestions: false,
		      autocorrect: false,
		      decoration: const InputDecoration(
			hintText: 'Password',
		      ),
		      validator: (String? value) {
			if (value == null || value.isEmpty) {
			  return 'Please enter your password';
			}
			return null;
		      },
		    ),
                    SizedBox(height: 10),
		    ElevatedButton(
		      onPressed: () {
			if (_formKey.currentState!.validate()) {
                          context.read<UserProvider>().loginUser(
                            username: usernameController.text,
                            password: passwordController.text,
                          ).then((_) => Navigator.pop(context));
			}
		      },
		      child: const Text('Login'),
		    ),
		  ],
		),
	      ),
            ),
            SizedBox(),
            SizedBox(),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('Go back.'),
            ),
	  ], 
	),
      ),
    );
  }
}
