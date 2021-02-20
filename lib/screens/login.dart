import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_poke_login/modules/CallbackAnimation.dart';
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
  final riveFileName = 'pikachu2.riv';
  Artboard _artboard;
  SimpleAnimation _idle, _wagTail, _uncoverEyes, _coverEyes;
  // CustomAnimator _idleController = CustomAnimator('idle');
  final _formKey = GlobalKey<FormState>();

  bool _coveringEyes = false;
  bool _uncoveringEyes = false;
  bool _waggingTail = false;
  bool _isIdle = true;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  void _replay(CallbackAnimation animation) {
    animation.resetAndStart(_artboard);
  }

  void _reset(SimpleAnimation animation) {
    animation.instance.time = (animation.instance.animation.enableWorkArea
                ? animation.instance.animation.workStart
                : 0)
            .toDouble() /
        animation.instance.animation.fps;
  }

  void _toggleWag(bool value) =>
      setState(() => _wagTail.isActive = _waggingTail = value);

  void _toggleCoverEyes(bool value) =>
      setState(() => _coverEyes.isActive = _coveringEyes = value);

  void _toggleUncoverEyes(bool value) =>
      setState(() => _uncoverEyes.isActive = _uncoveringEyes = value);

  void _toggleIdle(bool value) =>
      setState(() => _idle.isActive = _isIdle = value);

  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      Artboard baseArtboard = file.mainArtboard;
      //Intialize animations
      baseArtboard.addController(_idle = SimpleAnimation('idle'));
      baseArtboard.addController(_coverEyes = SimpleAnimation('cover-eyes'));
      baseArtboard
          .addController(_uncoverEyes = SimpleAnimation('uncover-eyes'));
      baseArtboard.addController(_wagTail = SimpleAnimation('wag-tail'));
      _idle.isActive = _isIdle;
      _coverEyes.isActive = _coveringEyes;
      _uncoverEyes.isActive = _uncoveringEyes;
      _wagTail.isActive = _waggingTail;

      setState(() => _artboard = baseArtboard);
    } else {
      print("Error loading file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxWidth = 400;
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Container(
              color: Colors.white,
              width: screenWidth,
              height: screenHeight,
            ),
            Container(
              color: Colors.blue[300],
              width: screenWidth,
              height: screenHeight,
            ),
            Column(
              children: [
                Center(
                  child: Container(
                    width: maxWidth,
                    height: maxWidth,
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
                top: screenHeight * 0.32,
                child: Container(
                  width: screenWidth,
                  child: Center(
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                      } else {
                                        _toggleIdle(true);
                                        _toggleUncoverEyes(_coveringEyes);
                                        _reset(_coverEyes);
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
                                      } else {
                                        _toggleIdle(false);
                                        _toggleCoverEyes(true);
                                        _reset(_uncoverEyes);
                                      }
                                    },
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          labelText: "Password"),
                                    ),
                                  ),
                                ])),
                            SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                                minWidth: screenWidth,
                                color: Colors.blue,
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/home');
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        )));
  }
}
