import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOfItem = 0;
  int get numberOfItems => _numberOfItem;

  display(int no) {
    _numberOfItem = no;
    notifyListeners();
  }
}
