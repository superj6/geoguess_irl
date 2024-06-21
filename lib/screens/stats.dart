import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/game.dart';
import '../services/auth.dart';
import '../components/stats_games_tab.dart';
import './game.dart';
import './game_end.dart';

class StatsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.blue,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.gamepad),
              ),
              Tab(
                icon: Icon(Icons.auto_graph),
              ),
            ],
          ),
        ),
	backgroundColor: Colors.green,
	body: TabBarView(
	  children: [
            StatsTab(),
            StatsTab(),
          ],
	),
      ),
    );
  }
}
