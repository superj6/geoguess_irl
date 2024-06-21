import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/game.dart';
import '../services/auth.dart';
import '../components/play_timed_tab.dart';
import './game.dart';
import './game_end.dart';

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
          title: Text('Play Game'),
          backgroundColor: Colors.blue,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.timer),
              ),
              Tab(
                icon: Icon(Icons.watch),
              ),
            ],
          ),
        ),
	backgroundColor: Colors.green,
	body: TabBarView(
	  children: [
            PlayTimedTab(),
            PlayTimedTab(),
          ],
	),
      ),
    );
  }
}
