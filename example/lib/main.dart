import 'package:flutter/material.dart';
import 'package:edge_alert/edge_alert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edge Alert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Edge Alert'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final longDesc =
      "This is very long description This is very long description This is very long description This is very long description This is very long description";

  void _showAlert(bool isFromTop) {
    EdgeAlert.show(context,
        title: 'Title',
        backgroundColor: Colors.grey,
        duration: EdgeAlert.LENGTH_SHORT,
        icon: Icons.error,
        description: 'Description',
        gravity: isFromTop ? EdgeAlert.TOP : EdgeAlert.BOTTOM);
  }

  void _colorfullAlert() {
    EdgeAlert.show(context,
        title: 'Title',
        icon: Icons.error,
        duration: EdgeAlert.LENGTH_SHORT,
        description: 'Description',
        gravity: EdgeAlert.TOP,
        backgroundColor: Colors.red);
  }

  void _longDescAlert() {
    EdgeAlert.show(
      context,
      title: 'Title',
      description: longDesc,
      backgroundColor: Colors.red,
      duration: EdgeAlert.BOTTOM,
      icon: Icons.verified,
      gravity: EdgeAlert.TOP,
    );
  }

  void _differentIcon() {
    EdgeAlert.show(context,
        title: 'Title',
        backgroundColor: Colors.green,
        duration: EdgeAlert.LENGTH_LONG,
        description: 'Description',
        gravity: EdgeAlert.TOP,
        icon: Icons.disc_full);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _showAlert(true);
              },
              child: Text('From Top'),
            ),
            ElevatedButton(
              onPressed: () {
                _showAlert(false);
              },
              child: Text('From Bottom'),
            ),
            ElevatedButton(
              onPressed: () {
                _colorfullAlert();
              },
              child: Text('Colorfull Alert'),
            ),
            ElevatedButton(
              onPressed: () {
                _longDescAlert();
              },
              child: Text('Long Description'),
            ),
            ElevatedButton(
              onPressed: () {
                _differentIcon();
              },
              child: Text('Different Icon'),
            ),
          ],
        ),
      ),
    );
  }
}
