import 'package:flutter/material.dart';
import '../screens/game_dates_screen.dart';

class GamesDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: Theme.of(context).accentColor,
              child: Text(
                'Games',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: buildListTile('Monday', Icons.calendar_today, () {
                Navigator.of(context)
                    .pushNamed(GameDatesScreen.routeName, arguments: "Mondays");
              }),
            ),
            Divider(
              color: Colors.grey,
            ),
            Expanded(
              child: buildListTile('Wednesday', Icons.calendar_today, () {
                Navigator.of(context).pushNamed(GameDatesScreen.routeName,
                    arguments: "Wednesdays");
              }),
            ),
          ],
        ),
      ),
    );
  }
}
