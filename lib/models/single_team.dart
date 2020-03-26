import 'package:flutter/material.dart';

class SingleTeam {
  final int id;
  Color color;
  final String teamName;
  int goals;
  int gamesWon;
  final bool myTeam;

  SingleTeam(this.id, this.color, this.teamName,
      {this.goals = 0, this.gamesWon = 0, this.myTeam});
}
