import 'package:flutter/cupertino.dart';
import 'package:retrieval/trie.dart';

import '../models/faculty_list.dart';
import '../helpers/FacultyListData.dart';

class FacultyListProvider with ChangeNotifier {
  // Initially, the items array will contain all the faculties
  // along with the coordinates
  Set<FacultyList> _items = FacultyListData.facultyLists.toSet();
  final Trie trieTree = Trie();

  FacultyListProvider() {
    //Initialize the trie tree with all the faculties names
    for (String name in FacultyListData.faculties.keys) {
      trieTree.insert(name);
    }
  }

  List<FacultyList> get items {
    return _items.toList();
  }

  int get count {
    return _items.length;
  }

  void newPrefix(String prefix) {
    //reinitialize the items array with the new values according to prefix
    _items.clear();
    for (String facultyName in trieTree.find(prefix)) {
      _items.add(FacultyListData.faculties[facultyName] as FacultyList);
    }

    //Make sure to notify all listeners
    notifyListeners();
  }

  void reinitializeList() {
    _items = FacultyListData.facultyLists.toSet();

    notifyListeners();
  }
}
