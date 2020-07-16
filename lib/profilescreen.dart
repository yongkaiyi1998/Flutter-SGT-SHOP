import 'package:flutter/material.dart';
import 'package:sgtshop/storecredit.dart';
import 'package:sgtshop/user.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';

void main() => runApp(ProfileScreen());

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String server = "https://yhkywy.com/sgtshop";
  double screenHeight, screenWidth;
  final date = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    parsedDate =
        DateTime.parse(widget.user.datereg); //receive date from database
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 5),
              Card(
                color: Colors.purple[200],
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              width: screenWidth / 3.2,
                              height: screenHeight / 4.8,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: server +
                                    "/php/profileimage/${widget.user.email}.jpg?",
                                placeholder: (context, url) => new SizedBox(
                                    height: 10.0,
                                    width: 10.0,
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    new Icon(MdiIcons.camera, size: 64.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Divider(
                        height: 15,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "Store Credit",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text("RM " + widget.user.credit,
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Card(
                    color: Colors.purple[200],
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Table(
                                defaultColumnWidth: FlexColumnWidth(1.0),
                                columnWidths: {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(7),
                                },
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Name",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text(widget.user.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Email",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text(widget.user.email,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Phone",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text(widget.user.phone,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 40,
                                          child: Text("Register Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 40,
                                        child: Text(date.format(parsedDate),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ]),
                                ]),
                          )),
                        ],
                      ),
                    ])),
              ),
              ListView(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  shrinkWrap: true,
                  children: <Widget>[
                    MaterialButton(
                      color: Colors.purple,
                      textColor: Colors.white,
                      onPressed: changeName,
                      child: Text("CHANGE USER NAME"),
                    ),
                    MaterialButton(
                      color: Colors.purple,
                      textColor: Colors.white,
                      onPressed: changePassword,
                      child: Text("CHANGE USER PASSWORD"),
                    ),
                    MaterialButton(
                      color: Colors.purple,
                      textColor: Colors.white,
                      onPressed: changePhone,
                      child: Text("CHANGE USER PHONE"),
                    ),
                    MaterialButton(
                      color: Colors.purple,
                      textColor: Colors.white,
                      onPressed: buyStoreCredit,
                      child: Text("BUY STORE CREDIT"),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }

  void changeName() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@grocery.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.purple[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: new Text(
                "Change name?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: new TextField(
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Name",
                    icon: Icon(
                      Icons.face,
                      color: Colors.white,
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () =>
                        _changeName(nameController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => [Navigator.of(context).pop()],
                ),
              ]);
        });
  }

  void changePassword() {
    if (widget.user.email == "unregistered@sgtshop.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController passController = TextEditingController();
    TextEditingController pass2Controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.purple[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change password?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Old Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      )),
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      controller: pass2Controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'New Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => updatePassword(
                        passController.text, pass2Controller.text)),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => [Navigator.of(context).pop()],
                ),
              ]);
        });
  }

  void buyStoreCredit() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController creditController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.purple[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Buy Store Credit?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: creditController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'RM ',
                    icon: Icon(
                      Icons.monetization_on,
                      color: Colors.white,
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () =>
                        _buyCredit(creditController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => [Navigator.of(context).pop()],
                ),
              ]);
        });
  }

  void changePhone() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to continue", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController phoneController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.purple[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change phone number?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: phoneController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'New Phone Number',
                    icon: Icon(
                      Icons.phone_android,
                      color: Colors.white,
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () =>
                        _changePhone(phoneController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => [Navigator.of(context).pop()],
                ),
              ]);
        });
  }

  _changeName(String name) {
    if (name == "" || name == null) {
      Toast.show("Please enter your new name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ReCase recasename = new ReCase(name);
    print(recasename.titleCase.toString());
    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "name": recasename.titleCase.toString(),
    }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.name = recasename.titleCase;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context, rootNavigator: true).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  updatePassword(String pass1, String pass2) {
    print(pass1 + pass2 + widget.user.email);
    if (pass1 == "" || pass2 == "") {
      Toast.show("Please enter your password again", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "oldpassword": pass1,
      "newpassword": pass2,
    }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = pass2;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context, rootNavigator: true).pop();
        return;
      } else {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context, rootNavigator: true).pop();
      }
    }).catchError((err) {
      print(err);
    });
  }

  _changePhone(String phone) {
    if (phone == "" || phone == null || phone.length < 9) {
      Toast.show("Please enter your new phone number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        setState(() {
          widget.user.phone = phone;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context, rootNavigator: true).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  _buyCredit(String cr) {
    print("RM " + cr);
    if (cr.length <= 0) {
      Toast.show("Please enter correct amount", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.purple[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Buy store credit RM ' + cr,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: new Text(
          'Are you sure?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Toast.show("Update Store Credit after restart", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => StoreCreditScreen(
                              user: widget.user,
                              val: cr,
                            )));
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
