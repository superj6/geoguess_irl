import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'dart:convert';
import 'dart:math';

import './gps.dart';
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
  String gameType;

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
    required this.gameType,
  });

  Game addJson(Map<String, dynamic> json) {
    if(json.containsKey('gameId')) gameId = json['gameId'];
    if(json.containsKey('groupId')) groupId = json['groupId'];
    if(json.containsKey('startPos')) startPos = Position.fromMap(json['startPos']);
    if(json.containsKey('endPos')) endPos = Position.fromMap(json['endPos']);
    if(json.containsKey('solPos')) solPos = Position.fromMap(json['solPos']);
    if(json.containsKey('startTime')) startTime = DateTime.parse(json['startTime']);
    if(json.containsKey('endTime')) endTime = DateTime.parse(json['endTime']);
    return this;
  }

  factory Game.fromJson(Map<String, dynamic> json){
    Game game = Game(
      radiusLimit: json['radiusLimit'],
      timeLimit: json['timeLimit'],
      gameType: json['gameType'],
    );
    return game.addJson(json);
  }

  Duration timeTaken(){
    return endTime!.difference(startTime!);
  }

  double timeRatio(){
    double tTak = timeTaken().inSeconds.toDouble();
    return tTak / (timeLimit * 60);
  }

  double distanceRatio(){
    double dToSol = distanceBetweenPositions(endPos!, solPos!);
    return dToSol / (2 * radiusLimit);
  }

  int timedScore(){
    double dRat = distanceRatio();
    double tRat = timeRatio();
    double score = exp(-tRat) * max(0, cos(dRat * pi)) * 1000;
    return score.ceil(); 
  }

  int completionScore(){
    double dToSol = distanceBetweenPositions(endPos!, solPos!);
    if(dToSol > 25) return 0;
    double tTak = timeTaken().inSeconds.toDouble();
    double score = exp(-tTak / radiusLimit) * 1000;
    return score.ceil();
  }

  int score(){
    if(solPos == null) return -1;
    if(endPos == null) return 0;
    if(gameType == 'timed'){
      return timedScore(); 
    }else if(gameType == 'completion'){
      return completionScore();
    }
    return -1;
  }

  Map<String, dynamic> positionLoc(Position pos){
    return {'latitude': pos.latitude, 'longitude': pos.longitude};
  }

  Future<Game> start(User? currentUser) async{
    final response = await http.post(
      Uri.parse('${gameUrl}/api/game/new'),
      headers: <String, String>{
	'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': currentUser != null ? currentUser.sessionCookie! : '',
      },
      body: jsonEncode(<String, dynamic>{
	'startPos': positionLoc(startPos!),
        'radiusLimit': radiusLimit,
        'timeLimit': timeLimit,
        'gameType': gameType,
      }),
    );

    if (response.statusCode == 200) {
      return addJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to start game');
    }
  }
  
  Future<Game> getGameStats() async{
    final response = await http.get(
      Uri.parse('${gameUrl}/api/game/${gameId}/stats'),
      headers: <String, String>{
      },
    );

    if(response.statusCode == 200){
      return addJson(jsonDecode(response.body)); 
    }else{
      throw Exception('Failed to get user games');
    }
  }

  Future<void> quit() async{
    final response = await http.post(
      Uri.parse('${gameUrl}/api/game/${gameId}/quit'),
      headers: <String, String>{
	'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return; 
    } else {
      throw Exception('Failed to quit game');
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
      throw Exception('Failed to submit game');
    }
  }

  String imageUrl(int direction){
    return '${gameUrl}/api/game/${gameId}/image?direction=${direction}';
  }
}

double gameListScoreAvg(List<Game> games){
  return games.fold(0, (sum, game) => sum + game.score()) / games.length;
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
    throw Exception('Failed to get user games');
  }
}

Future<List<Game>> getUserScores(User currentUser, String username) async{
  final response = await http.get(
    Uri.parse('${gameUrl}/api/user/${username}/scores'),
    headers: <String, String>{
      'Cookie': currentUser.sessionCookie,
    },
  );

  if(response.statusCode == 200){
    return List.from(jsonDecode(response.body).map((data) => Game.fromJson(data))); 
  }else{
    throw Exception('Failed to get user games');
  }
}
