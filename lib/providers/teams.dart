import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/single_team.dart';



class Teams with ChangeNotifier {
  List<SingleTeam> _teams = [
    SingleTeam(0, Colors.blue, "Team 1"),
    SingleTeam(1, Colors.orange, "Team 2"),
    SingleTeam(2, Colors.grey, "Team 3"),
  ];

  List<SingleTeam> _possibleTeams = [];

  int _previousTeam1Index = 0;
  int _previousTeam2Index = 1;
  int _lastWinner = 0;

  int get previousTeam1 {
    return _previousTeam1Index;
  }

  int get previousTeam2 {
    return _previousTeam2Index;
  }

  int get lastWinner {
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
  
  void addGoal(int id) {
    if (_teams[id].goals < 2) {
      _teams[id].goals++;
      notifyListeners();
    }
  }

  void subtraGoal(int id) {
    if (_teams[id].goals > -1) {
      _teams[id].goals--;
      notifyListeners();
    }
  }

  void saveLastTeamsThatPlay(int teamOneIndex, int teamTwoIndex, int winnerIndex) {
    _previousTeam1Index = winnerIndex;

    if (teamOneIndex == 0 && teamTwoIndex == 1) {
      _previousTeam2Index = 2;
    } else if (teamOneIndex == 0 && teamTwoIndex == 2) {
      _previousTeam2Index = 1;
    } else if (teamOneIndex == 1 && teamTwoIndex == 0) {
      _previousTeam2Index = 2;
    } else if (teamOneIndex == 1 && teamTwoIndex == 2) {
      _previousTeam2Index = 0;
    } else if (teamOneIndex == 2 && teamTwoIndex == 0) {
      _previousTeam2Index = 1;
    } else if (teamOneIndex == 2 && teamTwoIndex == 1) {
      _previousTeam2Index = 0;
    }

    _lastWinner = winnerIndex;
  }

  void resetTeamGoals() {
    _teams.forEach((teams) => teams.goals = 0);
  }
}
