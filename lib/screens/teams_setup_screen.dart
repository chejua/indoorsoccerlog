import 'package:flutter/material.dart';

import '../widgest/team_stack.dart';
import '../widgest/drag_target.dart';
import '../widgest/reorderable.dart';

class TeamsSetupScreen extends StatefulWidget {
  static const routeName = '/teams-setup';

  @override
  _TeamsSetupScreenState createState() => _TeamsSetupScreenState();
}

class _TeamsSetupScreenState extends State<TeamsSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isTeamsParse = false;
  final List<String> players = [];
  final String kNames = 'Wed @9\n 1. Geo\n 2. Other\n';

  void _parsePlayersNames(String text) {
    final List<String> names = [];
    final RegExp exp = RegExp(r"\d\. ?((\w+ ?)+)");
    final matches = exp.allMatches(text);

    for (Match match in matches) {
      names.add(match.group(2));
    }
    print(names);
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
      ),
      body: _isTeamsParse
          ? WrapExample()
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
