import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:sgtshop/user.dart';
import 'package:sgtshop/userprofile.dart';
import 'package:sgtshop/adminitem.dart';
import 'package:sgtshop/cart.dart';
import 'paymenthistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'loginpage.dart';

void main() => runApp(MainPage());

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  //bool _visible = false; //search
  double screenHeight, screenWidth;
  String itemtype = "Recent";
  List productdata;
  String titlecenter = "Loading...";
  String server = "https://yhkywy.com/sgtshop";
  String cartquantity = "0";
  bool _isadmin = false;
  bool _isunregistered = false;
  int quantity = 1;
  SharedPreferences prefs;
  int _currentIndex = 1;

  List<String> typelist = [
    'Recent',
    'Game',
    'Table Game',
    'Sport',
    'Toy',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (widget.user.email == "admin@sgtshop.com") {
      _isadmin = true;
    } else if (widget.user.email == "unregistered@sgtshop.com") {
      _isunregistered = true;
    }
  }

  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return LoginPage();
        break;
      case 1:
        return _shopItem();
        break;
      case 2:
        return Cart(
          user: widget.user,
        );
        break;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: mainDrawer(context),
      appBar: AppBar(
        title: Text('SGT SHOP'),
        backgroundColor: Colors.purple[700],
      ),
      body: callPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple[100],
        unselectedItemColor: Colors.deepPurple,
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        selectedFontSize: 15,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Login'),
            //backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_two),
            title: Text('Shop'),
            //backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('My Cart'),
            //backgroundColor: Colors.orange,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  //////drawer//////
  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: Container(
          child: ListView(children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            //color: Colors.purple[200],
            image: DecorationImage(
                image: AssetImage('assets/images/loginregister01.gif'),
                fit: BoxFit.cover),
          ),
          accountName: Text(widget.user.name),
          accountEmail: Text(widget.user.email),

          ///profile picture///
          currentAccountPicture: CircleAvatar(
            backgroundColor:
                Theme.of(context).platform == TargetPlatform.android
                    ? Colors.black
                    : Colors.black,
            backgroundImage: NetworkImage(
                server + "/php/profileimage/${widget.user.email}.jpg?"),
          ),
        ),

        //////list title//////
        ListTile(
          title: Text("Store Credit:   RM " + widget.user.credit,
              style: TextStyle(fontSize: 14.0, color: Colors.black)),
        ),
        Divider(
          height: 2,
          color: Colors.black,
        ),
        Visibility(
          visible: !_isunregistered,
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.people),
                  title: Text(
                    "User Profile",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => [
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserProfile(
                                      user: widget.user,
                                    )))
                      ]),
              ListTile(
                  leading: Icon(Icons.payment),
                  title: Text(
                    "Payment History",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: _paymentScreen),
            ],
          ),
        ),

        ///admin use///
        Visibility(
          visible: _isadmin,
          child: Column(
            children: <Widget>[
              Divider(
                height: 2,
                color: Colors.black,
              ),
              SizedBox(
                height: 5,
              ),
              Text("Admin Use"),
              Center(
                child: Text(
                  "Admin Menu",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                  leading: Icon(Icons.edit),
                  title: Text(
                    "Edit Products",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => [
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => AdminItem(
                                      user: widget.user,
                                    )))
                      ]),
            ],
          ),
        )
      ])),
    );
  }

  //////load data//////
  void _loadData() async {
    String urlLoadJobs = server + "/php/loadSGTproducts.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  //////add to cart dialog//////
  _addtocartdialog(int index) {
    if (widget.user.email == "unregistered@sgtshop.com") {
      Toast.show("Please register to continue", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@sgtshop.com") {
      Toast.show("Admin Mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              backgroundColor: Colors.purple[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: new Text(
                "Add " + productdata[index]['pname'] + " to Cart?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of product",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => [
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            ],
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => [
                              newSetState(() {
                                if (quantity <
                                    (int.parse(
                                            productdata[index]['pquantity']) -
                                        3)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            ],
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                ///add button///
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(index);
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),

                ///cancel button///
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ],
            );
          });
        });
  }

  //////add to cart//////
  void _addtoCart(int index) {
    if (widget.user.email == "unregistered@sgtshop.com") {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@sgtshop.com") {
      Toast.show("Admin mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    try {
      int squantity = int.parse(productdata[index]["pquantity"]);

      print(squantity);
      print(productdata[index]["pid"]);
      print(widget.user.email);

      if (squantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);

        pr.style(message: "Adding to your cart...");
        pr.show();

        String urlLoadJobs = server + "/php/insertcartrecord.php";

        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "proid": productdata[index]["pid"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.dismiss();
        }).catchError((err) {
          print(err);
          pr.dismiss();
        });
        pr.dismiss();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/loadcartrecordquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  //////loading image from database//////
  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.purple[300],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: new Container(
              color: Colors.black,
              height: screenHeight / 1.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth / 1.4,
                      width: screenWidth / 1.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: NetworkImage(server +
                                  "/php/productimage/${productdata[index]['pid']}.jpg")))),
                ],
              ),
            ));
      },
    );
  }

  //////sort process//////
  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "In Searching");
      pr.show();
      String urlLoadJobs = server + "/php/loadSGTproducts.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            productdata = null;
            itemtype = type;
            titlecenter = "Nothing Here!";
          });
          pr.dismiss();
        } else {
          setState(() {
            itemtype = type;
            var extractdata = json.decode(res.body);
            productdata = extractdata["products"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.dismiss();
          });
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  //////nagivate to payment history screen//////
  void _paymentScreen() {
    if (widget.user.email == "unregistered@sgtshop.com") {
      Toast.show("Please register to continue", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@sgtshop.com") {
      Toast.show("Admin mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentHistory(
                  user: widget.user,
                )));
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }

  Widget _shopItem() {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: RefreshIndicator(
        key: refreshKey,
        color: Colors.black,
        onRefresh: () async {
          await refreshList();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/main03.jpg'),
                fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ///product type title///
              Text(
                'Welcome!!!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              productdata == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ))))

                  ///show product list///
                  : Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (screenWidth / screenHeight) / 0.78,
                          children: List.generate(productdata.length, (index) {
                            return Container(
                                ///show product information///
                                child: Card(
                                    color: Colors.purple[100],
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () => _onImageDisplay(index),
                                            child: Container(
                                              height: screenHeight / 5.5,
                                              width: screenWidth / 3.3,
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
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(productdata[index]['pname'],
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.pink)),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "RM " +
                                                productdata[index]['pprice'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink),
                                          ),
                                          Text(
                                            "Quantity available: " +
                                                productdata[index]['pquantity'],
                                            style: TextStyle(
                                              color: Colors.pink,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            height: 35,
                                            child: Text(
                                              'Add to Cart',
                                            ),
                                            color: Colors.purple,
                                            textColor: Colors.white,
                                            elevation: 10,
                                            onPressed: () =>
                                                _addtocartdialog(index),
                                          ),
                                        ],
                                      ),
                                    )));
                          })))
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.purple[500],
        animatedIcon: AnimatedIcons.list_view,
        children: [
          SpeedDialChild(
              backgroundColor: Colors.purple[300],
              child: Icon(MdiIcons.clock),
              label: "Recent",
              labelBackgroundColor: Colors.purple[300],
              onTap: () => _sortItem("Recent")),
          SpeedDialChild(
              backgroundColor: Colors.purple[300],
              child: Icon(MdiIcons.gamepad),
              label: "Game",
              labelBackgroundColor: Colors.purple[300],
              onTap: () => _sortItem("Game")),
          SpeedDialChild(
              backgroundColor: Colors.purple[300],
              child: Icon(MdiIcons.chessKing),
              label: "Table Game",
              labelBackgroundColor: Colors.purple[300],
              onTap: () => _sortItem("Table Game")),
          SpeedDialChild(
              backgroundColor: Colors.purple[300],
              child: Icon(MdiIcons.basketball),
              label: "Sport",
              labelBackgroundColor: Colors.purple[300],
              onTap: () => _sortItem("Sport")),
          SpeedDialChild(
              backgroundColor: Colors.purple[300],
              child: Icon(MdiIcons.toyBrick),
              label: "Toy",
              labelBackgroundColor: Colors.purple[300],
              onTap: () => _sortItem("Toy")),
          SpeedDialChild(
              backgroundColor: Colors.purple[300],
              child: Icon(MdiIcons.accessPoint),
              label: "Other",
              labelBackgroundColor: Colors.purple[300],
              onTap: () => _sortItem("Other")),
        ],
      ),
    );
  }
}
