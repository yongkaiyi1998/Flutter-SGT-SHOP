import 'package:flutter/material.dart';
import 'user.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(PaymentScreen());
 
class PaymentScreen extends StatefulWidget {

  final User user;
  final String orderid, val;
  PaymentScreen({this.user, this.orderid, this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
                    'https://yhkywy.com/sgtshop/php/payment.php?email=' +
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