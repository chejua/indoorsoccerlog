import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgest/stack_team_selector.dart';
import '../providers/teams.dart';
import '../models/game_info.dart';
import '../providers/games_record.dart';
import '../widgest/score_board.dart';
import '../models/single_team.dart';

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
    winner = teams.lastWinner;
    super.initState();
  }

  Widget _buildFirstTeam(List<SingleTeam> teams) {
    return GestureDetector(
      onTap: () {
        int tempIndex = index1;
        if (index1 == teams.length - 1) {
          tempIndex = 0;
        } else {
          tempIndex++;
        }
        if (tempIndex == index2) {
          tempIndex++;
        }
        setState(() {
          index1 = tempIndex;
        });
      },
      child: StackTeamSelector(teams[index1]),
    );
  }

  Widget _buildSecondTeam(List<SingleTeam> teams) {
    return GestureDetector(
      onTap: () {
        int tempIndex = index2;
        if (index2 == teams.length - 1) {
          tempIndex = 0;
        } else {
          tempIndex++;
        }
        if (tempIndex == index1) {
          tempIndex++;
        }
        setState(() {
          index2 = tempIndex;
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
    final teams = teamData.teams;
    Provider.of<GamesRecord>(context, listen: false).addGameRecord(GameInfo(
      id: DateTime.now().toIso8601String(),
      team1: SingleTeam(
          teams[index1].id,
          teams[index1].color,
          teams[index1].teamName,
          goals: teams[index1].goals),
      team2: SingleTeam(
          teams[index2].id,
          teams[index2].color,
          teams[index2].teamName,
          goals: teams[index2].goals),
      winner: teams[winner],
    ));
    Navigator.of(context).pop();

    teamData.resetTeamGoals();
    teamData.saveLastTeamsThatPlay(teams[index1].id,
        teams[index2].id, teams[winner].id);
  }

  @override
  Widget build(BuildContext context) {
    final teamData = Provider.of<Teams>(context);
    final teamDataListTeamOne = teamData.teams;
    final teamDataListTeamTwo = teamData.teams;
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
            color: Theme.of(context).accentColor,
            onPressed: () => _submitGameResult(),
          )
        ],
      ),
    );
  }
}
