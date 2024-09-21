import 'package:flutter/foundation.dart';

class FlashProvider extends ChangeNotifier {
  List<int> fIds = [];
  List<String> titlesList = [];
  int card = 1;
  int seen = 0;
  int initialCounter = 0;
  bool isCount = true;

  void incrementFlashCardCounter() {
    card = card + 1;
    notifyListeners();
  }

  void incrementSeenCounter() {
    seen++;
    notifyListeners();
  }

  void incrementCounter() {
    initialCounter++;
    notifyListeners();
  }

  void changeCounter() {
    isCount = false;
    notifyListeners();
  }
}
