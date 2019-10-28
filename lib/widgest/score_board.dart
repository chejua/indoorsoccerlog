import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/teams.dart';

class ScoreBoard extends StatelessWidget {

  final teamId;


  ScoreBoard(this.teamId);
  
  @override
  Widget build(BuildContext context) {
     final teamData = Provider.of<Teams>(context);
     final teamDataList = teamData.teams;
     return Container(
      child: Row(
        children: <Widget>[
          Text( 
           teamDataList[teamId].goals.toString(),
            style: TextStyle(fontSize: 35.0),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                child: Icon(Icons.add_box, size: 30),
                onTap: () {
                 teamData.addGoal(teamId);
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                child: Icon(Icons.indeterminate_check_box, size: 30),
                onTap: () {
                  teamData.subtraGoal(teamId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}