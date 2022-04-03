import 'dart:io';

import 'package:flutter/material.dart';

class TransferTokens extends StatefulWidget {
  List<String> tokens = [];
  String amount;
  String senderAddress;

  TransferTokens(
      {Key? key,
      required this.tokens,
      required this.amount,
      required this.senderAddress})
      : super(key: key);

  @override
  State<TransferTokens> createState() => _TransferTokensState();
}

class _TransferTokensState extends State<TransferTokens> {
  int totalCommands = 0;
  int currentCommand = 0;
  String consoleText = '';
  List successFullTokens = [];
  List unSuccessFullTokens = [];
  bool isStarted = false;
  TextEditingController consoleTextController =
      TextEditingController(text: " ");
  TextEditingController successFullTransactions =
      TextEditingController(text: " ");
  TextEditingController unSuccessFullTransactions =
      TextEditingController(text: " ");
  ScrollController consoleController = ScrollController();
  ScrollController successFullController = ScrollController();
  ScrollController unSuccessFullController = ScrollController();

  startTransferring() {
    if (currentCommand == totalCommands) return;
    consoleText +=
            "Transferring ${widget.amount} tokens to ${widget.tokens[currentCommand]}...\n";
    consoleTextController.text = consoleText;
    Process.run('spl-token', [
      'transfer',
      widget.senderAddress,
      widget.amount,
      widget.tokens[currentCommand]
    ]).then((result) {
      consoleText += "${result.stdout + result.stderr}\n";

      consoleTextController.text = consoleText;
      String token = widget.tokens[currentCommand];
      if (result.stdout.toString().contains("Signature")) {
        successFullTransactions.text += token + "\n";
        successFullTokens.add(token);
      } else {
        unSuccessFullTransactions.text += token + "\n";
        unSuccessFullTokens.add(token);
      }

      currentCommand++;
      consoleController.animateTo(
          consoleController.position.maxScrollExtent + 200,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
      successFullController.animateTo(
          successFullController.position.maxScrollExtent + 200,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
      unSuccessFullController.animateTo(
          unSuccessFullController.position.maxScrollExtent + 200,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
      setState(() {});

      startTransferring();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalCommands = widget.tokens.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer Tokens"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            isStarted
                ? currentCommand == totalCommands
                    ? Text(
                        "Task Completed",
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      )
                    : SelectableText(
                        "spl-token transfer ${widget.senderAddress} ${widget.amount} ${widget.tokens[currentCommand]}",
                        style: TextStyle(fontSize: 18, color: Colors.black))
                : Text("Click on start to button to start transactions",
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$currentCommand / $totalCommands",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "${((currentCommand / totalCommands) * 100).toStringAsFixed(2)} %",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            LinearProgressIndicator(
                value: currentCommand / totalCommands,
                backgroundColor: Colors.grey[100],
                color: Colors.green,
                minHeight: 50,
                semanticsLabel: "${(currentCommand / totalCommands) * 100}",
                semanticsValue: "${(currentCommand / totalCommands) * 100}"),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: consoleTextController,
                      readOnly: true,
                      minLines: 100,
                      scrollController: consoleController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: "Console", border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: successFullTransactions,
                          readOnly: true,
                          minLines: 100,
                          scrollController: successFullController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              labelText: "Successfull Transactions ${successFullTokens.length}",
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: unSuccessFullTransactions,
                          readOnly: true,
                          minLines: 100,
                          scrollController: unSuccessFullController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              labelText: "Unsuccessfull Transactions ${unSuccessFullTokens.length}",
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (!isStarted)
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    isStarted = true;
                    setState(() {});
                    startTransferring();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Start",
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
