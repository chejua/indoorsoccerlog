import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/games_per_day.dart';

class GamesDetailInfo extends StatelessWidget {
static const routeName = '/games-detail-info';

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as String;
    var gamesData = Provider.of<GamesPerDay>(context, listen: false).getGamesPerDay(routeArgs);

    return Scaffold(
      appBar: AppBar(
        title: Text(routeArgs),
      ),
      body: ListView.builder(
        itemCount: gamesData.length,
        itemBuilder: (ctx, index) {
          return Card(
            child: ListTile(
              leading: Text('leading'),
              title: Text('title'),
              trailing: Text('trailing'),
              subtitle: Text('subtitle'),
            ),
          );
        },
      ),
    );
  }
}