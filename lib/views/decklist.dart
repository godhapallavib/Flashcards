import 'package:flutter/material.dart';
import 'package:mp3/database/database.dart';
import 'package:mp3/models/db_model.dart';
import 'package:mp3/provider/provider.dart';
import 'package:mp3/services/data_json.dart';
import 'package:mp3/views/card_detail.dart';
import 'package:mp3/widget/custom_button.dart';
import 'package:mp3/widget/custom_textfield.dart';
import 'package:provider/provider.dart';

class DeckList extends StatefulWidget {
  const DeckList({super.key});

  @override
  State<DeckList> createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  final dbHelper = DatabaseHelper();
  bool isLoading = false;
  var titleController = TextEditingController();
  var addTitle = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper.initializeDatabase();
    initialData();
  }

  @override
  Widget build(BuildContext context) {
    var flashProvider = Provider.of<FlashProvider>(context);
    var dbProvider = Provider.of<DatabaseHelper>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcard Desk"),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                flashProvider.initialCounter = 0;
                initialData();
              },
              icon: const Icon(Icons.get_app_rounded),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: isLoading
            ? Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                child: const CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  mainAxisExtent: 130,
                ),
                itemCount: flashProvider.titlesList.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.purple,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        visualDensity:
                            const VisualDensity(horizontal: -2, vertical: -2),
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () {
                          titleController.text =
                              flashProvider.titlesList[index];
                          editTitleDialog(
                            context,
                            dbProvider,
                            flashProvider,
                            index,
                          );
                        },
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CardDetail(
                                    sid: flashProvider.fIds[index],
                                    title: flashProvider.titlesList[index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                flashProvider.titlesList[index].length <= 55
                                    ? flashProvider.titlesList[index]
                                    : "${flashProvider.titlesList[index].substring(0, 55)}...",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTitleDialog(context, dbProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> addTitleDialog(
      BuildContext context, DatabaseHelper dbProvider) {
    return showDialog(
      context: context,
      builder: (context) {
        var width = MediaQuery.sizeOf(context).width;
        var height = MediaQuery.sizeOf(context).height;
        return Container(
          width: width / 1,
          height: height / 8,
          padding: const EdgeInsets.all(8),
          child: AlertDialog(
            title: const Text("Add Title"),
            titleTextStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            content: CustomTextFormfield(
              controller: addTitle,
              hint: "Title",
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              CustomButton(
                onPressed: () {
                  if (addTitle.text.isNotEmpty) {
                    dbProvider
                        .addNewTitle(
                      TitleModel(
                        title: addTitle.text,
                      ),
                    )
                        .whenComplete(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added!"),
                        ),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeckList(),
                        ),
                        (route) => false,
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Enter the value"),
                      ),
                    );
                  }
                },
                title: "Save",
                height: 40,
                width: 100,
              )
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> editTitleDialog(
    BuildContext context,
    DatabaseHelper dbProvider,
    FlashProvider flashProvider,
    int index,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          var width = MediaQuery.sizeOf(context).width;
          var height = MediaQuery.sizeOf(context).height;
          return AlertDialog(
            title: const Text("Edit Title"),
            titleTextStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            content: Container(
              width: width / 1,
              height: height / 8,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextFormfield(
                    controller: titleController,
                    hint: "hint",
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              CustomButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    dbProvider
                        .alterTitle(TitleModel(
                      fId: flashProvider.fIds[index],
                      title: titleController.text.toString(),
                    ))
                        .whenComplete(() {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeckList(),
                        ),
                        (route) => false,
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(10),
                        content: const Text("Title is Mandatory"),
                      ),
                    );
                  }
                },
                title: "Save",
                height: 40,
                width: 100,
              ),
              CustomButton(
                onPressed: () {
                  dbProvider
                      .removeTitle(
                    flashProvider.fIds[index],
                  )
                      .whenComplete(() {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeckList(),
                      ),
                      (route) => false,
                    );
                  });
                },
                title: "Delete",
                height: 40,
                width: 100,
              ),
            ],
          );
        });
  }

  void initialData() async {
    var databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);
    var flashProvider = Provider.of<FlashProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    if (flashProvider.initialCounter == 0) {
      DataofJson.data().then((value) {
        for (var i = 0; i < value!.length; i++) {
          databaseHelper.addNewTitle(TitleModel(
            title: value[i].title,
          ));
          for (var j = 0; j < value[i].flashcards.length; j++) {
            databaseHelper.fetchTitles().then((values) async {
              await databaseHelper.addNewFlashcard(
                FlashcardData(
                  fId: flashProvider.isCount == false
                      ? values.last.fId!
                      : values[i].fId! + 3,
                  question: value[i].flashcards[j].question,
                  answer: value[i].flashcards[j].answer,
                ),
              );
            });
          }
        }
      });
      flashProvider.changeCounter();
      flashProvider.initialCounter++;
    }
    await Future.delayed(const Duration(seconds: 1), () async {
      flashProvider.titlesList.clear();
      flashProvider.fIds.clear();
      await databaseHelper.fetchTitles().then((value) {
        for (var data in value) {
          flashProvider.titlesList.add(data.title.toString());
          flashProvider.fIds.add(data.fId!);
        }
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    });
    setState(() {
      isLoading = false;
    });
  }
}
