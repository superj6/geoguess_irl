import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'dart:convert';

import './url.dart';
import './auth.dart';

class Game{
  String? gameId;
  String? groupId;
  Position? startPos;
  Position? endPos;
  Position? solPos;
  DateTime? startTime;
  DateTime? endTime;
  int radiusLimit;
  int timeLimit;

  Game({
    this.gameId,
    this.groupId,
    this.startPos,
    this.endPos,
    this.solPos,
    this.startTime,
    this.endTime,
    required this.radiusLimit,
    required this.timeLimit,
  });

  factory Game.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
	'gameId': String gameId,
	'groupId': String groupId,
	'startPos': Map startPos,
	'endPos': Map endPos,
	'solPos': Map solPos,
	'startTime': String startTime,
	'endTime': String endTime,
	'radiusLimit': int radiusLimit,
	'timeLimit': int timeLimit,
      } =>
        Game(
          gameId: gameId,
          groupId: groupId,
          startPos: Position.fromMap(startPos),
          endPos: Position.fromMap(endPos),
          solPos: Position.fromMap(solPos),
          startTime: DateTime.parse(startTime),
          endTime: DateTime.parse(endTime),
          radiusLimit: radiusLimit,
          timeLimit: timeLimit, 
        ),
      _ => throw const FormatException('Failed to load game.'),
    };
  }

  Game addJson(Map<String, dynamic> json) {
    if(json.containsKey('gameId')) gameId = json['gameId'];
    if(json.containsKey('groupId')) groupId = json['groupId'];
    if(json.containsKey('startPos')) startPos = Position.fromMap(json['startPos']);
    if(json.containsKey('endPos')) endPos = Position.fromMap(json['endPos']);
    if(json.containsKey('solPos')) solPos = Position.fromMap(json['solPos']);
    if(json.containsKey('startTime')) startTime = DateTime.parse(json['startTime']);
    if(json.containsKey('endTime')) endTime = DateTime.parse(json['endTime']);
    if(json.containsKey('radiusLimit')) radiusLimit = json['radiusLimit'];
    if(json.containsKey('timeLimit')) timeLimit = json['timeLimit'];
    return this;
  }

  Map<String, dynamic> positionLoc(Position pos){
    return {'latitude': pos.latitude, 'longitude': pos.longitude};
  }

  Future<Game> start(User currentUser) async{
    final response = await http.post(
      Uri.parse('${gameUrl}/api/game/new'),
      headers: <String, String>{
	'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': currentUser.sessionCookie,
      },
      body: jsonEncode(<String, dynamic>{
	'startPos': positionLoc(startPos!),
        'radiusLimit': radiusLimit,
        'timeLimit': timeLimit,
      }),
    );

    if (response.statusCode == 200) {
      return addJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }


  Future<Game> submit(Position curPos) async{
    endPos = curPos;
    final response = await http.post(
      Uri.parse('${gameUrl}/api/game/${gameId}/submit'),
      headers: <String, String>{
	'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
	'endPos': positionLoc(endPos!),
      }),
    );

    if (response.statusCode == 200) {
      return addJson(jsonDecode(response.body)); 
    } else {
      throw Exception('Failed to load album');
    }
  }

  String imageUrl(int direction){
    return '${gameUrl}/api/game/${gameId}/image?direction=${direction}';
  }
}


Future<List<Game>> getUserGames(User currentUser) async{
  final response = await http.get(
    Uri.parse('${gameUrl}/api/user/stats'),
    headers: <String, String>{
      'Cookie': currentUser.sessionCookie,
    },
  );

  if(response.statusCode == 200){
    return List.from(jsonDecode(response.body).map((data) => Game.fromJson(data))); 
  }else{
    throw Exception('Failed to load album');
  }
}
