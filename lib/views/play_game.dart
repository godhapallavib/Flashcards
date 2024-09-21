import 'package:flutter/material.dart';
import 'package:mp3/provider/provider.dart';
import 'package:provider/provider.dart';

class PlayGame extends StatefulWidget {
  final String title;
  final List<String> question;
  final List<String> answer;
  const PlayGame({
    super.key,
    required this.title,
    required this.question,
    required this.answer,
  });

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  bool isChecked = false;
  bool isShow = false;
  int index = 0;
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var flashProvider = Provider.of<FlashProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.title} Quiz"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, [
              flashProvider.card = 1,
              flashProvider.seen = 0,
            ]);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 1,
                height: height * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: isChecked == false
                      ? Colors.purple[100]
                      : Colors.grey[300],
                  child: PageView.builder(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.question.length,
                    onPageChanged: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                    itemBuilder: (context, index) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isChecked ? "Answer" : "Question",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              isChecked
                                  ? widget.answer[index]
                                  : widget.question[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      setState(() {
                        if (_controller.page != 0) {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear,
                          );
                          isChecked = false;
                          isShow = false;
                        }
                      });
                    },
                    child: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isChecked = !isChecked;
                        isShow = !isShow;
                        if (flashProvider.seen < flashProvider.card) {
                          flashProvider.incrementSeenCounter();
                        }
                      });
                    },
                    child: Text(
                      isShow ? "Hide" : "Show",
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      setState(() {
                        if (_controller.page != widget.question.length) {
                          _controller
                              .nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear,
                          )
                              .whenComplete(() {
                            setState(() {
                              if (index != 0) {
                                if (flashProvider.card <
                                    widget.question.length) {
                                  flashProvider.incrementFlashCardCounter();
                                }
                              }
                            });
                          });
                          isChecked = false;
                          isShow = false;
                        }
                      });
                    },
                    child: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Card(
                color: Colors.purple[100],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Seen ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "${flashProvider.card}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: " Cards and Total ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "${widget.question.length}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: " Card",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Seen ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "${flashProvider.seen}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: " Answers from Total ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "${flashProvider.card}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: " Questions",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
