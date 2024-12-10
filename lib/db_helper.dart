import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:cart/cart_model.dart';


class DBHelper{

static Database? _db;


//if we already db then not create any db.otherwise create db
  Future<Database?> get db async{
   if(_db !=null){
     //already create
  return _db!;
    }
      _db=await initDatabase();

     }

//create db
      initDatabase()async{
    io.Directory documentDirectory=await getApplicationCacheDirectory();
     //create path in mobile mm and db name
    String path=join(documentDirectory.path, 'cart_db');
        var db=await openDatabase(path,  version: 1,  onCreate: _onCreate);
        return db;
   }
//create table in db
_onCreate (Database db , int version )async{
  await db
      .execute('CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )');
}

//insert data in db
       Future<Cart>insert(Cart cart)async{
             var dbClient=await db;
           await dbClient!.insert('cart', cart.toMap());
            return cart;
                }
//get all data from db
                Future<List<Cart>>getCartList()async{
             var dbClient=await db;
             final  List<Map<String,Object?>> queryResult=await dbClient!.query('cart');
                 return queryResult.map((e)=>Cart.fromMap(e)).toList();
                       }


                       //delete the item
                       Future<int>delete(int id)async{
                       var dbClient=await db;
                       return await dbClient!.delete(
                         'cart',
                         where: 'id=?',
                         whereArgs: [id]

                       );


                       } //update the item
                       Future<int>updateQuantity(Cart cart)async{
                       var dbClient=await db;
                       return await dbClient!.update(
                         'cart',
                         cart.toMap(),
                         where: 'id=?',
                         whereArgs: [cart.id]

                       );
                       }

    }