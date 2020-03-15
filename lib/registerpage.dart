import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:sgtshop/loginpage.dart';

void main() => runApp(RegisterPage());
double screenHeight;
bool _isChecked = false;
String urlRegister = "https://yhkywy.com/sgtshop/php/register_user.php";
TextEditingController nameEditingController = new TextEditingController();
TextEditingController emailEditingController = new TextEditingController();
TextEditingController passEditingController = new TextEditingController();
TextEditingController opassEditingController = new TextEditingController();
TextEditingController phoneditingController = new TextEditingController();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Stack(fit: StackFit.expand, children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/login3.jpg'),
                        fit: BoxFit.cover)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        color: Colors.white60,
                        elevation: 0,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black38)),
                                      ),
                                      child: TextField(
                                        controller: nameEditingController,
                                        decoration: InputDecoration(
                                          hintText: "Username",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black38)),
                                      ),
                                      child: TextField(
                                        controller: emailEditingController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          hintText: "Email",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black38)),
                                      ),
                                      child: TextField(
                                        controller: opassEditingController,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                        obscureText: true,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black38)),
                                      ),
                                      child: TextField(
                                        controller: passEditingController,
                                        decoration: InputDecoration(
                                          hintText: "Comfirm Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                        obscureText: true,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black38)),
                                      ),
                                      child: TextField(
                                        controller: phoneditingController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: "Phone Number",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool value) {
                                      _onChange(value);
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: _showEULA,
                                    child: Text('I Agree to Terms  ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                minWidth: 110,
                                height: 45,
                                child: Text('Register'),
                                color: Colors.yellow[300],
                                textColor: Colors.black,
                                elevation: 10,
                                onPressed: _onRegister,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Already register? ",
                                      style: TextStyle(fontSize: 16.0)),
                                  GestureDetector(
                                    onTap: _loginPage,
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
            ])));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and SGT Shop. This EULA agreement governs your acquisition and use of our SGT Shop software (Software) directly from SGT or indirectly through a SGT authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the SGT Shop software. It provides a license to use the SGT Shop software and contains warranty information and liability disclaimers. If you register for a free trial of the SGT Shop software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the SGT Shop software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by SGT Shop here with regardless of whether other software is referred to or described here in. The terms also apply to any SGT Shop updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for SGT Shop shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of SGT Shop. SGT Shop reserves the right to grant licences to use the Software to third parties."
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Close",
              style: TextStyle(
                color: Colors.black,
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
    }

  void _onRegister() {
    String name = nameEditingController.text;
    String email = emailEditingController.text;
    String password = passEditingController.text;
    String opassword = opassEditingController.text;
    String phone = phoneditingController.text;

    if(name.length<8){
      Toast.show("Username must longer than 8 words", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    else if(opassword!=password){
      Toast.show("Password different with Comfirm Password", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else if(email.indexOf('@')<0 || email.indexOf('.com')<0){
      Toast.show("Invalid Email", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else if(phone.substring(0,2)!='01'){
      Toast.show("Invalid Phone Number", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else{

    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(urlRegister, body: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginPage()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });}
  }

  void _loginPage() {
        Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }
}


