import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  final String senderAccount;
  final List<String> recipientAddresses;
  final int minValue;
  final int maxValue;

  const Report(
      {Key? key,
      required this.senderAccount,
      required this.minValue,
      required this.maxValue,
      required this.recipientAddresses})
      : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  int invalidAddress = 0;
  int validAddress = 0;
  List filteredCommands = [];

  Widget getLineNumber(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.05, horizontal: 0),
      child: Text("${i + 1}    "),
    );
  }

  Widget message(String element) {
    int minLength = widget.minValue;
    int maxLength = widget.maxValue;
    if (element.trim().isEmpty) {
      invalidAddress++;
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 1.05, horizontal: 0),
        child: Text(
          "Empty",
          style: TextStyle(color: Colors.orange),
        ),
      );
    } else if (filteredCommands.contains(element.trim())) {
      invalidAddress++;

      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 1.05, horizontal: 0),
        child: Text(
          "Duplicate",
          style: TextStyle(color: Colors.red),
        ),
      );
    } else if (element.trim().length < minLength) {
      invalidAddress++;

      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 1.05, horizontal: 0),
        child: Text(
          "< Min Length",
          style: TextStyle(color: Colors.red),
        ),
      );
    } else if (element.trim().length > maxLength) {
      invalidAddress++;

      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 1.05, horizontal: 0),
        child: Text(
          "> Max Length",
          style: TextStyle(color: Colors.red),
        ),
      );
    } else if (element.trim().contains(" ")) {
      invalidAddress++;

      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 1.05, horizontal: 0),
        child: Text(
          "Invalid Address",
          style: TextStyle(color: Colors.red),
        ),
      );
    } else {
      validAddress++;
      filteredCommands.add(element.trim());

      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 1.05, horizontal: 0),
        child: Text(
          "Valid",
          style: TextStyle(color: Colors.green),
        ),
      );
    }
  }

  getListTile() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Report"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.recipientAddresses.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.grey[100],
                            leading: getLineNumber(i),
                            title: SelectableText(widget.recipientAddresses[i]),
                            trailing: message(widget.recipientAddresses[i]),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                    top: BorderSide(color: Colors.grey,width: 1)
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Tokens : ${validAddress + invalidAddress}",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Valid Tokens : ${validAddress}",
                      style: TextStyle(color: Colors.green, fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Invalid Tokens : ${invalidAddress}",
                      style: TextStyle(color: Colors.red, fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
