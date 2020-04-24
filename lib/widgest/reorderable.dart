import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:reorderables/reorderables.dart';

class WrapExample extends StatefulWidget {
  @override
  _WrapExampleState createState() => _WrapExampleState();
}

class _WrapExampleState extends State<WrapExample> {
  final double _iconSize = 50;
  List<Widget> _tiles;

  @override
  void initState() {
    super.initState();
    _tiles =
        //_buildPlayerCards(18);
        <Widget>[
      _buildTeamTitleContainer('Team 1'),
      _buildTeamTitleContainer('Team 2'),
      _buildTeamTitleContainer('Team 3'),
      

      // Icon(Icons.filter_7, size: _iconSize),
      // Icon(Icons.filter_8, size: _iconSize),
      // Icon(Icons.filter_9, size: _iconSize),
    ];
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

  List<Widget> _buildPlayerCards(int number) {
    List<Widget> widgets = [];

    var row1 = Row(
      children: <Widget>[],
    );
    var row2 = Row(
      children: <Widget>[],
    );
    var row3 = Row(
      children: <Widget>[],
    );

    for (int i = 0; i < number; i++) {
      var player = Flexible(
        child: Container(
          width: 100,
          height: 75,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              'Geo ${i + 1}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

      if (i < 6) {
        row1.children.add(player);
      } else if (i < 12) {
        row2.children.add(player);
      } else {
        row3.children.add(player);
      }
    }

    widgets.add(row1);
    widgets.add(row2);
    widgets.add(row3);

    return widgets;
  }

  void _printArrayOrder() {
    print(_tiles.length);

    _tiles.forEach((widget) {
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
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
    }

    var wrap = ReorderableWrap(
        spacing: 8.0,
        runSpacing: 4.0,
        padding: const EdgeInsets.all(8),
        children: _tiles,
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
            IconButton(
              iconSize: 50,
              icon: Icon(Icons.add_circle),
              color: Colors.deepOrange,
              padding: const EdgeInsets.all(0.0),
              onPressed: () {
                var newTile = Icon(Icons.filter_9_plus, size: _iconSize);
                setState(() {
                  // _tiles.add(newTile);
                });
              },
            ),
            IconButton(
              iconSize: 50,
              icon: Icon(Icons.remove_circle),
              color: Colors.teal,
              padding: const EdgeInsets.all(0.0),
              onPressed: () {
                setState(() {
                  _tiles.removeAt(0);
                });
              },
            ),
          ],
        ),
        FlatButton(
          child: Text('Show List'),
          onPressed: _printArrayOrder,
        ),
      ],
    );

    return SingleChildScrollView(
      child: column,
    );
  }
}
