import 'package:flutter/material.dart';

import '../widgest/reorderable.dart';

class TeamsSetupScreen extends StatefulWidget {
  static const routeName = '/teams-setup';

  @override
  _TeamsSetupScreenState createState() => _TeamsSetupScreenState();
}

class _TeamsSetupScreenState extends State<TeamsSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isTeamsParse = false;
  final List<Widget> playerWidgets =[];

  final String kNames =
      'Wed @9\n 1. Geo\n 2. Other\n 3. Joe\n 4. Tom\n 5. Bob\n 6. Cat\n 7. Peop\n 9. Willy\n 10. Zack\n 11. Juan\n 12. Hector\n 13. Rey\n 14. Ernesto\n';
  List<String> playerNames = [];

  void _parsePlayersNames(String text) {
    final RegExp exp = RegExp(r"\d\. ?((\w+ ?)+)");
    final matches = exp.allMatches(text);

    for (Match match in matches) {
      playerNames.add(match.group(2));
    }
    print(playerNames);
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Setup'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          )
        ],
      ),
      body: _isTeamsParse
          ? ReOrderable(playersNames:  playerNames, playersWidgets: playerWidgets,)
          : Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 150,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Insert list here',
                    ),
                    maxLines: null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.redAccent,
                      child: Text('Parse'),
                      onPressed: () {
                        _parsePlayersNames(kNames);
                        setState(() {
                          _isTeamsParse = true;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
