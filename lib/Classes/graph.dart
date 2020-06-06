import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

class Graph extends Equatable {
  final String key;
  final int value;

  @override
  List<Object> get props => [key, value];

  Graph.fromSnapshot(
    DataSnapshot snapshot,
  )   : key = snapshot.key,
        value = snapshot.value['value'] ?? 99;
}
