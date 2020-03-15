import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sgtshop/registerpage.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(LoginPage());
bool rememberMe = false;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double screenHeight;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passEditingController = new TextEditingController();
  String urlLogin = "https://yhkywy.com/sgtshop/php/login_user.php";

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
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
                                "Login",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
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
                                        controller: passEditingController,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                        obscureText: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("No account? ",
                                      style: TextStyle(fontSize: 15)),
                                  GestureDetector(
                                    onTap: _registerUser,
                                    child: Text(
                                      "Create Account",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Forgot password? ",
                                      style: TextStyle(fontSize: 15)),
                                  GestureDetector(
                                    onTap: _forgotPassword,
                                    child: Text(
                                      "Reset Password",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Checkbox(
                                    value: rememberMe,
                                    onChanged: (bool value) {
                                      _onRememberMeChanged(value);
                                    },
                                  ),
                                  Text('Remember Me ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                minWidth: 110,
                                height: 45,
                                child: Text('Login'),
                                color: Colors.yellow[300],
                                textColor: Colors.black,
                                elevation: 20,
                                onPressed: _userLogin,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 64,
                        child: CircleAvatar(
                          backgroundColor: Colors.yellow[300],
                          radius: 62,
                          child: Text(
                            ' S.G.T \n Shop',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontFamily: 'Acme',
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 545),
                      )
                    ]),
              ),
            ])));
  }

  void _userLogin() {
    String email = emailEditingController.text;
    String password = passEditingController.text;

    http.post(urlLogin, body: {
      "email": email,
      "password": password,
    }).then((res) {
      if (res.body == "success") {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
        Toast.show("Login success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Login failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
  }

  void _forgotPassword() {
    TextEditingController email2Controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  'Enter Your Email',
                ),
                TextField(
                    decoration: InputDecoration(
                  labelText: 'Email',
                ))
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  email2Controller.text,
                );
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit?'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text('Exit')),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Cancel')),
            ],
          ),
        ) ??
        false;
  }

  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        emailEditingController.text = email;
        passEditingController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = emailEditingController.text;
    String password = passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        emailEditingController.text = '';
        passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
