import 'package:flutter/services.dart';
import 'package:mp3/models/model_class.dart';

class DataofJson {
  static Future<List<ModelClass>?> data() async {
    String jsonData = await rootBundle.loadString("assets/flashcards.json");
    List<ModelClass> jsonList = getClassModelFromMap(jsonData);
    return jsonList;
  }
}
