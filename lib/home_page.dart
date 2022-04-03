import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:token_transfer/commands.dart';
import 'package:token_transfer/report.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController senderAddressController = TextEditingController(
      text: "3pVGSD3L4n35kcC6m6Z8rmG5j4q7Uq8NvEVPmc9CwrxZ");
  TextEditingController amountController = TextEditingController(text: "500");
  TextEditingController recipientAddressController = TextEditingController();
  TextEditingController minLengthController = TextEditingController(text: "40");
  TextEditingController maxLengthController = TextEditingController(text: "80");
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // recipientScrollController.addListener(() {
    //   lineScrollController.jumpTo(recipientScrollController.offset);
    //   messageScrollController.jumpTo(recipientScrollController.offset);
    // });
  }

  String? nameValidator(String? text) {
    if (text?.trim().isEmpty ?? true) {
      return "This Field is required";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: senderAddressController,
                      validator: nameValidator,
                      decoration: InputDecoration(
                          labelText: "Sender Address",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: nameValidator,
                      controller: amountController,
                      decoration: InputDecoration(
                          labelText: "Amount", border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: nameValidator,
                      controller: minLengthController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {});
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      // Only numbe
                      decoration: InputDecoration(
                          labelText: "Min Length of Recipient Addresses",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: nameValidator,
                      controller: maxLengthController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        setState(() {});
                      },
                      // Only numbe
                      decoration: InputDecoration(
                          labelText: "Max Length of Recipient Addresses",
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Recipient Addresses",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TextFormField(
                  maxLines: null,
                  minLines: 100,
                  validator: nameValidator,
                  controller: recipientAddressController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("Report"),
                        ),
                        onPressed: generateReport),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("Create Commands"),
                        ),
                        onPressed: createCommands),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createCommands() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    String text = recipientAddressController.text;
    if (text.isEmpty) return;

    List<String> commands = text.split("\n");
    List<String> filteredCommands = [];
    int minLength = int.parse(minLengthController.text.trim());
    int maxLength = int.parse(maxLengthController.text.trim());
    for (var element in commands) {
      if (element.trim().isNotEmpty &&
          element.trim().length >= minLength &&
          element.trim().length <= maxLength &&
          !element.trim().contains(" ") &&
          !filteredCommands.contains(element.trim())) {
        String command = element.trim();
        filteredCommands.add(command);
      }
    }
    if (filteredCommands.isNotEmpty) {
      Navigator.push(
          context,
          CustomPageRoute(
              widget: Commands(
                tokens: filteredCommands,
                amount: amountController.text.trim(),
                senderAddress: senderAddressController.text.trim(),
              ),
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No valid tokens found"),
      ));
    }
  }

  void generateReport() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    String text = recipientAddressController.text;
    if (text.isEmpty) return;
    List<String> commands = text.split("\n");
    print("Pushing");
    Navigator.push(
        context,
        CustomPageRoute(
            widget: Report(
                senderAccount: senderAddressController.text.trim(),
                minValue: int.parse(minLengthController.text.trim()),
                maxValue: int.parse(maxLengthController.text.trim()),
                recipientAddresses: commands),
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut));
  }
}

Route SimpleRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;
  final Curve? curve;
  final Duration? duration;
  final Alignment? alignment;

  //
  // CustomPageRoute(
  //     {this.alignment,
  //     this.duration,
  //     this.curve,
  //     required,
  //     required this.widget})
  //     : super(builder: (context) => widget);
  CustomPageRoute(
      {this.alignment, this.duration, this.curve, required this.widget})
      : super(
            transitionDuration: duration ?? Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondAnimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: curve ?? Curves.easeOutExpo);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: alignment ?? Alignment.center,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondAnimation) {
              return widget;
            });
}
