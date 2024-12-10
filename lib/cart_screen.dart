import 'package:cart/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'cart_provider.dart';
import 'db_helper.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


  @override
  Widget build(BuildContext context) {
//initialize the db
      DBHelper? dbHelper=DBHelper();

//initialize the cart_provider class because we the functionality of this class
    final cart =Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          // Using the custom_badge from the external package
          Center(
            child: custom_badge.Badge(
              badgeContent: Consumer<CartProvider>(
                  builder: (context, value,child){
                    return Text(value.getCounter().toString(),style: const TextStyle(color: Colors.white),);
                  }
              ),
              animationDuration: const Duration(microseconds: 300),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData() ,
                builder:(context, AsyncSnapshot<List<Cart>> snapshot){
               if(snapshot.hasData){

                 if(snapshot.data!.isEmpty){
                   return  const Expanded(
                     child: Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Center(child: Image(image: AssetImage('images/empty_cart.jpg'))),
                           SizedBox(height: 20,),
                           Text('Explore Product'),
                         ],
                       ),
                     ),
                   );
                 }else{
                   return Expanded(
                       child: ListView.builder(
                           itemCount: snapshot.data!.length,
                           itemBuilder: (context,index){
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
                                             image: NetworkImage(snapshot.data![index].image.toString())
                                         ),
                                         const SizedBox(width: 20,),
                                         Expanded(
                                           child: Column(
                                             mainAxisAlignment: MainAxisAlignment.start,
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [

                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(snapshot.data![index].productName.toString(),
                                                     style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                                   InkWell(
                                                       onTap: (){
                                                         //delete item
                                                         dbHelper!.delete(snapshot.data![index].id!);
                                                         //decrement value in badges
                                                         cart.removeCounter();
                                                         //remove the price
                                                         cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                       },
                                                       child: const Icon(Icons.delete))
                                                 ],
                                               ),


                                               const SizedBox(height: 5,),
                                               Text(snapshot.data![index].unitTag.toString()  +" "+r"$"+ snapshot.data![index].productPrice.toString(),
                                                 style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                               const SizedBox(height: 5,),
                                               Align(
                                                 alignment: Alignment.centerRight,
                                                 child: InkWell(

                                                   onTap: (){

                                                   },


                                                   child: Container(
                                                     height: 30,
                                                     width: 100,
                                                     decoration: BoxDecoration(
                                                         color: Colors.green,
                                                         borderRadius: BorderRadius.circular(5)
                                                     ),
                                                     child:  Padding(
                                                       padding: const EdgeInsets.all(4.0),
                                                       child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                         children: [
                                                           InkWell(
                                                               onTap: (){
                                                                 int quantity=snapshot.data![index].quantity!;
                                                                 int price=snapshot.data![index].initialPrice!;
                                                                 quantity--;
                                                                 int? newprice=price*quantity;
                                                                 if(quantity>0){
                                                                   dbHelper.updateQuantity(Cart(
                                                                       id: snapshot.data![index].id!,
                                                                       productId: snapshot.data![index].id.toString(),
                                                                       productName: snapshot.data![index].productName!,
                                                                       initialPrice: snapshot.data![index].initialPrice!,
                                                                       productPrice: newprice,
                                                                       quantity: quantity,
                                                                       unitTag: snapshot.data![index].unitTag.toString(),
                                                                       image: snapshot.data![index].image.toString())
                                                                   ).then((Value){
                                                                     newprice=0;
                                                                     quantity=0;
                                                                     cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                   }).onError((error,stackTrace){
                                                                     print(error.toString());
                                                                   });
                                                                 }
                                                               }
                                                               ,child: Icon(Icons.remove,color: Colors.white,)),
                                                           Text(snapshot.data![index].quantity.toString() ,style: TextStyle(color: Colors.white),),
                                                           InkWell(

                                                               onTap: (){

                                                                 int quantity=snapshot.data![index].quantity!;
                                                                 int price=snapshot.data![index].initialPrice!;

                                                                 quantity++;
                                                                 int? newprice=price*quantity;
                                                                 dbHelper.updateQuantity(Cart(
                                                                     id: snapshot.data![index].id!,
                                                                     productId: snapshot.data![index].id.toString(),
                                                                     productName: snapshot.data![index].productName!,
                                                                     initialPrice: snapshot.data![index].initialPrice!,
                                                                     productPrice: newprice,
                                                                     quantity: quantity,
                                                                     unitTag: snapshot.data![index].unitTag.toString(),
                                                                     image: snapshot.data![index].image.toString())
                                                                 ).then((Value){
                                                                   newprice=0;
                                                                   quantity=0;
                                                                   cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                 }).onError((error,stackTrace){
                                                                   print(error.toString());
                                                                 });
                                                               }
                                                               ,child: Icon(Icons.add,color: Colors.white,)),
                                                         ],
                                                       ),
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
                           })
                   );
                 }
               }
         return const Text('jb');
            }),


            //show all prices of products
            Consumer<CartProvider>(builder: (context,value,child){
              return Visibility(
                visible: value.gettotalPrice().toStringAsFixed(2)=='0.00'?false:true,
                child: Column(
                  children: [
                    ReuseableWidget(title: 'Sub Total', value: r'$'+value.gettotalPrice().toStringAsFixed(2),),
                    ReuseableWidget(title: 'Discount 5%', value: r'$'+'20',),
                    ReuseableWidget(title: 'Total', value: r'$'+value.gettotalPrice().toStringAsFixed(2),),

                  ],
                ),
              );

            })
          ],
        ),
      ),

    );
  }
}


class ReuseableWidget extends StatelessWidget {

  final String title, value;

  const ReuseableWidget({required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: Theme.of(context).textTheme.labelLarge,),
          Text(value.toString(),style: Theme.of(context).textTheme.labelLarge,)

        ],
      ),
    );
  }
}
