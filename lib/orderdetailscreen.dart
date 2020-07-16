import 'dart:convert';
import 'package:flutter/material.dart';
import 'order.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  const OrderDetailScreen({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List _orderdetails;
  String titlecenter = "Loading order details";
  double screenHeight, screenWidth;
  String server = "https://yhkywy.com/sgtshop";

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Text('Order Details',style: TextStyle(color:Colors.white),),
      ),
      body: Container(
        decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/main03.jpg'),
                    fit: BoxFit.cover)),
        child: Column(children: <Widget>[
          _orderdetails == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      itemCount:
                          _orderdetails == null ? 0 : _orderdetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: null,
                                child: Card(
                                  color: Colors.purple[100],
                                    elevation: 8,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                (index + 1).toString()+'.',
                                                style: TextStyle(
                                                    color: Colors.pink,fontWeight: FontWeight.bold),
                                              )),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: server +
                                                      "/php/productimage/${_orderdetails[index]['id']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              _orderdetails[index]['name'],
                                              style: TextStyle(
                                                  color: Colors.pink,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              _orderdetails[index]['cquantity'],
                                              style: TextStyle(
                                                  color: Colors.pink,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "RM " +
                                                  _orderdetails[index]
                                                      ['price'],
                                              style: TextStyle(
                                                  color: Colors.pink,fontWeight: FontWeight.bold),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      ),
                                    ))));
                      }))
        ]),
      ),
    );
  }

  _loadOrderDetails() async {
    String urlLoadJobs = "https://yhkywy.com/sgtshop/php/load_carthistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": widget.order.orderid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
