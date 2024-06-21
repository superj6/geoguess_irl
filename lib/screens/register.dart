import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({ super.key });

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();  
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
	  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
	  children: [
	    Text(
              'Create Account', 
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
                      obscureText: true,
		      enableSuggestions: false,
		      autocorrect: false,
                      controller: passwordController,
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
		    TextFormField(
                      obscureText: true,
		      enableSuggestions: false,
		      autocorrect: false,
                      controller: confirmPasswordController,
		      decoration: const InputDecoration(
			hintText: 'Confirm Password',
		      ),
		      validator: (String? value) {
			if (value == null || value.isEmpty || passwordController.text != confirmPasswordController.text) {
			  return 'Please enter the same password again';
			}
			return null;
		      },
		    ),
                    SizedBox(height: 10),
		    ElevatedButton(
		      onPressed: () {
			if (_formKey.currentState!.validate()) {
                          context.read<UserProvider>().registerUser(
                            username: usernameController.text,
                            password: passwordController.text,
                          ).then((_) => Navigator.pop(context));
			}
		      },
		      child: const Text('Register'),
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
