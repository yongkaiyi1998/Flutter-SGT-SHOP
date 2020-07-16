import 'package:flutter/material.dart';
import 'package:sgtshop/user.dart';
import 'product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'newproduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'editproduct.dart';

void main() => runApp(AdminProduct());

class AdminProduct extends StatefulWidget {
  final User user;

  const AdminProduct({Key key, this.user}) : super(key: key);

  @override
  _AdminProductState createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  bool _visible = false;
  String cartquantity = "0";
  double screenHeight, screenWidth;
  List productdata;
  String titlecenter = "Loading products";
  String server = "https://yhkywy.com/sgtshop";
  var _tapPosition;
  String scanPrId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Text('Manage Product',
            style: TextStyle(
              color: Colors.white,
            )),

        ///visible///
        actions: <Widget>[
          IconButton(
            icon: _visible
                ? new Icon(Icons.youtube_searched_for)
                : new Icon(Icons.search),
            onPressed: () {
              setState(() {
                if (_visible) {
                  _visible = false;
                } else {
                  _visible = true;
                }
              });
            },
          ),

          //
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/main03.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
                visible: _visible,
                child: Card(
                  color: Colors.purple[300],
                  elevation: 5,
                  child: Container(
                    height: screenHeight / 12.5,
                    margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                            child: Container(
                          height: 30,
                          child: TextField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              autofocus: false,
                              controller: _prdController,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  icon: Icon(Icons.search),
                                  border: OutlineInputBorder())),
                        )),
                        Flexible(
                            child: MaterialButton(
                                color: Colors.purple,
                                onPressed: () =>
                                    [_sortItembyName(_prdController.text)],
                                elevation: 5,
                                child: Text(
                                  "Search",
                                  style: TextStyle(color: Colors.white),
                                )))
                      ],
                    ),
                  ),
                )),
            productdata == null
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
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.65,
                        children: List.generate(productdata.length, (index) {
                          return Container(
                              child: InkWell(
                                  onTap: () => _showPopupMenu(index),
                                  onTapDown: _storePosition,
                                  child: Card(
                                      color: Colors.purple[100],
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              color: Colors.black,
                                              height: screenHeight / 5.9,
                                              width: screenWidth / 3.5,
                                              child: GestureDetector(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: server +
                                                      "/php/productimage/${productdata[index]['pid']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Text(productdata[index]['pname'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pink)),
                                            Text(
                                              "RM " +
                                                  productdata[index]['pprice'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.pink),
                                            ),
                                            Text(
                                              "Available-Sold:" +
                                                  productdata[index]
                                                      ['pquantity'] +
                                                  "-" +
                                                  productdata[index]['sold'],
                                              style: TextStyle(
                                                color: Colors.pink,
                                              ),
                                            ),
                                            Text(
                                              "Weight:" +
                                                  productdata[index]
                                                      ['pweigth'] +
                                                  " gram",
                                              style: TextStyle(
                                                color: Colors.pink,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))));
                        })))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          child: Icon(Icons.add),
          onPressed: () {
            createNewProduct();
          }),
    );
  }

  void scanProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Select scan options:",
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                  color: Colors.orange,
                  onPressed: scanBarcodeNormal,
                  elevation: 5,
                  child: Text(
                    "Bar Code",
                    style: TextStyle(color: Colors.black),
                  )),
              MaterialButton(
                  color: Colors.orange,
                  onPressed: scanQR,
                  elevation: 5,
                  child: Text(
                    "QR Code",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanPrId = "";
      } else {
        scanPrId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanPrId);
      }
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanPrId = "";
      } else {
        scanPrId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanPrId);
      }
    });
  }

  void _loadSingleProduct(String prid) {
    String urlLoadJobs = server + "/php/load_products.php";
    http.post(urlLoadJobs, body: {
      "prid": prid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        Toast.show("Not found", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          print(productdata);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              productdata = extractdata["products"];
              FocusScope.of(context).requestFocus(new FocusNode());
              pr.dismiss();
            });
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  [Navigator.of(context).pop(), _onProductDetail(index)],
              child: Text(
                "Update Product?",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  [Navigator.of(context).pop(), _deleteProductDialog(index)],
              child: Text(
                "Delete Product?",
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
      elevation: 10.0,
    );
  }

  void _deleteProductDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: new Text(
            "Delete Product ID " + productdata[index]['pid'],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting product");
    pr.show();
    String prid = productdata[index]['pid'];
    print("prid:" + prid);
    http.post(server + "/php/delete_product.php", body: {
      "prodid": prid,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData();
        Navigator.of(context).pop();
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  _onProductDetail(int index) async {
    print(productdata[index]['pname']);
    Product product = new Product(
        pid: productdata[index]['pid'],
        pname: productdata[index]['pname'],
        pprice: productdata[index]['pprice'],
        pquantity: productdata[index]['pquantity'],
        pweigth: productdata[index]['pweigth'],
        ptype: productdata[index]['ptype'],
        date: productdata[index]['date']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditProduct(
                  user: widget.user,
                  product: product,
                )));
    _loadData();
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Future<void> createNewProduct() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewProduct()));
    _loadData();
  }

  void _loadData() {
    String urlLoadJobs = server + "/php/load_products.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
        cartquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }
}
