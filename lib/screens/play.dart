import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/game.dart';
import '../services/auth.dart';
import '../tabs/play_timed.dart';
import './game.dart';

class PlayScreen extends StatefulWidget{
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreen();
}

class _PlayScreen extends State<PlayScreen>{
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Play'),
          toolbarHeight: 32.0,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.timer)),
              Tab(icon: Icon(Icons.watch)),
            ],
          ),
        ),
	body: SafeArea(
          minimum: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: TabBarView(
	    children: [
              PlayTimedTab(),
              PlayTimedTab(),
            ],
	  ),
        ),
      ),
    );
  }
}
