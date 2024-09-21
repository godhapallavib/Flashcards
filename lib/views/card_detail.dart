import 'package:flutter/material.dart';
import 'package:mp3/database/database.dart';
import 'package:mp3/models/db_model.dart';
import 'package:mp3/views/decklist.dart';
import 'package:mp3/views/play_game.dart';
import 'package:mp3/widget/custom_button.dart';
import 'package:mp3/widget/custom_textfield.dart';
import 'package:provider/provider.dart';

class CardDetail extends StatefulWidget {
  final String? title;
  final int? sid;

  const CardDetail({
    super.key,
    required this.title,
    required this.sid,
  });

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  String sortByTime = "id ASC";
  String sortByAlphabets = "question ASC";
  List<String> questions = [];
  List<String> answers = [];
  List<int> ids = [];
  bool isSorted = false;
  var queController = TextEditingController();
  var ansController = TextEditingController();

  @override
  void initState() {
    allData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DatabaseHelper>(context);
    var width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title.toString()),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeckList(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isSorted = !isSorted;
                });
                if (isSorted) {
                  sortingData(sortByAlphabets);
                } else {
                  sortingData(sortByTime);
                }
              },
              icon: isSorted
                  ? const Icon(Icons.sort)
                  : const Icon(Icons.sort_by_alpha),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  addQU(context, width, dbProvider);
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: questions.length,
            itemBuilder: (context, index) => Card(
              color: Colors.purple[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    updateQU(context, index, width, dbProvider);
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        questions[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlayGame(
                  title: widget.title.toString(),
                  question: questions,
                  answer: answers,
                ),
              ),
            );
          },
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }

  Future<dynamic> addQU(
      BuildContext context, double width, DatabaseHelper dbProvider) {
    return showDialog(
      context: context,
      builder: (context) {
        queController.clear();
        ansController.clear();
        return AlertDialog(
          title: const Text("Add Content"),
          titleTextStyle: const TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          content: Container(
            width: width / 1,
            height: 150,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormfield(
                  controller: queController,
                  hint: "Question",
                ),
                const SizedBox(height: 10),
                CustomTextFormfield(
                  controller: ansController,
                  hint: "Answer",
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            CustomButton(
              onPressed: () {
                if (queController.text.isNotEmpty &&
                    ansController.text.isNotEmpty) {
                  FlashcardData flashcard = FlashcardData(
                    fId: widget.sid,
                    question: queController.text,
                    answer: ansController.text,
                  );
                  dbProvider
                      .addNewFlashcard(flashcard)
                      .whenComplete(() => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardDetail(
                                sid: widget.sid,
                                title: widget.title,
                              ),
                            ),
                          ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Both Fields are Mandatory"),
                    ),
                  );
                }
              },
              title: "Add",
              height: 35,
              width: 100,
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> updateQU(
    BuildContext context,
    int index,
    double width,
    DatabaseHelper dbProvider,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        queController.text = questions[index];
        ansController.text = answers[index];
        return AlertDialog(
          title: const Text("Update Content"),
          titleTextStyle: const TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          content: Container(
            width: width / 1,
            height: 150,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormfield(
                  controller: queController,
                  hint: "Question",
                ),
                const SizedBox(height: 10),
                CustomTextFormfield(
                  controller: ansController,
                  hint: "Answer",
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            CustomButton(
              onPressed: () {
                if (queController.text.isNotEmpty &&
                    ansController.text.isNotEmpty) {
                  dbProvider
                      .alterFlashCard(
                    FlashcardData(
                      id: ids[index],
                      question: queController.text,
                      answer: ansController.text,
                    ),
                  )
                      .whenComplete(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardDetail(
                          sid: widget.sid,
                          title: widget.title,
                        ),
                      ),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Enter Both"),
                    ),
                  );
                }
              },
              title: "Update",
              height: 35,
              width: 100,
            ),
            CustomButton(
              onPressed: () {
                dbProvider.removeFlashCard(ids[index]).whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardDetail(
                        sid: widget.sid,
                        title: widget.title,
                      ),
                    ),
                  );
                });
              },
              title: "Delete",
              height: 35,
              width: 100,
            ),
          ],
        );
      },
    );
  }

  void allData() {
    questions.clear();
    answers.clear();
    ids.clear();
    var dbProvider = Provider.of<DatabaseHelper>(context, listen: false);
    dbProvider.fetchFlashcards(widget.sid!, sortByTime).then((value) {
      for (var data in value) {
        questions.add(data.question.toString());
        answers.add(data.answer.toString());
        ids.add(data.id!);
      }
    }).whenComplete(() => setState(() {}));
  }

  void sortingData(String orderBy) {
    questions.clear();
    answers.clear();
    ids.clear();
    var dbProvider = Provider.of<DatabaseHelper>(context, listen: false);
    dbProvider.fetchFlashcards(widget.sid!, orderBy).then((value) {
      for (var data in value) {
        questions.add(data.question.toString());
        answers.add(data.answer.toString());
        ids.add(data.id!);
      }
      setState(() {});
    }).whenComplete(() => setState(() {}));
  }
}
