import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../components/auth_input_decoration.dart';

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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Column(
	  children: [
	    Text(
              'Create Account', 
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 32.0),
            Padding(
              padding: EdgeInsets.all(16),
	      child: Form(
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
                      obscureText: true,
		      enableSuggestions: false,
		      autocorrect: false,
                      controller: passwordController,
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
		    TextFormField(
                      obscureText: true,
		      enableSuggestions: false,
		      autocorrect: false,
                      controller: confirmPasswordController,
		      decoration: AuthInputDecoration(
			hintText: 'Confirm Password',
                        iconData: Icons.lock_outline,
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
		      child: Text('Register'),
		    ),
		  ],
		),
	      ),
            ),
          ], 
	),
      ),
    );
  }
}
