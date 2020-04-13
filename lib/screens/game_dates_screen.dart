import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/games_detail_info.dart';
import '../providers/games_per_day.dart';

enum DayOfWeek { Monday, Wenesday }

class GameDatesScreen extends StatelessWidget {
  static const routeName = '/game-dates';

  Future<void> _refreshGameDates(BuildContext context, int day) async {
    await Provider.of<GamesPerDay>(context, listen: false).fetchGameIdAndDate();
    // await Provider.of<GamesPerDay>(context, listen: false)
    //     .fetchGameDatesOnly(day);
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilt");
    final routeArgs = ModalRoute.of(context).settings.arguments as String;
    final dayOfWeek =
        routeArgs == 'Mondays' ? DateTime.monday : DateTime.saturday;
    return Scaffold(
      appBar: AppBar(
        title: Text(routeArgs),
      ),
      body: FutureBuilder(
        future: _refreshGameDates(context, dayOfWeek),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshGameDates(ctx, dayOfWeek),
                child: Consumer<GamesPerDay>(
                  builder: (ctx, gamesDataa, _) => GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        padding: const EdgeInsets.all(25),
                        children: gamesDataa.gamesIdAndDate.keys.map((key) {
                          return InkWell(
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                DateFormat.yMd().format(DateTime.parse(gamesDataa.gamesIdAndDate[key])),
                                style: TextStyle(fontSize: 25.0),
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.withOpacity(0.9),
                                      Colors.blue
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              alignment: Alignment(0.0, 0.0),
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                                GamesDetailInfo.routeName,
                                arguments: key),
                          );
                        }).toList(),
                      ),
                ),
              ),
      ),
    );
  }
}
