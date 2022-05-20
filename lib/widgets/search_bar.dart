import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function prefixFunction;
  final Function reinitializeListFunction;

  SearchBar(this.prefixFunction, this.reinitializeListFunction);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var _customIcon = const Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: _customIcon,
          onPressed: () {
            if (_customIcon.icon == Icons.search) {
              setState(() {
                _customIcon = const Icon(Icons.cancel);
              });
            } else {
              setState(() {
                widget.reinitializeListFunction();
                _customIcon = const Icon(Icons.search);
              });
            }
          },
        ),
        //This is the text field that appears when the search bar has been pressed
        if (_customIcon.icon != Icons.search)
          Container(
            padding:
                EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2),
            width: MediaQuery.of(context).size.width * 0.75,
            child: Center(
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.name,
                onChanged: (text) {
                  widget.prefixFunction(text.toLowerCase());
                },
              ),
            ),
          ),
      ],
    );
  }
}
