import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import 'user.dart';

class StoreCredit extends StatefulWidget {
  final User user;
  final String  val;
  StoreCredit({this.user,  this.val});

  @override
  _StoreCreditState createState() => _StoreCreditState();
}

class _StoreCreditState extends State<StoreCredit> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Buy Store Credit'),
          backgroundColor: Colors.purple[700],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'http://yhkywy.com/sgtshop/php/purchasecreditpart.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.val +
                        '&csc=' +
                        widget.user.credit,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
