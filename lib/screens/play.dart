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
          iconTheme: IconThemeData(color: Colors.blue.shade50),
          title: Text(
            'Play',
            style: TextStyle(
              color: Colors.blue.shade300,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blueGrey.shade900,
          toolbarHeight: 32.0,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Colors.blue.shade300,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.timer,
                  color: Colors.blue.shade50,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.watch,
                  color: Colors.blue.shade50,
                ),
              ),
            ],
          ),
        ),
	backgroundColor: Colors.green.shade900,
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
