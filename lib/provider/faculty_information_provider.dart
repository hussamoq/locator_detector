import 'package:flutter/foundation.dart';
import 'package:quiver/collection.dart';
import 'package:retrieval/trie.dart';

import '../models/employee.dart';

//handles the refreshment of the faculty information screen
class FacultyInformationProvider with ChangeNotifier {
  Set<Employee> interchangableEmployeesList = <Employee>{};
  final _findEmployee = SetMultimap<String, Employee>();
  var _trieTree = Trie();

  //Refreshes the faculty screen each time a new
  //employee is added
  void addEmployee(Employee employee) {
    //Add initial values into the interchangable list
    interchangableEmployeesList.add(employee);

    //create a concatenated first and last name
    String firstLast =
        ('${employee.firstName} ${employee.lastName}').toLowerCase();

    //split first and last name between spaces to add to the multimap
    //and trie tree making it possible to search starting from last name
    for (String str in firstLast.split(' ')) {
      _findEmployee.add(str, employee);
      _trieTree.insert(str);
    }

    //Not to forget to add the concatenated first name and last name
    //to the hashmap as a whole
    _findEmployee.add(firstLast, employee);
    _trieTree.insert(firstLast);

    notifyListeners();
  }

  //converts the interchangable employee list into a list before sending it
  //to caller therefore sending a copy
  List<Employee> get employees {
    return interchangableEmployeesList.toList();
  }

  //property
  int get count {
    return interchangableEmployeesList.length;
  }

  void addPrefix(String prefix) {
    //add every employee name that starts with the prefix
    //provided by the user

    //Clearing the list to add new values into it
    interchangableEmployeesList.clear();

    //find every word that starts with the prefix
    //specified by the user
    for (String employeeName in _trieTree.find(prefix)) {
      //Add all the values pointed by the multimap
      interchangableEmployeesList.addAll(_findEmployee[employeeName].toList());
    }

    notifyListeners();
  }

  void reinitializeList() {
    //reinitialize the list to the original employee list
    //after pressing the X button beside the search bar
    interchangableEmployeesList.clear();
    interchangableEmployeesList.addAll(_findEmployee.values);

    notifyListeners();
  }

  void emptyList() {
    //After going back to the home screen, this function should be
    //invoked to clear out all the data structures or else detecting again
    //would keep the last copy of employees preset

    _findEmployee.clear();
    interchangableEmployeesList.clear();
    _trieTree = Trie();
  }
}
