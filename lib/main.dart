import 'package:flutter/material.dart';
import 'IncidentListView.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITSM - New Incidents',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ITSM - New Incidents'),
        ),
        body: Center(
            child: IncidentsListView()
        ),
      ),
    );
  }
}