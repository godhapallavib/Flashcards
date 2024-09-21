import 'dart:convert';

List<ModelClass> getClassModelFromMap(String str) =>
    List<ModelClass>.from(json.decode(str).map((x) => ModelClass.fromMap(x)));

String modelClassToMap(List<ModelClass> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ModelClass {
  String title;
  List<Flashcard> flashcards;

  ModelClass({
    required this.title,
    required this.flashcards,
  });

  factory ModelClass.fromMap(Map<String, dynamic> json) => ModelClass(
        title: json["title"],
        flashcards: List<Flashcard>.from(
            json["flashcards"].map((x) => Flashcard.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "flashcards": List<dynamic>.from(flashcards.map((x) => x.toMap())),
      };
}

class Flashcard {
  String question;
  String answer;

  Flashcard({
    required this.question,
    required this.answer,
  });

  factory Flashcard.fromMap(Map<String, dynamic> json) => Flashcard(
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toMap() => {
        "question": question,
        "answer": answer,
      };
}
