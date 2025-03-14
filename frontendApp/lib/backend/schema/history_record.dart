import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HistoryRecord extends FirestoreRecord {
  HistoryRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "coordinates" field.
  LatLng? _coordinates;
  LatLng? get coordinates => _coordinates;
  bool hasCoordinates() => _coordinates != null;

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

  // "num_thumbs_up" field.
  int? _numThumbsUp;
  int get numThumbsUp => _numThumbsUp ?? 0;
  bool hasNumThumbsUp() => _numThumbsUp != null;

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

  void _initializeFields() {
    _coordinates = snapshotData['coordinates'] as LatLng?;
    _emails = getDataList(snapshotData['emails']);
    _timeCleared = snapshotData['time_cleared'] as String?;
    _reportedBy = snapshotData['reported_by'] as String?;
    _numThumbsUp = castToType<int>(snapshotData['num_thumbs_up']);
    _description = snapshotData['description'] as String?;
    _eventType = snapshotData['event_type'] as String?;
    _locality = snapshotData['locality'] as String?;
    _location = snapshotData['location'] as String?;
    _source = snapshotData['source'] as String?;
    _status = snapshotData['status'] as String?;
    _time = snapshotData['time'] as String?;
    _unix = castToType<int>(snapshotData['unix']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('history');

  static Stream<HistoryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HistoryRecord.fromSnapshot(s));

  static Future<HistoryRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HistoryRecord.fromSnapshot(s));

  static HistoryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      HistoryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HistoryRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HistoryRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HistoryRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HistoryRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHistoryRecordData({
  LatLng? coordinates,
  String? timeCleared,
  String? reportedBy,
  int? numThumbsUp,
  String? description,
  String? eventType,
  String? locality,
  String? location,
  String? source,
  String? status,
  String? time,
  int? unix,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'coordinates': coordinates,
      'time_cleared': timeCleared,
      'reported_by': reportedBy,
      'num_thumbs_up': numThumbsUp,
      'description': description,
      'event_type': eventType,
      'locality': locality,
      'location': location,
      'source': source,
      'status': status,
      'time': time,
      'unix': unix,
    }.withoutNulls,
  );

  return firestoreData;
}

class HistoryRecordDocumentEquality implements Equality<HistoryRecord> {
  const HistoryRecordDocumentEquality();

  @override
  bool equals(HistoryRecord? e1, HistoryRecord? e2) {
    const listEquality = ListEquality();
    return e1?.coordinates == e2?.coordinates &&
        listEquality.equals(e1?.emails, e2?.emails) &&
        e1?.timeCleared == e2?.timeCleared &&
        e1?.reportedBy == e2?.reportedBy &&
        e1?.numThumbsUp == e2?.numThumbsUp &&
        e1?.description == e2?.description &&
        e1?.eventType == e2?.eventType &&
        e1?.locality == e2?.locality &&
        e1?.location == e2?.location &&
        e1?.source == e2?.source &&
        e1?.status == e2?.status &&
        e1?.time == e2?.time &&
        e1?.unix == e2?.unix;
  }

  @override
  int hash(HistoryRecord? e) => const ListEquality().hash([
        e?.coordinates,
        e?.emails,
        e?.timeCleared,
        e?.reportedBy,
        e?.numThumbsUp,
        e?.description,
        e?.eventType,
        e?.locality,
        e?.location,
        e?.source,
        e?.status,
        e?.time,
        e?.unix
      ]);

  @override
  bool isValidKey(Object? o) => o is HistoryRecord;
}
