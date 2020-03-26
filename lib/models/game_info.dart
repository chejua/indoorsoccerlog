import 'package:flutter/material.dart';

import '../models/single_team.dart';

class GameInfo {
  final String id;
  final SingleTeam team1;
  final SingleTeam team2;
  final SingleTeam winner;
  final int secondsPlayed;
  

  GameInfo({
    @required this.id,
    @required this.team1,
    @required this.team2,
    @required this.winner,
    this.secondsPlayed
  });
}
