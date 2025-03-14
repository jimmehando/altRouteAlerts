import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  int _eventCont = 0;
  int get eventCont => _eventCont;
  set eventCont(int value) {
    _eventCont = value;
  }

  DocumentReference? _MostRecentEvent =
      FirebaseFirestore.instance.doc('/events/1');
  DocumentReference? get MostRecentEvent => _MostRecentEvent;
  set MostRecentEvent(DocumentReference? value) {
    _MostRecentEvent = value;
  }
}
