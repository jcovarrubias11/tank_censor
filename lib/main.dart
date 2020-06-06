import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tank_censor/Pages/CensorsScreen/censors_screen.dart';
import 'package:tank_censor/Provider/graph/graph_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CensorProvider.instance(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          
            primarySwatch: Colors.blue,
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
              title: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              subtitle: TextStyle(fontSize: 25.0),
              body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
            )),
        home: CensorsScreen(title: 'Tank Censor Tank Demo'),
      ),
    );
  }
}
