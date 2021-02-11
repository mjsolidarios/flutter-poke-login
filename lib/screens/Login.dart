import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class CustomAnimator extends SimpleAnimation {
  CustomAnimator(String animationName) : super(animationName);

  start() {
    isActive = true;
  }

  stop() {
    isActive = false;
  }
}

class _LoginState extends State<Login> {
  final riveFileName = 'assets/pikachu.riv';
  Artboard _artboard;
  RiveAnimationController _controller;
  CustomAnimator _tailController = CustomAnimator('tail-wag');
  CustomAnimator _lookController = CustomAnimator('look-down');
  CustomAnimator _idleController = CustomAnimator('idle');
  CustomAnimator _earsUpController = CustomAnimator('ears-up');
  CustomAnimator _hideEyesController = CustomAnimator('hide-eyes');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _loadRiveFile();

    super.initState();
  }

  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      Artboard baseArtboard = file.mainArtboard;
      baseArtboard.addController(_tailController);
      _tailController.stop();
      baseArtboard.addController(_lookController);
      baseArtboard.addController(_idleController);
      _idleController.stop();
      baseArtboard.addController(_earsUpController);
      setState(() => _artboard = baseArtboard);
    } else {
      print("Error loading file.");
    }
  }

  void _hideEyes(bool on) {
    if (on) {
      _hideEyesController.start();
    } else {
      _hideEyesController.stop();
    }
  }

  void _wagTail(bool on) {
    if (on) {
      _tailController.start();
    } else {
      _tailController.stop();
    }
  }

  void _lookOnEmail(bool on) {
    if (on) {
      _lookController.start();
    } else {
      _lookController.stop();
    }
  }

  void _earsUp(bool on) {
    if (on) {
      _earsUpController.start();
    } else {
      _earsUpController.stop();
    }
  }

  void _idle(bool on) {
    if (on) {
      _idleController.start();
    } else {
      _idleController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                width: screen_width,
                height: screen_height,
              ),
              Container(
                color: Colors.lightBlue,
                width: screen_width,
                height: screen_height * 0.55,
              ),
              Column(
                children: [
                  Center(
                    child: Container(
                      width: screen_width - 10,
                      height: screen_width - 10,
                      child: _artboard != null
                          ? Rive(
                              artboard: _artboard,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: screen_height * 0.45,
                  child: Container(
                    width: screen_width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(children: <Widget>[
                                FocusScope(
                                  onFocusChange: (value) {
                                    if (!value) {
                                      _idle(true);
                                      _lookController.apply(_artboard, -1);
                                    } else {
                                      _lookOnEmail(true);
                                      _hideEyesController.apply(_artboard, -1);
                                    }
                                  },
                                  child: TextFormField(
                                    decoration:
                                        InputDecoration(labelText: "Email"),
                                  ),
                                ),
                                FocusScope(
                                  onFocusChange: (value) {
                                    if (!value) {
                                      _wagTail(true);
                                    } else {
                                      _idle(false);
                                    }
                                  },
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration:
                                        InputDecoration(labelText: "Password"),
                                  ),
                                ),
                              ])),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                              minWidth: screen_width,
                              color: Colors.yellow,
                              child: Text('Login'),
                              onPressed: () {
                                _hideEyes(true);
                              })
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
