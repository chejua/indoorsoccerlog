import 'package:flutter/material.dart';
import '../providers/teams.dart';
import '../models/single_team.dart';

class StackTeamSelector extends StatelessWidget {
  final SingleTeam team;
  final double ratio;

  StackTeamSelector(this.team, {this.ratio = 75});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: ratio,
          width: ratio,
          decoration: BoxDecoration(
            color: team.color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(team.teamName, style: TextStyle(fontSize: 9),),
          ),
        ),
        Image.asset(
          'assets/images/jerseyicon.png',
          width: ratio,
          fit: BoxFit.fitHeight,
        ),
      ],
    );
  }
}
