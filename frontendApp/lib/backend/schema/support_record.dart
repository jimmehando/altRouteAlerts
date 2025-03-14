import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SupportRecord extends FirestoreRecord {
  SupportRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  bool hasMessage() => _message != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _email = snapshotData['email'] as String?;
    _message = snapshotData['message'] as String?;
    _uid = snapshotData['uid'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('support');

  static Stream<SupportRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SupportRecord.fromSnapshot(s));

  static Future<SupportRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SupportRecord.fromSnapshot(s));

  static SupportRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SupportRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SupportRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SupportRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SupportRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SupportRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSupportRecordData({
  String? name,
  String? email,
  String? message,
  String? uid,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'email': email,
      'message': message,
      'uid': uid,
    }.withoutNulls,
  );

  return firestoreData;
}

class SupportRecordDocumentEquality implements Equality<SupportRecord> {
  const SupportRecordDocumentEquality();

  @override
  bool equals(SupportRecord? e1, SupportRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.email == e2?.email &&
        e1?.message == e2?.message &&
        e1?.uid == e2?.uid;
  }

  @override
  int hash(SupportRecord? e) =>
      const ListEquality().hash([e?.name, e?.email, e?.message, e?.uid]);

  @override
  bool isValidKey(Object? o) => o is SupportRecord;
}
