import 'package:flutter/material.dart';
import '../providers/teams.dart';

class StackTeamSelector extends StatelessWidget {
  final SingleTeam team;

  StackTeamSelector(this.team);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: team.color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(team.teamName),
          ),
        ),
        Image.asset(
          'assets/images/jerseyicon.png',
          width: 100,
          fit: BoxFit.fitHeight,
        ),
      ],
    );
  }
}
