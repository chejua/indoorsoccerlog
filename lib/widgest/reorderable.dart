import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:reorderables/reorderables.dart';

class ReOrderable extends StatefulWidget {
  final List<String> playersNames;
   List<Widget> playersWidgets;
  ReOrderable({this.playersNames, this.playersWidgets});

  @override
  _ReOrderableState createState() => _ReOrderableState();
}

class _ReOrderableState extends State<ReOrderable> {


  @override
  void initState() {
    super.initState();
    widget.playersWidgets = _buildPlayerCards(widget.playersNames);
  }

  Widget _buildTeamTitleContainer(String teamName) {
    return Container(
      height: 25,
      width: double.infinity,
      child: Center(
        child: Text(
          teamName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(
          75,
        ),
      ),
    );
  }

  List<Widget> _buildPlayerCards(List<String> playerNames) {
    List<Widget> widgets = [];
    widgets.add(_buildTeamTitleContainer('Team 1'));

    for (int i = 0; i < playerNames.length; i++) {
      var playerWidget = Container(
        width: 80,
        height: 50,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            playerNames[i],
            textAlign: TextAlign.center,
          ),
        ),
      );

      if (i == 6) {
        widgets.add(_buildTeamTitleContainer('Team 2'));
      } else if (i == 12) {
        widgets.add(_buildTeamTitleContainer('Team 3'));
      }

      widgets.add(playerWidget);
    }
    return widgets;
  }

  void _printArrayOrder() {
    print(widget.playersWidgets.length);
    widget.playersWidgets.forEach((widget) {
      if (widget is Card) {
        var cardChild = widget.child as Text;
        print(cardChild.data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = widget.playersWidgets.removeAt(oldIndex);
        widget.playersWidgets.insert(newIndex, row);
      });
    }

    var wrap = ReorderableWrap(
        spacing: 32.0,
        runSpacing: 10.0,
        padding: const EdgeInsets.all(8),
        children: widget.playersWidgets,
        onReorder: _onReorder,
        onNoReorder: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
        },
        onReorderStarted: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
        });

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        wrap,
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            // IconButton(
            //   iconSize: 50,
            //   icon: Icon(Icons.add_circle),
            //   color: Colors.deepOrange,
            //   padding: const EdgeInsets.all(0.0),
            //   onPressed: () {
            //     var newTile = Icon(Icons.filter_9_plus, size: _iconSize);
            //     setState(() {
            //       // _tiles.add(newTile);
            //     });
            //   },
            // ),
            // IconButton(
            //   iconSize: 50,
            //   icon: Icon(Icons.remove_circle),
            //   color: Colors.teal,
            //   padding: const EdgeInsets.all(0.0),
            //   onPressed: () {
            //     setState(() {
            //       _tiles.removeAt(0);
            //     });
            //   },
            // ),
          ],
        ),

      ],
    );

    return SingleChildScrollView(
      child: column,
    );
  }
}
