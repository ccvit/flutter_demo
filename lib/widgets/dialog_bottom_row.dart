import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogBottomRow extends StatelessWidget {
  final Function cancel;
  final Function submit;
  const DialogBottomRow({required this.cancel, required this.submit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: () => cancel(), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => submit(), child: const Text("Submit")),
        ],
      ),
    );
  }
}
