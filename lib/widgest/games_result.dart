import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/games_record.dart';
import '../models/game_info.dart';

class GameResult extends StatelessWidget {
  final index;

  GameResult(this.index);

  void _showAlertDialog(BuildContext context, List<GameInfo> games) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Game Stats'),
          content: Column(
            children: <Widget>[
              Text(
                  '${games[index].team1.teamName} : Goals # ${games[index].team1.goals}'),
              Text(
                  '${games[index].team2.teamName} : Goals # ${games[index].team2.goals}'),
              Text('Total time played: ${games[index].secondsPlayed}')
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
    final gamesData = Provider.of<GamesRecord>(context);
    final games = gamesData.games;
    return Card(
      elevation: 5,
      color: games[index].winner.color,
      child: ListTile(
        leading: Text(
          (index + 1).toString(),
          style: TextStyle(fontSize: 26),
        ),
        title: Text(
          games[index].winner.teamName,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          '${games[index].team1.teamName} VS ${games[index].team2.teamName}',
          style: TextStyle(fontSize: 15),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          iconSize: 35,
          onPressed: () => {
            _showAlertDialog(context, games)
          },
        ),
        onTap: () {},
      ),
    );
  }
}
