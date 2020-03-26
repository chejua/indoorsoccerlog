import 'package:flutter/material.dart';

class CardStackWidget extends StatelessWidget {
  final List<String> teams;

  CardStackWidget(this.teams);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: cardItems(context),
    );
  }

  List<Widget> cardItems(BuildContext context) {
    var cardItemdraggable;
    List<Widget> carditemsList = [];
    if (teams.length < 1) {
      cardItemdraggable = Container(
        height: 200.0,
        width: 200.0,
        child: Card(
          color: Colors.grey,
          child: Center(
              child: Text(
            'NO_ITEMS_LEFT',
            style: TextStyle(fontSize: 25.0, color: Colors.white12),
          )),
        ),
      );
    } else {
      for (int i = 0; i < teams.length; i++) {
        print(teams[i]);
        cardItemdraggable = Container(
          child: DraggableWidget(
            i: i,
            team: teams[i],
          ),
        );
      }
    }
    carditemsList.add(cardItemdraggable);

    return carditemsList;
  }
}

class DraggableWidget extends StatelessWidget {
  DraggableWidget({
    @required this.team,
    Key key,
    @required this.i,
  }) : super(key: key);

  final int i;
  final String team;

  //CardItem item;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: 'Player',
      childWhenDragging: Container(
        height: 50.0,
        width: 50.0,
        child: Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.blue,
          child: Center(
            child: Text(
              team,
              style: TextStyle(fontSize: 25.0, color: Colors.white),
            ),
          ),
        ),
      ),
      feedback: Container(
        height: 50.0,
        width: 50.0,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 2.0,
          color: Colors.orange,
          child: Center(
              child: Text(
            team,
            style: TextStyle(fontSize: 25.0, color: Colors.white30),
          )),
        ),
      ),
      child: Container(
        height: 50.0,
        width: 50.0,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 2.0,
          color: Colors.green,
          child: Center(
              child: Text(
            team,
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          )),
        ),
      ),
    );
  }
}
