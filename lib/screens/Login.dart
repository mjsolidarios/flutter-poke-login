import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final riveFileName = 'assets/pikachu.riv';
  Artboard _artboard;
  RiveAnimationController _controller;

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
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation('idle'),
        ));
    } else {
      print("Error loading file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(
            child: Column(
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
                    : Text("data"),
              ),
            ),
            MaterialButton(
                child: Text('Login'),
                onPressed: () => {
                      //Navigator.pushNamed(context, '/home')
                    })
          ],
        )));
  }
}
