import 'package:flutter/material.dart';
import 'IncidentListView.dart';
import 'package:filter_list/filter_list.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITSM',
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> stateList = [
    "Active",
    "Awaiting Evidence",
    "Awaiting Problem",
    "Awaiting User Info",
    "Awaiting Vendor",
    "Closed",
    "New",
    "Resolved"
  ];
  List<String> selectedStateList = [];

  void _openFilterDialog() async {
    await FilterListDialog.display(context,
        allTextList: stateList,
        height: 480,
        borderRadius: 20,
        headlineText: "Select Count",
        searchFieldHintText: "Search Here",
        selectedTextList: selectedStateList, onApplyButtonClick: (list) {
          if (list != null) {
            setState(() {
              selectedStateList = List.from(list);
            });
            Navigator.pop(context);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITSM'),
      ),
      body: Column(
        children: <Widget>[
          selectedStateList == null || selectedStateList.length == 0
              ? Expanded(
            child: Center(
                child: IncidentsListView('New')
            ),
          )
              : Expanded(
            child: Center(
                child: IncidentsListView(selectedStateList[0])
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: _openFilterDialog,
                child: Text(
                  "Filter Status",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({Key key, this.allTextList}) : super(key: key);
  final List<String> allTextList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Status"),
      ),
      body: SafeArea(
        child: FilterListWidget(
          allTextList: allTextList,
          height: MediaQuery.of(context).size.height,
          hideheaderText: true,
          onApplyButtonClick: (list) {
            Navigator.pop(context, list);
          },
        ),
      ),
    );
  }
}
