import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTextBox extends StatelessWidget {
  final TextEditingController searchController;
  final Function doKeywordPlanetSearch;
  const SearchTextBox({required this.searchController,required this.doKeywordPlanetSearch, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: searchController,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: "Search ...",
      ),
      onSubmitted: (result) {
        doKeywordPlanetSearch(result);
      },
    );
  }
}
