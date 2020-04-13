import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/game_info.dart';
import '../models/single_team.dart';

class GamesPerDay with ChangeNotifier {
  Map<DateTime, List<GameInfo>> _allGames = {};

  Map<DateTime, List<GameInfo>> _dayGames = {};

  Map<String, dynamic> _gamesData = {};

  Map<String, String> _gamesIdandDate = {};

  List<SingleTeam> _teamsOfTheDay = [];

  List<SingleTeam> get teamsOfTheDay {
    return _teamsOfTheDay;
  }

  int _totalGoals;
  int _totalGames;

  int get totalGoals {
    return _totalGoals;
  }

  int get totalGames {
    return _totalGames;
  }

  Map<String, String> get gamesIdAndDate {
    return _gamesIdandDate;
  }

  Map<DateTime, List<GameInfo>> get allGames {
    return {..._allGames};
  }

  Map<DateTime, List<Object>> get dayGames {
    return {..._dayGames};
  }

  Map<String, dynamic> get gamesData {
    return {..._gamesData};
  }

  Future<void> addGames(
      {List<SingleTeam> teamsInfo, List<GameInfo> games}) async {
    DateTime date = DateTime.now();
    //String stringDate =  DateFormat.yMd().format(date);
    // set to firebase here
    const url = 'https://indoor-soccer-log.firebaseio.com/games.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'date': date.toIso8601String(),
            'teams': teamsInfo
                .map((team) => {
                      'id': team.id,
                      'teamName': team.teamName,
                      'teamColor': team.color.value,
                    })
                .toList(),
            'gameInfo': games
                .map((game) => {
                      'id': game.id,
                      'teamLeftId': game.team1.id,
                      'teamLeftGoals': game.team1.goals,
                      'teamRightId': game.team2.id,
                      'teamRightGoals': game.team2.goals,
                      'winnerId': game.winner.id,
                    })
                .toList(),
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw (responseData['error']['message']);
      }

    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchGameIdAndDate() async {
    const url = 'https://indoor-soccer-log.firebaseio.com/games.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      extractedData.forEach((id, values) {
        _gamesIdandDate[id] = values['date'];
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchGamnesById(String id) async {
    final url = 'https://indoor-soccer-log.firebaseio.com/games/$id.json';

    try {

      _teamsOfTheDay = [];

      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      Map<String, dynamic> gameInfo = {};
      List<dynamic> totalGames = [];

      extractedData.forEach((id, values) {
        if (id == 'teams') {
          var teamInfo = List.from(values);
          teamInfo.forEach((team) {
            SingleTeam teamData =
                SingleTeam(team['id'], Color(team['teamColor']), 'teamName');
            _teamsOfTheDay.add(teamData);
          });
        } else if (id == 'gameInfo') {
          gameInfo[id] = values;
          totalGames = values;
        }
      });

      if (gameInfo.isNotEmpty) {
        _parseGameInfo(gameInfo);
        _getStats(totalGames);
      }
    } catch (error) {
      throw error;
    }
  }

  void _getStats(List<dynamic> gameInfo) {

    if (gameInfo.isEmpty) {
      print('No games where foud in database for stats');
      return;
    }
    _totalGoals = 0;
    _totalGames = 0;

    gameInfo.forEach((game)  {
      _totalGames++;
      _totalGoals += game['teamLeftGoals'] + game['teamRightGoals'];

    });

  }

  void _parseGameInfo(Map<String, dynamic> gameInfo) {
    if (_teamsOfTheDay.isEmpty) {
      print('Teams of the day is empty');
      return;
    }

    int team1Goals = 0, team2Goals = 0, team3Goals = 0;
    int team1Wins = 0, team2Wins = 0, team3Wins = 0;

    gameInfo.forEach((key, game) {
      var games = List.from(game);
      if (games.length > 0) {
        games.forEach((game) {
          int teamLeftId = game['teamLeftId'] as int;
          int teamLeftGoals = game['teamLeftGoals'] as int;
          int teamRightId = game['teamRightId'] as int;
          int teamRightGoals = game['teamRightGoals'] as int;
          int winnerTeam = game['winnerId'] as int;

          switch (teamLeftId) {
            case 0:
              team1Goals += teamLeftGoals;
              break;
            case 1:
              team2Goals += teamLeftGoals;
              break;
            case 2:
              team3Goals += teamLeftGoals;
              break;
          }

          switch (teamRightId) {
            case 0:
              team1Goals += teamRightGoals;
              break;
            case 1:
              team2Goals += teamRightGoals;
              break;
            case 2:
              team3Goals += teamRightGoals;
              break;
          }

          switch (winnerTeam) {
            case 0:
              team1Wins++;
              break;
            case 1:
              team2Wins++;
              break;
            case 2:
              team3Wins++;
              break;
          }
        });
      }
    });
    
      _teamsOfTheDay.forEach((team) {
        if (team.id == 0) {
          team.goals = team1Goals;
          team.gamesWon = team1Wins;
        } else if (team.id == 1) {
            team.goals = team2Goals;
          team.gamesWon = team2Wins;
        } else if (team.id == 2) {
            team.goals = team3Goals;
          team.gamesWon = team3Wins;
        }
      });

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
