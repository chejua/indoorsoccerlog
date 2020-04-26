import 'package:flutter/material.dart';

import 'player.dart';

class SingleTeam {
  final int id;
  Color color;
  final String teamName;
  int goals;
  int gamesWon;
  List<Player> players;

  SingleTeam(this.id, this.color, this.teamName,
      {this.goals = 0, this.gamesWon = 0});
}
