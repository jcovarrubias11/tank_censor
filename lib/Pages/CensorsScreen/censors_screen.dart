import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tank_censor/Pages/CensorsScreen/widgets/graph.dart';
import 'package:tank_censor/Pages/DataScreen/data_screen.dart';

class CensorsScreen extends StatefulWidget {
  CensorsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CensorsScreenState createState() => _CensorsScreenState();
}

class _CensorsScreenState extends State<CensorsScreen> {
  StreamSubscription<Event> _graphNumberSubscription;
  List<List<dynamic>> depthData = List<List<dynamic>>();
  List<List<dynamic>> flowData = List<List<dynamic>>();
  List<List<dynamic>> wattsData = List<List<dynamic>>();

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
            stream: FirebaseDatabase.instance.reference().onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                List<dynamic> dbData = map.values.toList()[0];
                if (depthData.length != dbData.length) {
                  dbData.forEach((f) {
                    List<TimeSeriesSales> newDepthGraphList =
                        new List<TimeSeriesSales>();
                    List<TimeSeriesSales> newFlowGraphList =
                        new List<TimeSeriesSales>();
                    List<TimeSeriesSales> newWattsGraphList =
                        new List<TimeSeriesSales>();
                    depthData.add(newDepthGraphList);
                    flowData.add(newFlowGraphList);
                    wattsData.add(newWattsGraphList);
                  });
                }
                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: CarouselSlider(
                          viewportFraction: 0.9,
                          enableInfiniteScroll: false,
                          aspectRatio: 1 / 1.6,
                          // height: MediaQuery.of(context).size.height,
                          enlargeCenterPage: true,
                          items: dbData.asMap().entries.map((entry) {
                            dynamic index = entry.key;
                            dynamic value = entry.value;
                            if (value != null) {
                              List<charts.Series<TimeSeriesSales, DateTime>>
                                  depthChartData = addTimeSeriesToGraph(
                                      value['depth'], index, depthData);
                              // List<charts.Series<TimeSeriesSales, DateTime>>
                              //     flowChartData = addTimeSeriesToGraph(
                              //         value['flow'], index, flowData);
                              // List<charts.Series<TimeSeriesSales, DateTime>>
                              //     wattsChartData = addTimeSeriesToGraph(
                              //         value['watts'], index, wattsData);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DataScreen(
                                              index: index,
                                            )),
                                  );
                                },
                                child: Card(
                                  elevation: 15.0,
                                  semanticContainer: true,
                                  child: ListView(children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Center(
                                              child: IconButton(
                                            icon: Icon(Icons.info),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  child: AlertDialog(
                                                    title: Container(
                                                      height: 300,
                                                      width: 300,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                              'Censor ID: $index')
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      MaterialButton(
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )
                                                    ],
                                                  ));
                                            },
                                          )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              buildCenter(value['depth']),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              buildTitle('Depth'),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              buildMeasurement('Ft')
                                            ],
                                          ),
                                          //Depth Graph
                                          buildGraph(
                                              context, depthChartData, 200),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    child: Column(
                                                  children: <Widget>[
                                                    buildTitle('Flow'),
                                                    buildMeasurement('Gpm'),
                                                    buildCard(
                                                        context, value['flow']),
                                                    // buildGraph(context,
                                                    //     flowChartData, 100),
                                                  ],
                                                )),
                                                Expanded(
                                                    child: Column(
                                                  children: <Widget>[
                                                    buildTitle('Power'),
                                                    buildMeasurement('Watts'),
                                                    buildCard(context,
                                                        value['watts']),
                                                    // buildGraph(context,
                                                    //     wattsChartData, 100),
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              );
                            }
                          }).toList()),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
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
      elevation: 15.0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.35,
        padding: EdgeInsets.all(10.0),
        child: Card(
          elevation: 15.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Center(
              child:
                  Text('$value', style: Theme.of(context).textTheme.subtitle)),
        ),
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

  Center buildCenter(dynamic censor) {
    return Center(
      child: CircleAvatar(
          radius: 35.0,
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
      dynamic censor, int index, List<List<dynamic>> list) {
    final newPoint = new TimeSeriesSales(DateTime.now(), censor);
    if (list[index].length == 20) {
      list[index].removeAt(0);
    }
    list[index].add(newPoint);
    final chartData = [
      charts.Series<TimeSeriesSales, DateTime>(
          id: 'Levels',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: list[index])
    ];
    return chartData;
  }
}
