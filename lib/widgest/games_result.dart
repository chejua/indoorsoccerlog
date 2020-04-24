import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/games_record.dart';
import '../models/game_info.dart';
import '../widgest/stack_team_selector.dart';

class GameResult extends StatelessWidget {
  final index;
  static const double ratioSize = 50;
  GameResult(this.index);

  void _showAlertDialog(BuildContext context, GameInfo game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Game Stats'),
          content: Column(
            children: <Widget>[
              Text('${game.team1.teamName} : Goals # ${game.team1.goals}'),
              Text('${game.team2.teamName} : Goals # ${game.team2.goals}'),
              Text('Total time played: ${game.secondsPlayed}')
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final games = Provider.of<GamesRecord>(context, listen: false).games;
    return Card(
      elevation: 5,
      child: Container(
        height: 55,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.0),
            color: Colors.red,
            child: Icon(
              Icons.delete,
            ),
          ),
          onDismissed: (direction) {
            Provider.of<GamesRecord>(context, listen: false)
                .deleteItemFromList(index);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('${(index + 1).toString()}'),
              StackTeamSelector(
                games[index].team1,
                ratio: ratioSize,
              ),
              Container(
                child: Text(
                  ' VS ',
                  textAlign: TextAlign.center,
                ),
              ),
              StackTeamSelector(games[index].team2, ratio: ratioSize),
              Container(
                child: Text(
                  ' W ',
                  textAlign: TextAlign.center,
                ),
              ),
              StackTeamSelector(games[index].winner, ratio: ratioSize),
              IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () => _showAlertDialog(context, games[index])),
            ],
          ),
        ),
      ),
    );
  }
}
