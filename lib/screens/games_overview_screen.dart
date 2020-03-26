import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soccer_log/models/game_info.dart';
import 'package:flushbar/flushbar.dart';

import '../providers/teams.dart';
import '../providers/games_record.dart';
import '../providers/games_per_day.dart';
import '../widgest/team_color_picker.dart';
import '../widgest/new_game.dart';
import '../widgest/games_result.dart';
import '../widgest/games_drawer.dart';
import './teams_setup_screen.dart';

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

  Future<String> saveGamesForRecord(
      BuildContext context, List<GameInfo> games) async {
    try {
      var teams = Provider.of<Teams>(context, listen: false).teams;
      Provider.of<GamesRecord>(context).clearGameRecords();
      await Provider.of<GamesPerDay>(context)
          .addGames(teamsInfo: teams, games: games);
          return 'Games were saved';
    } catch (error) {
      return error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Games overview build');
    final mediaQuery = MediaQuery.of(context);
    final teams = Provider.of<Teams>(context).teams;
    final games = Provider.of<GamesRecord>(context).games;

    return Scaffold(
      appBar: AppBar(
        title: Text('Soccer Log'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () =>
                Navigator.of(context).pushNamed(TeamsSetupScreen.routeName),
          ),
        ],
      ),
      drawer: GamesDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/soccer_bg.jpg'),
              fit: BoxFit.fill),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    height: (mediaQuery.size.height - mediaQuery.padding.top) *
                        0.59,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.2),
                    child: ListView.builder(
                      itemCount: games.length,
                      itemBuilder: (ctx, index) => GameResult(index),
                    ),
                  ),
              ],
            ),
            if (!games.isEmpty)
              FlatButton(
                color: Theme.of(context).primaryColor,
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
                            onPressed: () async {
                              String message = await saveGamesForRecord(context, games);
                              Navigator.of(context).pop();
                              Flushbar(
                                title: "Message",
                                message:
                                    message,
                                duration: Duration(seconds: 3),
                              )..show(context);
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
