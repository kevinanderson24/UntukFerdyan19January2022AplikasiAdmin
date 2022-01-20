import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/Model/product_model.dart';
import 'package:ebutler/Screens/ProductScreen/addproduct_screen.dart';
import 'package:ebutler/Screens/updateproduct.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({ Key key }) : super(key: key);

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  CollectionReference products = Firestore.instance.collection('product');
  TextEditingController _nameProductController = TextEditingController();
  TextEditingController _priceProductController = TextEditingController();
  TextEditingController _descriptionProductController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: products.snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

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
                  rows: _buildList(context, snapshot.data.documents),
                );
              },
            ),
          ),
        ],
      ),


      //--------------------- BUTTON (+) ----------------------//
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          //menuju ke page "Add Product"
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }
  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    return DataRow(cells: [
      //----------------------------- ID -------------------------------------//
      DataCell(
        Container(
          width: 30,
          child: Text(data['id'].toString()),
        ),
      ),

      //-------------------------------- IMAGE -------------------------------//
      DataCell(
        Container(
          width: 100,
          height: 100,
          child: Image.network(data['url'].toString(),fit: BoxFit.cover,),
        )
      ),
      //----------------------------NAME -------------------------------------//
      DataCell(
        Container(
          width: 200,
          child: Text(data['name'].toString()),
        ), 
      ),

      //--------------------------- PRICE ----------------------------------//
      DataCell(
        Container(
          width: 100.0,
          child: Text(data['price'].toString()),
        ),
      ),

      //------------- DESCRIPTION --------------------------//
      DataCell(
        Container(
          width: 250,
          child: Text(data['description'].toString()),
        ), 
      ),

      //---------------------- "EDIT BUTTON"----------------------------------//
      DataCell(Container(
        height: 35,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          highlightColor: Colors.orange[100],
          splashColor: Colors.green[100],
          onPressed: () {
            var route = MaterialPageRoute(
              builder: (context) => UpdateProduct(
                value: Product(
                  id: data['id'].toString(),
                  name: data['name'].toString(),
                  price: data['price'],
                  description: data['description'].toString(),
                  url: data['url'].toString(),
                )),
            );
            Navigator.of(context).push(route);
          }, 
          icon: Icon(Icons.update, color: Colors.white, size: 20.0,),
        ),
      )),

      //--------------------- "DELETE BUTTON" --------------------------------//
      DataCell(Container(
        height: 35,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          highlightColor: Colors.orange[100],
          splashColor: Colors.green[100],
          onPressed: () {
            products.document(data.documentID).delete();
          }, 
          icon: Icon(Icons.delete, color: Colors.white, size: 20.0,),
        ),
      )),
    ]);
  }
}