import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EventsRecord extends FirestoreRecord {
  EventsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "emails" field.
  List<String>? _emails;
  List<String> get emails => _emails ?? const [];
  bool hasEmails() => _emails != null;

  // "time_cleared" field.
  String? _timeCleared;
  String get timeCleared => _timeCleared ?? '';
  bool hasTimeCleared() => _timeCleared != null;

  // "reported_by" field.
  String? _reportedBy;
  String get reportedBy => _reportedBy ?? '';
  bool hasReportedBy() => _reportedBy != null;

  // "time_live" field.
  String? _timeLive;
  String get timeLive => _timeLive ?? '';
  bool hasTimeLive() => _timeLive != null;

  // "coordinates" field.
  LatLng? _coordinates;
  LatLng? get coordinates => _coordinates;
  bool hasCoordinates() => _coordinates != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "event_type" field.
  String? _eventType;
  String get eventType => _eventType ?? '';
  bool hasEventType() => _eventType != null;

  // "locality" field.
  String? _locality;
  String get locality => _locality ?? '';
  bool hasLocality() => _locality != null;

  // "location" field.
  String? _location;
  String get location => _location ?? '';
  bool hasLocation() => _location != null;

  // "source" field.
  String? _source;
  String get source => _source ?? '';
  bool hasSource() => _source != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "time" field.
  String? _time;
  String get time => _time ?? '';
  bool hasTime() => _time != null;

  // "unix" field.
  int? _unix;
  int get unix => _unix ?? 0;
  bool hasUnix() => _unix != null;

  // "num_thumbs_up" field.
  int? _numThumbsUp;
  int get numThumbsUp => _numThumbsUp ?? 0;
  bool hasNumThumbsUp() => _numThumbsUp != null;

  void _initializeFields() {
    _emails = getDataList(snapshotData['emails']);
    _timeCleared = snapshotData['time_cleared'] as String?;
    _reportedBy = snapshotData['reported_by'] as String?;
    _timeLive = snapshotData['time_live'] as String?;
    _coordinates = snapshotData['coordinates'] as LatLng?;
    _description = snapshotData['description'] as String?;
    _eventType = snapshotData['event_type'] as String?;
    _locality = snapshotData['locality'] as String?;
    _location = snapshotData['location'] as String?;
    _source = snapshotData['source'] as String?;
    _status = snapshotData['status'] as String?;
    _time = snapshotData['time'] as String?;
    _unix = castToType<int>(snapshotData['unix']);
    _numThumbsUp = castToType<int>(snapshotData['num_thumbs_up']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('events');

  static Stream<EventsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EventsRecord.fromSnapshot(s));

  static Future<EventsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EventsRecord.fromSnapshot(s));

  static EventsRecord fromSnapshot(DocumentSnapshot snapshot) => EventsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EventsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EventsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EventsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EventsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEventsRecordData({
  String? timeCleared,
  String? reportedBy,
  String? timeLive,
  LatLng? coordinates,
  String? description,
  String? eventType,
  String? locality,
  String? location,
  String? source,
  String? status,
  String? time,
  int? unix,
  int? numThumbsUp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'time_cleared': timeCleared,
      'reported_by': reportedBy,
      'time_live': timeLive,
      'coordinates': coordinates,
      'description': description,
      'event_type': eventType,
      'locality': locality,
      'location': location,
      'source': source,
      'status': status,
      'time': time,
      'unix': unix,
      'num_thumbs_up': numThumbsUp,
    }.withoutNulls,
  );

  return firestoreData;
}

class EventsRecordDocumentEquality implements Equality<EventsRecord> {
  const EventsRecordDocumentEquality();

  @override
  bool equals(EventsRecord? e1, EventsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.emails, e2?.emails) &&
        e1?.timeCleared == e2?.timeCleared &&
        e1?.reportedBy == e2?.reportedBy &&
        e1?.timeLive == e2?.timeLive &&
        e1?.coordinates == e2?.coordinates &&
        e1?.description == e2?.description &&
        e1?.eventType == e2?.eventType &&
        e1?.locality == e2?.locality &&
        e1?.location == e2?.location &&
        e1?.source == e2?.source &&
        e1?.status == e2?.status &&
        e1?.time == e2?.time &&
        e1?.unix == e2?.unix &&
        e1?.numThumbsUp == e2?.numThumbsUp;
  }

  @override
  int hash(EventsRecord? e) => const ListEquality().hash([
        e?.emails,
        e?.timeCleared,
        e?.reportedBy,
        e?.timeLive,
        e?.coordinates,
        e?.description,
        e?.eventType,
        e?.locality,
        e?.location,
        e?.source,
        e?.status,
        e?.time,
        e?.unix,
        e?.numThumbsUp
      ]);

  @override
  bool isValidKey(Object? o) => o is EventsRecord;
}
