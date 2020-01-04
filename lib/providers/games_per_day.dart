import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_log/providers/teams.dart';

import '../models/game_info.dart';

class GamesPerDay with ChangeNotifier {
  Map<DateTime, List<GameInfo>> _allGames = {};

  Map<DateTime, List<GameInfo>> _dayGames = {};

  Map<String, dynamic> _gamesData = {};

  Map<DateTime, List<GameInfo>> get allGames {
    return {..._allGames};
  }

  Map<DateTime, List<Object>> get dayGames {
    return {..._dayGames};
  }

  Map<String, dynamic> get gamesData {
    return {..._gamesData};
  }

  Future<void> addGames(List<GameInfo> games) async {
    DateTime date = DateTime.now();
    //String stringDate =  DateFormat.yMd().format(date);
    // set to firebase here
    const url = 'https://indoor-soccer-log.firebaseio.com/games.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'date': date.toIso8601String(),
            'gameInfo': games
                .map((game) => {
                      'id': game.id,
                      'teamOneId': game.team1.id,
                      'teamOneColor': game.team1.color.toString(),
                      'teamOneName': game.team1.teamName,
                      'teamOneGoals': game.team1.goals,
                      'teamTwoId': game.team2.id,
                      'teamTwoColor': game.team2.color.toString(),
                      'teamTwoName': game.team2.teamName,
                      'teamTwoGoals': game.team2.goals,
                      'winnerId': game.winner.id,
                      'winnerColor': game.winner.color.toString(),
                      'winnerName': game.winner.teamName,
                      'winnerGoals': game.winner.goals,
                    })
                .toList(),
          }));
    } catch (error) {
      print(error);
    }
    //_allGames[date] = games;
  }

  Future<void> fetchGameDatesOnly(int day) async {
    const url = 'https://indoor-soccer-log.firebaseio.com/games.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, Object>;
      if (extractedData == null) {
        return;
      }

      extractedData.forEach((k, v) {
        final Map<String, dynamic> dataGame = v as Map<String, dynamic>;
        _gamesData[dataGame['date']] = dataGame['gameInfo'];
      });

      //filterByDayOfThatWeek(day);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetGames() async {
    const url = 'https://indoor-soccer-log.firebaseio.com/games.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final Map<DateTime, List<GameInfo>> games = {};

      final Map<String, Map<String, List<dynamic>>> gamesData = {};

      if (extractedData == null) {
        return;
      }
      extractedData.forEach((gameId, gameInfo) {
        List<GameInfo> gamesInfoList = [];
        String id;
        String winner;
        var tempInfo = gameInfo['gameInfo'] as List<Object>;
        tempInfo.forEach((item) => {
              id = (item as Map<String, Object>)['id'],
              //winner = (item as Map<String, Object>)['winner'],
              //gamesInfoList.add(GameInfo(team1: SingleTeam(id))),
              //id = (item as GameInfo).id,
              //team1 = (item as GameInfo).team1.teamName,
            });

        games[DateTime.parse(gameInfo['date'] as String)] = List<GameInfo>();

        //games[DateTime.parse(gameInfo['date'] as String)] = List.from(gameInfo['gameInfo'] as List<GameInfo>);
      });
      _allGames = games;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void filterDayGames(int dayOfWeek) {
    _allGames.forEach((date, result) {
      if (date.weekday == dayOfWeek) {
        _dayGames[date] = result;
      }
    });
  }

  void filterByDayOfThatWeek(int dayOfWeek) {
    _gamesData.forEach((key, map) {
      var gameMap = map as Map<String, Object>;
      DateTime date = DateTime.parse(gameMap["date"]);
      if (date.weekday == dayOfWeek) {
        var data = (gameMap["gameInfo"] as List<dynamic>);
        print(data[0]);
        data.map((item) => GameInfo(
            id: item['id'],
            team1:
                SingleTeam(item['teamOneId'], Colors.blue, item['teamOneName']),
            team2: SingleTeam(item['teamOneId'], Colors.blue, 'teamName'),
            winner: SingleTeam(item['teamOneId'], Colors.blue, 'teamName')));
      }
    });
  }
}
