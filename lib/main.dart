import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/teams.dart';
import './providers/games_record.dart';
import './providers/games_per_day.dart';
import './screens/games_overview_screen.dart';
import './screens/game_dates_screen.dart';
import './screens/games_detail_info.dart';
import './screens/teams_setup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Teams(),
          ),
          ChangeNotifierProvider.value(
            value: GamesRecord(),
          ),
          ChangeNotifierProvider.value(
            value: GamesPerDay(),
          ),
        ],
        child: MaterialApp(
          title: 'Soccer Log',
          //home: GamesOverviewScreen(),
          initialRoute: '/',
          routes: {
            '/': (ctx) => GamesOverviewScreen(),
            GameDatesScreen.routeName: (ctx) => GameDatesScreen(),
            GamesDetailInfo.routeName: (ctx) => GamesDetailInfo(),
            TeamsSetupScreen.routeName: (ctx) => TeamsSetupScreen()
          },
        ));
  }
}
