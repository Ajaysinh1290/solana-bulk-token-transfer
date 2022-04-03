import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:token_transfer/home_page.dart';
import 'package:token_transfer/transfer_tokens.dart';

class Commands extends StatefulWidget {
  List<String> tokens = [];
  String amount;
  String senderAddress;

  Commands(
      {Key? key,
      required this.tokens,
      required this.amount,
      required this.senderAddress})
      : super(key: key);

  @override
  State<Commands> createState() => _CommandsState();
}

class _CommandsState extends State<Commands> {
  getText() {
    String text = '';
    widget.tokens.forEach((element) {
      text +=
          "spl-token transfer ${widget.senderAddress} ${widget.amount} $element \n";
    });
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Commands"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: getText()));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Commands copied to Clipboard"),
                ));
              },
              icon: Icon(Icons.copy))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: getText()),
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                minLines: 100,
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CustomPageRoute(
                          widget: TransferTokens(
                        tokens: widget.tokens,
                        senderAddress: widget.senderAddress,
                        amount: widget.amount,
                      )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Transfer Tokens",
                    style: TextStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
