import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../components/auth_input_decoration.dart';

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
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
	  children: [
	    Text(
              'Welcome Back!', 
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 32.0),
	    Form(
	      key: _formKey,
	      child: Column(
		crossAxisAlignment: CrossAxisAlignment.stretch,
		children: [
		  Text('Account Information',
		    style: Theme.of(context).textTheme.labelLarge,
		  ),
		  TextFormField(
		    autofocus: true,
		    controller: usernameController,
		    decoration: AuthInputDecoration(
		      hintText: 'Username',
		      iconData: Icons.person,
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
		    decoration: AuthInputDecoration(
		      hintText: 'Password',
		      iconData: Icons.lock,
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
		    child: Text('Login'),
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
