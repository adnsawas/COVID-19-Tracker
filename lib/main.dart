import 'package:covid_19_tracker/app/notifiers/data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CoronaDataNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: MyHomePage(title: 'COVID-19 Statistics'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await Provider.of<CoronaDataNotifier>(context, listen: false).login();
    Provider.of<CoronaDataNotifier>(context, listen: false).fetchAllData();
  }

  RefreshController _refreshController = RefreshController();

  _refresh(CoronaDataNotifier notifier) {
    notifier.fetchAllData().then((value) {
      _refreshController.refreshCompleted();
    });
  }

  Widget _buildCoronaInfo(
      {String label, int value, Color color, IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Color(0xFF222222),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(fontSize: 24, color: color),
              ),
              Text(
                "$value",
                style: TextStyle(fontSize: 24, color: color),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<CoronaDataNotifier>(
        builder: (context, notifier, _) => SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: () {
            _refresh(notifier);
          },
          child: ListView(
            children: <Widget>[
              _buildCoronaInfo(
                  label: "Cases",
                  value: notifier.getCases,
                  color: Colors.lime,
                  icon: Icons.healing),
              // _buildCoronaInfo(
              //     label: "Suspected Cases",
              //     value: notifier.getCases,
              //     color: Colors.lime[400],
              //     icon: Icons.question_answer),
              // _buildCoronaInfo(
              //     label: "Confirmed Cases",
              //     value: notifier.getSuspectedCases,
              //     color: Colors.orange,
              //     icon: Icons.healing),
              _buildCoronaInfo(
                  label: "Deaths",
                  value: notifier.getDeaths,
                  color: Colors.red,
                  icon: Icons.sentiment_very_dissatisfied),
              _buildCoronaInfo(
                  label: "Recovered",
                  value: notifier.getRecovered,
                  color: Colors.greenAccent[200],
                  icon: Icons.local_hospital),
            ],
          ),
        ),
      ),
    );
  }
}
