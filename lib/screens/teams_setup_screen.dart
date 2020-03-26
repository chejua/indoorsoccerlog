import 'package:flutter/material.dart';
import '../widgest/team_stack.dart';
import '../widgest/drag_target.dart';

class TeamsSetupScreen extends StatefulWidget {
  static const routeName = '/teams-setup';
  @override
  _TeamsSetupScreenState createState() => _TeamsSetupScreenState();
}

class _TeamsSetupScreenState extends State<TeamsSetupScreen> {
  bool _isTeamsParse = false;
  List<String> players = [];
  void _parsePlayerList(String playerList) {
    players.add('Joe');
    players.add('Tom');
    players.add('Geo');
    _isTeamsParse = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Setup'),
      ),
      body: _isTeamsParse ?  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CardStackWidget(players),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DragTargetWidget(),
              )
            ],
          ) : Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 350,
            child: TextField(
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
                child: Text('Parse'),
                onPressed: () {
                  setState(() {
                   _parsePlayerList('test'); 
                  });
                } ,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
