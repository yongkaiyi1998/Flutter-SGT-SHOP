import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sgtshop/mainscreen.dart';
import 'package:sgtshop/registerpage.dart';
import 'package:http/http.dart' as http;
import 'package:sgtshop/user.dart';
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
  String server = "https://yhkywy.com/sgtshop";

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          //fit: StackFit.expand, children: <Widget>[
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/loginregister01.gif'),
                    fit: BoxFit.cover)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              SizedBox(
                height: 50,
              ),
              Card(
                color: Colors.white60,
                elevation: 15,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Welcome",
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
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black38)),
                              ),
                              child: TextField(
                                controller: emailEditingController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black38)),
                              ),
                              child: TextField(
                                controller: passEditingController,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
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
                          Text("No account? ", style: TextStyle(fontSize: 15)),
                          GestureDetector(
                            onTap: _registerUser,
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
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
                            onTap: _forgotpassword,
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.purple[300],
                            value: rememberMe,
                            onChanged: (bool value) {
                              _onRememberMeChanged(value);
                            },
                          ),
                          Text('Remember Me ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 110,
                        height: 45,
                        child: Text('Login'),
                        color: Colors.purple,
                        textColor: Colors.white,
                        elevation: 20,
                        onPressed: _userLogin,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '^_^ SGT SHOP SDN BHD',
                  style: TextStyle(),
                ),
              ),
            ]),
          ),
          //]
        ));
  }

  void _userLogin() {
    String email = emailEditingController.text;
    String password = passEditingController.text;

    http.post(urlLogin, body: {
      "email": email,
      "password": password,
    }).then((res) {
      print(res.body);
      var string = res.body;
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
            name: userdata[1],
            email: email,
            password: password,
            phone: userdata[3],
            credit: userdata[4],
            datereg: userdata[5],
            quantity: userdata[6]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: _user,
                    )));
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

  void _forgotpassword() {
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 60,
            child: Column(
              children: <Widget>[
                TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ))
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              textColor: Colors.purple[500],
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              textColor: Colors.purple[500],
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(emailController.text);
                _findpassword(emailController.text);
              },
            ),
          ],
        );
      },
    );
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

  void _findpassword(String email) {
    String _email = email;
    TextEditingController pwdController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Enter new password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                TextField(
                    controller: pwdController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                    ))
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              textColor: Colors.purple[500],
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              textColor: Colors.purple[500],
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _changepassword(_email, pwdController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _changepassword(String ownemail, String newpassword) {
    if (newpassword == "" || newpassword == null || newpassword.length < 6) {
      Toast.show("Please enter more than 6 words new password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    http.post(server + "/php/update_profile.php", body: {
      "email": ownemail,
      "newpassword": newpassword,
    }).then((res) {
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }
}
