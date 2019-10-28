import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:provider/provider.dart';

import '../providers/teams.dart';
import '../widgest/stack_team_selector.dart';

class TeamColorPicker extends StatefulWidget {
  final int id;

  TeamColorPicker({
    @required this.id,
  });

  @override
  _TeamColorPickerState createState() => _TeamColorPickerState();
}

class _TeamColorPickerState extends State<TeamColorPicker> {
  @override
  Widget build(BuildContext context) {
   final teamData = Provider.of<Teams>(context, listen: false);
   final teams = teamData.teams;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Select a color'),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: teams[widget.id].color,
                      onColorChanged: (Color color) {
                        teamData.changeTeamColor(widget.id, color);
                      }
                    ),
                  ),
                );
              },
            );
          },
          child: StackTeamSelector(teams[widget.id]),
        ),
      ],
    );
  }
}
