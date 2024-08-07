import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './services/auth.dart';
import './wrappers/auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
	title: 'Geoguess irl',
        theme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: Colors.blue.shade50,
            surface: Colors.green.shade700,
            onSurface: Colors.blue.shade50,
            surfaceVariant: Colors.blue.shade700,
            inverseSurface: Colors.blueGrey.shade900,
          ),
          appBarTheme: AppBarTheme(
            foregroundColor: Colors.blue.shade300,
            backgroundColor: Colors.blueGrey.shade900,
	    iconTheme: IconThemeData(
	      color: Colors.blue.shade50,
	    ),
          ),
          tabBarTheme: TabBarTheme(
            dividerColor: Colors.transparent,
            indicatorColor: Colors.blue.shade300,
	    unselectedLabelColor: Colors.blue.shade50,
          ),
          iconTheme: IconThemeData(
            color: Colors.blue.shade50,
          ),
          scaffoldBackgroundColor: Colors.green.shade900,
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              color: Colors.blue.shade300,
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              color: Colors.blue.shade300,
            ),
            titleLarge: TextStyle(
              color: Colors.blue.shade300,
              fontWeight: FontWeight.bold,
            ),
            titleSmall: TextStyle(
              color: Colors.blue.shade300,
            ),
            labelLarge: TextStyle(
              color: Colors.blueGrey.shade300,
            ),
            labelSmall: TextStyle(
              color: Colors.green,
            ),
          ),
          hintColor: Colors.blueGrey.shade300, 
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade50),
            ),
	    focusedBorder: UnderlineInputBorder(
	      borderSide: BorderSide(color: Colors.blue.shade600),
	    ),
          ),
        ),
	home: const AuthWrapper(),
      ),
    );
  }
}
