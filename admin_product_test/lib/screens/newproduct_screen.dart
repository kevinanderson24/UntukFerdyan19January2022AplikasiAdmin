import 'dart:async';

import 'package:ebutler/Model/product_model.dart';
import 'package:ebutler/Services/api_product.dart';
import 'package:flutter/material.dart';

class NewNewProduct extends StatefulWidget {
  const NewNewProduct({ Key key }) : super(key: key);

  @override
  _NewNewProductState createState() => _NewNewProductState();
}

class _NewNewProductState extends State<NewNewProduct> {
  List<Product> productList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: ApiProduct.getProduct(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else{
            productList = snapshot.data;
            return Container(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return DataTable(
                    dataTextStyle: TextStyle(fontSize: 12, color: Colors.black),
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey),
                    showBottomBorder: true,
                    dataRowHeight: 130,
                    columns: [
                      DataColumn(label: Text('Id', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      DataRow(cells: [
                        //------------------------------- ID ------------------//
                        DataCell(
                          Container(
                            width: 30,
                            child: Text(productList[index].id),
                          )
                        ),

                        //------------------------------- Image (URL) ------------------//
                        DataCell(
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              productList[index].url, 
                              fit: BoxFit.cover,
                            ),
                          )
                        ),

                        //------------------------------ Name ----------------//
                        DataCell(
                          Container(
                            width: 200,
                            child: Text(productList[index].name),
                          )
                        ),

                        //------------------------------ Price ----------------//
                        DataCell(
                          Container(
                            width: 200,
                            child: Text(productList[index].price.toString()),
                          )
                        ),

                        //------------------------------ Description ----------------//
                        DataCell(
                          Container(
                            width: 200,
                            child: Text(productList[index].description),
                          )
                        ),

                        //---------------------------- Edit Button -------------//
                        DataCell(
                          Container(
                            
                          )
                        ),
                      ])
                    ],
                  );
                },
              ),
            );
          }
        },

      ),
    );
  }
}