import 'dart:convert';
import 'user.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'orderdetailpart.dart';
import 'package:http/http.dart' as http;
import 'order.dart';


class PaymentHistory extends StatefulWidget {
  final User user;

  const PaymentHistory({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List _paymentdata;
  double screenHeight, screenWidth;
  String titlecenter = "Loading payment history";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;

  @override
  void initState() {
    super.initState();
    _loadPayHis();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Text('Payment History',style: TextStyle(color:Colors.white),),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/main03.jpg'),fit: BoxFit.cover)
        ),
        child: Column(children: <Widget>[
          _paymentdata == null
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
                      itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: InkWell(
                                onTap: () => loadorderdetails(index),
                                child: Card(
                                  color: Colors.purple[100],
                                  elevation: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            (index + 1).toString()+".",
                                            style:
                                                TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "RM " +
                                                _paymentdata[index]['total'],
                                            style:
                                                TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _paymentdata[index]['orderid'],
                                                style: TextStyle(
                                                    color: Colors.pink,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                _paymentdata[index]['billid'],
                                                style: TextStyle(
                                                    color: Colors.pink,fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Text(
                                          f.format(DateTime.parse(
                                              _paymentdata[index]['date'])),
                                          style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),
                                        ),
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

  Future<void> _loadPayHis() async {
    String urlLoadJobs =
        "https://yhkywy.com/sgtshop/php/readpaymenthistory.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadorderdetails(int index) {
    Order order = new Order(
        billid: _paymentdata[index]['billid'],
        orderid: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetail(
                  order: order,
                )));
  }
}
