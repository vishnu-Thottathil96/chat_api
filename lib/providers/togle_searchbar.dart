import 'package:flutter/material.dart';

class ToggleSearchBarProvider with ChangeNotifier {
  bool _showSearch = false;

  bool get showSearch => _showSearch;

  void toggleSearchBar() {
    _showSearch = !_showSearch;
    notifyListeners();
  }
}
