import 'package:flutter/material.dart';
import 'package:sgtshop/loginpage.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
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
                        image: AssetImage('assets/images/splash2.jpg'),
                        fit: BoxFit.cover)),
              
              //decoration: BoxDecoration(color: Colors.black87),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 96,
                    child: CircleAvatar(
                      backgroundColor: Colors.yellow[300],
                      radius: 93,
                      child: Text(
                        ' S.G.T \n Shop',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                            fontFamily: 'Acme',
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ]
                ),

            Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children:<Widget>[
                Padding(
                padding: EdgeInsets.only(top: 220),
                ),
                Text(
                  '  Sport-Game-Toys',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],),

            
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
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()));
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
}
