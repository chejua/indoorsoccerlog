import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soccer_log/models/game_info.dart';

import '../providers/teams.dart';
import '../providers/games_record.dart';
import '../providers/games_per_day.dart';
import '../widgest/team_color_picker.dart';
import '../widgest/new_game.dart';
import '../widgest/games_result.dart';
import '../widgest/games_drawer.dart';

class GamesOverviewScreen extends StatelessWidget {
  void _startNewGame(
    BuildContext ctx,
  ) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewGame();
        });
  }

  void saveGamesForRecord(BuildContext context, List<GameInfo> games) {
    Provider.of<GamesPerDay>(context, listen: false).addGames(games);
    Provider.of<GamesRecord>(context, listen: false).clearGameRecords();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final teamsData = Provider.of<Teams>(context);
    final teams = teamsData.teams;

    final gamesData = Provider.of<GamesRecord>(context);
    final games = gamesData.games;

    return Scaffold(
      appBar: AppBar(
        title: Text('Soccer Log'),
      ),
      drawer: GamesDrawer(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TeamColorPicker(
                  id: teams[0].id,
                ),
                TeamColorPicker(
                  id: teams[1].id,
                ),
                TeamColorPicker(
                  id: teams[2].id,
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              if (games.isEmpty)
                Text(
                  'No Games Have Been Played Yet!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
              if (!games.isEmpty)
                Container(
                  height:
                      (mediaQuery.size.height - mediaQuery.padding.top) * 0.59,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.2),
                  child: ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (ctx, index) => GameResult(index),
                  ),
                ),
            ],
          ),
          FlatButton(
            child: Text('Save All'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Submit Games'),
                    content: const Text(
                        'This will clear the current table and submit the games'),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: const Text('ACCEPT'),
                        onPressed: () {
                          saveGamesForRecord(context, games);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _startNewGame(context);
        },
      ),
    );
  }
}
