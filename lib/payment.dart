import 'package:flutter/material.dart';
import 'user.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(Payment());
 
class Payment extends StatefulWidget {

  final User user;
  final String orderid, val;
  Payment({this.user, this.orderid, this.val});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
        appBar: AppBar(
          title: Text('Payment',style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.purple[700],
        ),
        body: Column(
          children: <Widget>[Expanded(
              child: WebView(
                initialUrl:
                    'https://yhkywy.com/sgtshop/php/paymentProcess.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.val +
                        '&orderid=' +
                        widget.orderid,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )],
        ),
      );
  }
}