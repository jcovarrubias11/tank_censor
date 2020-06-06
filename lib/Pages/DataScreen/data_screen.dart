import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tank_censor/Pages/CensorsScreen/widgets/gauge_graph.dart';
import 'package:tank_censor/Pages/CensorsScreen/widgets/graph.dart';
import 'package:tank_censor/Provider/graph/graph_provider.dart';

class DataScreen extends StatefulWidget {
  final int index;
  DataScreen({Key key, this.index}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  int get _index => widget.index;
  StreamSubscription<Event> _graphNumberSubscription;
  List<TimeSeriesSales> depthData = List<TimeSeriesSales>();
  List<TimeSeriesSales> flowData = List<TimeSeriesSales>();
  List<TimeSeriesSales> wattsData = List<TimeSeriesSales>();
  List<GaugeSegment> depthGaugeList = List<GaugeSegment>();
  List<GaugeSegment> flowGaugeList = List<GaugeSegment>();
  List<GaugeSegment> wattsGaugeList = List<GaugeSegment>();

  List<dynamic> dbData;

  DatabaseError _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Tank Censor Example')),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child('tank_censors')
                  .child('$_index')
                  .onValue,
              builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                if (snapshot.hasData) {
                  Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                  return CarouselSlider(
                      viewportFraction: 0.9,
                      enableInfiniteScroll: false,
                      aspectRatio: 1 / 1.6,
                      enlargeCenterPage: true,
                      items: map.entries.map((entry) {
                        if (entry != null) {
                          String key = entry.key.toString();
                          int value = entry.value;
                          //Graph points to add to graph
                          List<charts.Series<TimeSeriesSales, DateTime>>
                              depthChartData;
                          List<charts.Series<TimeSeriesSales, DateTime>>
                              flowChartData;
                          List<charts.Series<TimeSeriesSales, DateTime>>
                              wattsChartData;

                          //Gauge Chart at the top
                          List<charts.Series<GaugeSegment, String>>
                              depthGaugeData;
                          List<charts.Series<GaugeSegment, String>>
                              flowGaugeData;
                          List<charts.Series<GaugeSegment, String>>
                              wattsGaugeData;
                          switch (key) {
                            case 'depth':
                              depthChartData =
                                  addTimeSeriesToGraph(value, depthData);
                              depthGaugeData = addGaugeSegmentToGauge(
                                  value, 'Depth', depthGaugeList);
                              break;
                            case 'flow':
                              flowChartData =
                                  addTimeSeriesToGraph(value, flowData);
                              flowGaugeData = addGaugeSegmentToGauge(
                                  value, 'Flow', flowGaugeList);
                              break;
                            case 'watts':
                              wattsChartData =
                                  addTimeSeriesToGraph(value, wattsData);
                              wattsGaugeData = addGaugeSegmentToGauge(
                                  value, 'Watts', wattsGaugeList);
                              break;
                          }
                          return Card(
                            elevation: 15.0,
                            semanticContainer: true,
                            child: ListView(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    key == 'depth'
                                        ? buildContainerOfStackOfGaugeChart(
                                            context, value, depthGaugeData)
                                        : key == 'flow'
                                            ? buildContainerOfStackOfGaugeChart(
                                                context, value, flowGaugeData)
                                            : key == 'watts'
                                                ? buildContainerOfStackOfGaugeChart(
                                                    context,
                                                    value,
                                                    wattsGaugeData)
                                                : CircularProgressIndicator(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        key == 'depth'
                                            ? buildTitle('Depth')
                                            : key == 'flow'
                                                ? buildTitle('Flow')
                                                : key == 'watts'
                                                    ? buildTitle('Watts')
                                                    : Container(),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        key == 'depth'
                                            ? buildMeasurement('Ft')
                                            : key == 'flow'
                                                ? buildMeasurement('Gpm')
                                                : key == 'watts'
                                                    ? buildMeasurement('Watts')
                                                    : Container(),
                                      ],
                                    ),
                                    key == 'depth'
                                        ? buildGraph(
                                            context, depthChartData, 400)
                                        : key == 'flow'
                                            ? buildGraph(
                                                context, flowChartData, 400)
                                            : key == 'watts'
                                                ? buildGraph(context,
                                                    wattsChartData, 400)
                                                : CircularProgressIndicator(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          );
                        }
                      }).toList());
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: buildFloatingActionButton());
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {},
      elevation: 15.0,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
      label: Stack(children: <Widget>[
        Positioned(
          top: 15.0,
          left: 50.0,
          right: 50.0,
          child: Center(
            child: Consumer<CensorProvider>(
                builder: (BuildContext context, CensorProvider censor, _) =>
                    Text(censor.switchCensor ? 'ON' : 'OFF')),
          ),
        ),
        Center(
          child: Row(
            children: <Widget>[
              Consumer<CensorProvider>(
                  builder: (BuildContext context, CensorProvider censor, _) =>
                      Switch(
                          value: censor.switchCensor,
                          onChanged: censor.updateSwitch))
            ],
          ),
        ),
      ]),
    );
  }

  Text buildMeasurement(String measurement) => Text('($measurement)');

  Text buildTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.title,
    );
  }

  Card buildCard(BuildContext context, dynamic value) {
    return Card(
      elevation: 5.0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Center(
            child: Text('$value', style: Theme.of(context).textTheme.subtitle)),
      ),
    );
  }

  Card buildGraph(BuildContext context,
      List<charts.Series<TimeSeriesSales, DateTime>> chartData, double height) {
    return Card(
      elevation: 15.0,
      child: Container(
        height: height,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SimpleTimeSeriesChart(
                  chartData,
                  animate: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildContainerOfStackOfGaugeChart(BuildContext context, int value,
      List<charts.Series<GaugeSegment, String>> gaugeData) {
    return Container(
        height: 200,
        width: 200,
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Container(
                  height: 170,
                  width: 170,
                  child: Card(
                    elevation: 15.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.center,
              child: GaugeChart(
                gaugeData,
                animate: false,
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                  height: 110,
                  width: 110,
                  child: Card(
                    elevation: 15.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.center,
              child: buildCenter(value),
            )
          ],
        ));
  }

  Center buildCenter(dynamic censor) {
    return Center(
      child: CircleAvatar(
          radius: 50.0,
          backgroundColor: ThemeData().accentColor,
          child: Center(
              child: Text(
            censor.toString(),
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: Colors.white),
          ))),
    );
  }

  List<charts.Series<TimeSeriesSales, DateTime>> addTimeSeriesToGraph(
      dynamic censor, List<TimeSeriesSales> list) {
    final newPoint = new TimeSeriesSales(DateTime.now(), censor);
    if (list.length == 30) {
      list.removeAt(0);
    }
    list.add(newPoint);
    final chartData = [
      charts.Series<TimeSeriesSales, DateTime>(
          id: 'Levels',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: list)
    ];
    return chartData;
  }

  List<charts.Series<GaugeSegment, String>> addGaugeSegmentToGauge(
      dynamic censor, String segmentName, List<GaugeSegment> list) {
    dynamic percentOfSize = segmentName == 'Depth'
        ? (censor / 50) * 100
        : segmentName == 'Flow'
            ? (censor / 10) * 100
            : segmentName == 'Watts' ? (censor / 250) * 100 : 0;
    final newPoint = new GaugeSegment(
        segmentName, percentOfSize.toInt(), ThemeData().accentColor);
    final emptyPoint = new GaugeSegment(
        'empty', (100 - percentOfSize.toInt()), Color.fromRGBO(0, 0, 0, 0.1));
    list.clear();
    list.add(emptyPoint);
    list.add(newPoint);
    final chartData = [
      charts.Series<GaugeSegment, String>(
          id: 'Levels',
          domainFn: (GaugeSegment segment, _) => segment.segment,
          measureFn: (GaugeSegment segment, _) => segment.size,
          colorFn: (GaugeSegment segment, _) => segment.color,
          data: list)
    ];
    return chartData;
  }
}
