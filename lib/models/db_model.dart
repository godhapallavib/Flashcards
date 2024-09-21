class TitleModel {
  int? fId;
  String? title;

  TitleModel({this.fId, this.title});

  Map<String, dynamic> toJson() {
    return {
      'fId': fId,
      'title': title,
    };
  }

  factory TitleModel.fromJson(Map<String, dynamic> map) {
    return TitleModel(
      fId: map['fId'],
      title: map['title'],
    );
  }
}

class FlashcardData {
  int? id;
  int? fId;
  String? question;
  String? answer;

  FlashcardData({this.id, this.fId, this.question, this.answer});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fId': fId,
      'question': question,
      'answer': answer,
    };
  }

  factory FlashcardData.fromJson(Map<String, dynamic> map) {
    return FlashcardData(
      id: map['id'],
      fId: map['fId'],
      question: map['question'],
      answer: map['answer'],
    );
  }
}