import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SingleTeam {
  final int id;
  Color color;
  final String teamName;
  int goals;
  final bool myTeam;

  SingleTeam(this.id, this.color, this.teamName, {this.goals = 0, this.myTeam});
}

class Teams with ChangeNotifier {
  List<SingleTeam> _teams = [
    SingleTeam(0, Colors.yellow, "Team 1"),
    SingleTeam(1, Colors.green, "Team 2"),
    SingleTeam(2, Colors.blue, "Team 3"),
  ];

  List<SingleTeam> _possibleTeams = [];

  int _teamOneIndex = 0;
  int _teamTwoIndex = 1;
  int _lastWinner = 0;

  int get previousTeam1 {
    return _teamOneIndex;
  }

  int get previousTeam2 {
    return _teamTwoIndex;
  }

  int get previousWinner {
    return _lastWinner;
  }

  List<SingleTeam> get teams {
    return [..._teams];
  }

  List<SingleTeam> get possibleTeams {
    return [..._possibleTeams];
  }

  void changeTeamColor(int id, Color color) {
    final teamIndex = _teams.indexWhere((team) => team.id == id);
    _teams[teamIndex].color = color;
    notifyListeners();
  }

  // void switchTeamOne() {
  //   if (teamOneIndex == _teams.length - 1) {
  //     teamOneIndex = 0;
  //   } else {
  //     teamOneIndex++;
  //   }
  // }

  // void filterPossibleTeams(int teamOneIndex, int teamTwoIndex) {
  //   _teams.forEach((team) => {
  //         if (team.id == teamOneIndex || team.id == teamTwoIndex)
  //           {_possibleTeams.add(team)}
  //       });
  // }

  void addGoal(int id) {
    _teams[id].goals++;
    notifyListeners();
  }

  void subtraGoal(int id) {
    _teams[id].goals--;
    notifyListeners();
  }

  void saveLastTeamsThatPlay(int teamOne, int teamTwo, int winner) {
    _teamOneIndex = winner;

    if (teamOne == 0 && teamTwo == 1) {
      _teamTwoIndex = 2;
    } else if (teamOne == 0 && teamTwo == 2) {
      _teamTwoIndex = 1;
    } else if (teamOne == 1 && teamTwo == 0) {
      _teamTwoIndex = 2;
    }  else if (teamOne == 1 && teamTwo == 2) {
      _teamTwoIndex = 0;
    } else if (teamOne == 2 && teamTwo == 0) {
      _teamTwoIndex = 1;
    } else if (teamOne == 2 && teamTwo == 1) {
      _teamTwoIndex = 0;
    } 

    _lastWinner = winner;
  }

  void resetTeamGoals() {
    _teams.forEach((teams) => {teams.goals = 0});
  }
}
