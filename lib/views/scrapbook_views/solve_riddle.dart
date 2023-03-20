import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/auth_views/send_verification.dart';
import 'package:scrap_real/views/scrapbook_views/scrapbook_expanded.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';

class SecretScrapbook extends StatefulWidget {
  final String scrapbookId;
  const SecretScrapbook({Key? key, required this.scrapbookId})
      : super(key: key);

  @override
  State<SecretScrapbook> createState() => _SecretScrapbookState();
}

class _SecretScrapbookState extends State<SecretScrapbook> {
  var scrapbookData = {};
  TextEditingController answerController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    answerController.dispose();
  }

  getData() async {
    var scrapbookSnap = await FirebaseFirestore.instance
        .collection('scrapbooks')
        .doc(widget.scrapbookId)
        .get();

    scrapbookData = scrapbookSnap.data()!;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 50,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomBackButton(
                        buttonFunction: () {
                          Navigator.pop(context);
                        },
                      ),
                      CustomHeader(headerText: 'Secret Scrapbook'),
                      Text(scrapbookData['riddle']),
                      TextFormField(
                        controller: answerController,
                        decoration: const InputDecoration(
                          hintText: 'Answer',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (answerController.text ==
                              scrapbookData['answer']) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScrapbookExpandedView(
                                        scrapbookId: widget.scrapbookId,
                                      )),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Wrong answer!'),
                              ),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
