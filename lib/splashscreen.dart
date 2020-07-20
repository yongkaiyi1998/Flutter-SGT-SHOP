import 'package:flutter/material.dart';
import 'package:sgtshop/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

void main() => runApp(SplashScreen());
Widget randomScreen(int max) {
  var rnd = Random();
  var num = rnd.nextInt(max) + 1;
  print(num);
  switch (num) {
    case 1:
      return SplashScreen1();
      break;
    case 2:
      return SplashScreen2();
      break;
    default:
      return SplashScreen3();
      break;
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: randomScreen(3)
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////
class SplashScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/splash04.gif'),
                      fit: BoxFit.cover)),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 96,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 93,
                      child: Text(
                        ' S.G.T \n Shop',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            fontFamily: 'Acme',
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 220),
                ),
                Text(
                  '  Sport-Game-Toys',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              new ProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(bottom: 50),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////
class SplashScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/main03.jpg'),
                      fit: BoxFit.cover)),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 96,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 93,
                      child: Text(
                        ' S.G.T \n Shop',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontFamily: 'Acme',
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 220),
                ),
                Text(
                  '  Sport-Game-Toys',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              new ProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(bottom: 50),
              )
            ]),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////
class SplashScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/main04.jpg'),
                      fit: BoxFit.cover)),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 96,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 93,
                      child: Text(
                        ' S.G.T \n Shop',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontFamily: 'Acme',
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 220),
                ),
                Text(
                  '  Sport-Game-Toys',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              new ProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(bottom: 50),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////
class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            controller.stop();
            loadpref(this.context);
            //Navigator.pushReplacement(
            //    context,
            //    MaterialPageRoute(
            //        builder: (BuildContext context) => MainScreen()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
            width: 200,
            color: Colors.blueGrey,
            child: LinearProgressIndicator(
              value: animation.value,
              backgroundColor: Colors.white,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
            )));
  }

  //////auto login step//////
  void loadpref(BuildContext ctx) async {
    print('Inside loadpref()');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email') ?? '');
    String pass = (prefs.getString('pass') ?? '');
    print("Splash:Preference" + email + "/" + pass);
    if (email.length > 5) {
      //login with email and password
      loginUser(email, pass, ctx);
    } else {
      loginUser("unregistered", "123456789", ctx);
    }
  }

  //////load user data//////
  void loginUser(String email, String pass, BuildContext ctx) {
    http.post("https://yhkywy.com/sgtshop/php/loginUserPart.php", body: {
      "email": email,
      "password": pass,
    })
        .then((res) {
      print(res.body);
      var string = res.body;
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
            name: userdata[1],
            email: email,
            password: pass,
            phone: userdata[3],
            credit: userdata[4],
            datereg: userdata[5],
            quantity: userdata[6]);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(
                      user: _user,
                    )));
      } else {
        Toast.show(
            "Fail to login. Login as unregistered account.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        loginUser("unregistered@sgtshop.com", "123456789", ctx);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
