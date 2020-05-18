import 'package:flutter/foundation.dart';

class MyOrderProvider extends ChangeNotifier{
  bool order = false;

  bool get isOrder => order;

  orderAvailability(){
    print('object $order');
    order = !order;
    notifyListeners();
  }

}