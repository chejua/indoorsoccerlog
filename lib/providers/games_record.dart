import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/game_info.dart';

class GamesRecord with ChangeNotifier {
  List<GameInfo> _games = [];

  List<GameInfo> get games {
    return [..._games];
  }

  void addGameRecord(GameInfo game) {
    _games.add(game);
    notifyListeners();
  }

  void clearGameRecords() {
    _games.clear();
    notifyListeners();
  }
}