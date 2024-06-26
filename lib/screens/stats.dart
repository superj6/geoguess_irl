import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/game.dart';
import '../services/auth.dart';
import './stats_games_tab.dart';
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
          title: Text('Stats'),
          toolbarHeight: 32.0,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.people),
              ),
            ],
          ),
        ),
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
