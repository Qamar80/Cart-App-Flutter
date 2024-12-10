import 'package:cart/cart_model.dart';
import 'package:cart/cart_provider.dart';
import 'package:cart/cart_screen.dart';
import 'package:cart/db_helper.dart';
import 'package:flutter/material.dart'; // Flutter's native Badge
import 'package:badges/badges.dart' as custom_badge;
import 'package:provider/provider.dart'; // Alias the external badges package

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

//initialize the db
  DBHelper? dbHelper=DBHelper();

   List<String> productNames = ['Mango', 'Orange', 'Grapes', 'Banana', 'Chery', 'Peach', 'Mix Frout Basket'];
    List<String> productUnits = ['Kg', 'Dozen', 'Kg', 'Dozen', 'Kg', 'Kg', 'Kg'];
    List<int> productPrices = [10, 20, 30, 40, 50, 60, 70];
   List<String> productImages = [
     'https://upload.wikimedia.org/wikipedia/commons/9/90/Hapus_Mango.jpg', // Mango
     'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg', // Orange
     'https://images.pexels.com/photos/708777/pexels-photo-708777.jpeg', // Grapes
     'https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/e/eb/Owoce_Czere%C5%9Bnia.jpg',
     'https://media.self.com/photos/5b75ad5728dfab53ee567688/4:3/w_2560%2Cc_limit/GettyImages-614938268.jpg', // Peach
     'https://kathyscreativeflowers.com.au/wp-content/uploads/2015/04/Large-Fruit-Basket-e1430629615290.jpg', // Mix Fruit Basket
   ];
  @override
  Widget build(BuildContext context) {
//initialize the cart_provider class because we the functionality of this class
    final cart =Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          // Using the custom_badge from the external package
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            child: Center(

              child: custom_badge.Badge(
                // rebuilt badges widgate which show all the added items
                badgeContent: Consumer<CartProvider>(
            builder: (context, value,child){
              return Text(value.getCounter().toString(),style: const TextStyle(color: Colors.white),);
            }
             ),
                animationDuration: const Duration(microseconds: 300),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),



      //create list of items
      body: Column(
        children: [
          Expanded(child: ListView.builder(
          itemCount: productNames.length
          ,itemBuilder: (context,index){
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                children: [
                  Image(
                    height: 100,
                      width: 100,
                      image: NetworkImage(productImages[index].toString())
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    
                        Text(productNames[index].toString(),
                          style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                    
                        const SizedBox(height: 5,),
                        Text(productUnits[index].toString()  +" "+r"$"+ productPrices[index].toString(),
                          style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                    
                        const SizedBox(height: 5,),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                    //insert data into the db
                            onTap: (){
                      dbHelper!.insert(
                        Cart(id: index,
                            productId: index.toString(),
                            productName:productNames[index].toString(),
                            initialPrice: productPrices[index],
                            productPrice:productPrices[index],
                            quantity: 1,
                            unitTag: productUnits[index].toString(),
                            image: productImages[index].toString())

                      ).then((onValue){
                        print('product is added to cart');

                        //add productPrices to the total price
                        cart.addTotalPrice(double.parse(productPrices[index].toString()));
                      // and increment it
                        cart.addCounter();
                      }).onError((error,stackTrace){
                         print(error.toString());
                      });
                            },


                            child: Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: const Center(
                                child: Text('Add to cart',style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),
                        )
                    
                    
                      ],
                    ),
                  ),

                ],
                            )
                  ],
                ),
              ),
            );
          })),

        ],
      ),
    );
  }
}

