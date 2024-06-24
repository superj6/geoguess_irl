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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green.shade900,
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        forceMaterialTransparency: true,
        iconTheme: IconThemeData(
          color: Colors.blue.shade50,
        ),
      ),
      body: SafeArea(
        child: Column(
	  children: [
	    Text(
              'Create Account', 
              style: TextStyle(
                color: Colors.blue.shade300,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
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
                      style: TextStyle(color: Colors.blueGrey.shade300),
                    ),
		    TextFormField(
                      autofocus: true,
                      controller: usernameController,
                      style: TextStyle(color: Colors.blue.shade50),
                      cursorColor: Colors.green.shade700,
		      decoration: InputDecoration(
			hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.blueGrey.shade300),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade600),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade700,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blueGrey.shade300,
                        ),
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
		      style: TextStyle(color: Colors.blue.shade50),
                      cursorColor: Colors.green.shade700,
		      decoration: InputDecoration(
			hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.blueGrey.shade300),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade600),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade700,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.blueGrey.shade300,
                        ),
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
		      style: TextStyle(color: Colors.blue.shade50),
                      cursorColor: Colors.green.shade700,
		      decoration: InputDecoration(
			hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.blueGrey.shade300),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade600),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade700,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.blueGrey.shade300,
                        ),
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
		      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.blue.shade50),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.green.shade700),
                      ),
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
