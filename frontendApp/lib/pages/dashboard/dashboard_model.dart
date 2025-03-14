import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  List<EventsRecord> myEvents = [];
  void addToMyEvents(EventsRecord item) => myEvents.add(item);
  void removeFromMyEvents(EventsRecord item) => myEvents.remove(item);
  void removeAtIndexFromMyEvents(int index) => myEvents.removeAt(index);
  void insertAtIndexInMyEvents(int index, EventsRecord item) =>
      myEvents.insert(index, item);
  void updateMyEventsAtIndex(int index, Function(EventsRecord) updateFn) =>
      myEvents[index] = updateFn(myEvents[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in Dashboard widget.
  List<EventsRecord>? userEvents;
  List<EventsRecord>? listViewPreviousSnapshot;
  // Stores action output result for [Firestore Query - Query a collection] action in ListView widget.
  List<EventsRecord>? latestEvents;
  AudioPlayer? soundPlayer;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
