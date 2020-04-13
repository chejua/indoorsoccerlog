import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/games_per_day.dart';
import '../models/single_team.dart';
import '../widgest/stack_team_selector.dart';

class GamesDetailInfo extends StatelessWidget {
  static const routeName = '/games-detail-info';

  Future<void> fetchGameDetails(BuildContext context, String gameId) async {
    await Provider.of<GamesPerDay>(context, listen: false)
        .fetchGamnesById(gameId);
  }

  @override
  Widget build(BuildContext context) {
    final String routeArgs = ModalRoute.of(context).settings.arguments;
    print('Game Detail info created');
    return Scaffold(
      appBar: AppBar(
        title: Text('Monday'),
      ),
      body: FutureBuilder(
        future: fetchGameDetails(context, routeArgs),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => fetchGameDetails(ctx, routeArgs),
                child: Consumer<GamesPerDay>(
                  builder: (ctx, gamesData, _) => Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 100,
                              child: Card(
                                  margin: EdgeInsets.all(25),
                                  color: Colors.white70,
                                  elevation: 5,
                                  borderOnForeground: true,
                                  child: Center(
                                    child: Stack(
                                      children: <Widget>[
                                        // Stroked text as border.
                                        Text(
                                          DateFormat.MMMMEEEEd()
                                              .format(DateTime.parse(gamesData
                                                  .gamesIdAndDate[routeArgs]))
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 25,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 6
                                              ..color = Colors.blue[700],
                                          ),
                                        ),
                                        // Solid text as fill.
                                        Text(
                                          DateFormat.MMMMEEEEd()
                                              .format(DateTime.parse(gamesData
                                                  .gamesIdAndDate[routeArgs]))
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                StackTeamSelector(
                                  SingleTeam(
                                      gamesData.teamsOfTheDay[0].id,
                                      gamesData.teamsOfTheDay[0].color,
                                      'Team 1'),
                                  ratio: 100,
                                ),
                                StackTeamSelector(
                                  SingleTeam(
                                      gamesData.teamsOfTheDay[1].id,
                                      gamesData.teamsOfTheDay[1].color,
                                      'Team 2'),
                                  ratio: 100,
                                ),
                                StackTeamSelector(
                                  SingleTeam(
                                      gamesData.teamsOfTheDay[2].id,
                                      gamesData.teamsOfTheDay[2].color,
                                      'Team 3'),
                                  ratio: 100,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                    'Won: ${gamesData.teamsOfTheDay[0].gamesWon}'),
                                Text(
                                    'Won: ${gamesData.teamsOfTheDay[1].gamesWon}'),
                                Text(
                                    'Won: ${gamesData.teamsOfTheDay[2].gamesWon}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                    'Goals: ${gamesData.teamsOfTheDay[0].goals}'),
                                Text(
                                    'Goals: ${gamesData.teamsOfTheDay[1].goals}'),
                                Text(
                                    'Goals: ${gamesData.teamsOfTheDay[2].goals}'),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            _buildChipWithTotalInfo('Total Games Played ${gamesData.totalGames}'),
                            _buildChipWithTotalInfo('Total Goals Scored ${gamesData.totalGoals}'),
                          ],
                        ),
                      ),
                ),
              ),
      ),
    );
  }
}

Widget _buildChipWithTotalInfo(String text) {
  return Chip(
    padding: EdgeInsets.all(10),
    label: Text(
      text,
      style: TextStyle(fontSize: 25),
    ),
    backgroundColor: Colors.blueAccent.shade400,
  );
}
