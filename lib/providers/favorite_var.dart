import 'package:flutter/foundation.dart';

class ShowFavorite with ChangeNotifier {
  bool _isFav = false;

  ShowFavorite();

  bool getShowFavValue() => _isFav;

  void toggleFav(bool val) {
    _isFav = val;
    notifyListeners();
  }
}
