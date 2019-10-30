import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgest/stack_team_selector.dart';
import '../providers/teams.dart';
import '../models/game_info.dart';
import '../providers/games_record.dart';
import '../widgest/score_board.dart';

class NewGame extends StatefulWidget {
  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  int index1;
  int index2;
  int winner;

  @override
  void initState() {
    final teams = Provider.of<Teams>(context, listen: false);
    index1 = teams.previousTeam1;
    index2 = teams.previousTeam2;
    winner = teams.previousWinner;
    super.initState();
  }

  Widget _buildFirstTeam(List<SingleTeam> teams) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index1 == teams.length - 1) {
            index1 = 0;
          } else {
            index1++;
          }
        });
      },
      child: StackTeamSelector(teams[index1]),
    );
  }

  Widget _buildSecondTeam(List<SingleTeam> teams) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index2 == teams.length - 1) {
            index2 = 0;
          } else {
            index2++;
          }
        });
      },
      child: StackTeamSelector(teams[index2]),
    );
  }

  Widget _filterWinner(List<SingleTeam> teams) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (winner == index1) {
            winner = index2;
          } else {
            winner = index1;
          }
        });
      },
      child: StackTeamSelector(teams[winner]),
    );
  }

  void _submitGameResult() {
    final teamData = Provider.of<Teams>(context, listen: false);
    final teamDataListTeamOne = teamData.teams;
    Provider.of<GamesRecord>(context, listen: false).addGameRecord(GameInfo(
      id: DateTime.now().toIso8601String(),
      team1: SingleTeam(
          teamDataListTeamOne[index1].id,
          teamDataListTeamOne[index1].color,
          teamDataListTeamOne[index1].teamName,
          goals: teamDataListTeamOne[index1].goals),
      team2: SingleTeam(
          teamDataListTeamOne[index2].id,
          teamDataListTeamOne[index2].color,
          teamDataListTeamOne[index2].teamName,
          goals: teamDataListTeamOne[index2].goals),
      winner: teamDataListTeamOne[winner],
    ));
    Navigator.of(context).pop();

    teamData.resetTeamGoals();
    teamData.saveLastTeamsThatPlay(teamDataListTeamOne[index1].id,
        teamDataListTeamOne[index2].id, teamDataListTeamOne[winner].id);
  }

  @override
  Widget build(BuildContext context) {
    final teamData = Provider.of<Teams>(context, listen: false);
    final teamDataListTeamOne = teamData.teams;
    final teamDataListTeamTwo = [...teamDataListTeamOne];
    return Card(
      elevation: 5,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildFirstTeam(teamDataListTeamOne),
                  Text('VS'),
                  _buildSecondTeam(teamDataListTeamTwo),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text('Winner'),
              SizedBox(
                height: 10,
              ),
              _filterWinner(teamDataListTeamOne),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ScoreBoard(index1),
              Text(
                'Goals',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              ScoreBoard(index2),
            ],
          ),
          RaisedButton(
            child: Text("Submit"),
            color: Colors.deepPurple,
            onPressed: () => _submitGameResult(),
          )
        ],
      ),
    );
  }
}
