import 'package:example_cpl/kepler_api.dart';
import 'package:flutter/material.dart';

class Hub extends StatefulWidget {
  final String name;

  const Hub(this.name, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _Hub(name);
  }
}

class _Hub extends State<Hub> {
  final String name;
  _Hub(this.name);
  int _counter = 0;

  incrementCounter() {
    KeplerApi keplerApi = KeplerApi();
    keplerApi.getDataOfAllPlanets();
    _counter++;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> columnChildren = [
      Text("Hello " + name + "!"),
    ];
    if (!name.contains("Dr. Krupp")) {
      columnChildren.add(Text("Here is the counter: " + _counter.toString()));
      columnChildren.add(ElevatedButton(onPressed: incrementCounter, child: const Text("Press me!")));
    } else {
      columnChildren.add(const Text("Give us an A!"));
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: columnChildren),
      ),
    );
  }

}
