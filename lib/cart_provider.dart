import 'package:cart/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_model.dart';

class CartProvider with ChangeNotifier{
  //initialize the db
   DBHelper db=DBHelper();

      int _counter=0;
      int get counter=>_counter;

      double _totalPrice=0.0;
      double get totalPrice=>_totalPrice;

// get all data of cart list in cart_screen
      late Future<List<Cart>> _cart;
       Future<List<Cart>> get cart =>_cart;

       Future<List<Cart>>getData()async{
         _cart= db.getCartList();
         return _cart;
       }


      // if we have already any thing in db then maintain it in db
  void _setPrefItem()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
 prefs.setInt('cart_item', _counter);
 prefs.setDouble('total_price', _totalPrice);
 notifyListeners();
  }
  // if we have already any thing in db then we show from db by this fun
  void _getPrefItem()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    _counter=prefs.getInt('cart_item')  ??  0;
    _totalPrice=prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  // if we add to card then increment it
void  addCounter(){
    _counter++;
    _setPrefItem();
    notifyListeners();
}
  // if we remove from card then decrement it
void  removeCounter(){
    _counter--;
    _setPrefItem();
    notifyListeners();
}
//if we add or remove some thing from cart and again show item
int  getCounter(){
    _getPrefItem();
    return _counter;
}


//if we add some things in cart than we add their price with total price
void  addTotalPrice(double productprice){
    _totalPrice=_totalPrice+productprice;
    _setPrefItem();
    notifyListeners();
}

//if we remove some things from cart than we remove their price from total price
void  removeTotalPrice(double productprice){
  _totalPrice=_totalPrice-productprice;
    _setPrefItem();
    notifyListeners();
}
//get total prices
double  gettotalPrice(){
    _getPrefItem();
    return _totalPrice;
}



}