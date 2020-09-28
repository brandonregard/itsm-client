import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Incident {
  final String number;
  final String state;
  final String urgency;

  Incident({this.number, this.state, this.urgency});

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      number: json['number'],
      state: json['incident_state'],
      urgency: json['urgency'],
    );
  }
}

class IncidentsListView extends StatefulWidget {
  IncidentsListView(this.selectedState);

  final String selectedState;

  @override
  _IncidentsListViewState createState() => _IncidentsListViewState();
}

class _IncidentsListViewState extends State<IncidentsListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Incident>>(
      future: _fetchIncidents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Incident> data = snapshot.data;
          return _incidentsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Incident>> _fetchIncidents() async {
    final incidentsUrl = 'https://itsm-server-dev.brandonregard.info/incidents?incident_state=' + widget.selectedState;
    final response = await http.get(incidentsUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Incident> list = jsonResponse.map((incident) => new Incident.fromJson(incident)).toList();
      Map<String, Incident> map = {};

      for (var item in list) {
        map[item.number] = item;
      }
      list = map.values.toList();
      list.sort((a, b) => a.urgency.compareTo(b.urgency));
      return list;
    } else {
      throw Exception('Failed to load incidents from API');
    }
  }

  ListView _incidentsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          Color color;

          switch (data[index].urgency) {
            case '1 - High':
              color = Colors.red[500];
              break;
            case '2 - Medium':
              color = Colors.orange[500];
              break;
            case '3 - Low':
              color = Colors.green[500];
              break;
            default:
              color = Colors.blue[500];
          }
          return _tile(data[index].number, data[index].state, color);
        });
  }

  ListTile _tile(String title, String subtitle, Color color) => ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: Icon(
      Icons.report_problem,
      color: color,
    ),
  );
}
