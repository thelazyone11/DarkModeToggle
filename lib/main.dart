import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<AlignmentGeometry> animation;
  late Animation<Color?> colorAnimation;
  String imagePath = "assets/light.png";
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    animation =
        AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerRight)
            .animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInBack),
    );

    colorAnimation =
        ColorTween(begin: Colors.white, end: Color.fromRGBO(31, 26, 36, 1))
            .animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: colorAnimation,
        builder: (context, child) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            color: colorAnimation.value,
            child: Container(
              height: 105,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return InkWell(
                        onTap: () {
                          if (isDark) {
                            animationController.reverse();
                            isDark = false;
                            setState(() {
                              imagePath = "assets/light.png";
                            });
                          } else {
                            animationController.forward();
                            isDark = true;
                            setState(() {
                              imagePath = "assets/dark.png";
                            });
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 110,
                          padding: EdgeInsets.all(5),
                          alignment: animation.value,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  child: child, scale: animation);
                            },
                            child: Container(
                              key: ValueKey<String>(imagePath),
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(imagePath))),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "@_thelazyone_",
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
