import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "live_only" field.
  bool? _liveOnly;
  bool get liveOnly => _liveOnly ?? false;
  bool hasLiveOnly() => _liveOnly != null;

  // "company" field.
  String? _company;
  String get company => _company ?? '';
  bool hasCompany() => _company != null;

  // "NavOption" field.
  String? _navOption;
  String get navOption => _navOption ?? '';
  bool hasNavOption() => _navOption != null;

  // "areas" field.
  String? _areas;
  String get areas => _areas ?? '';
  bool hasAreas() => _areas != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "isLoggedIn" field.
  bool? _isLoggedIn;
  bool get isLoggedIn => _isLoggedIn ?? false;
  bool hasIsLoggedIn() => _isLoggedIn != null;

  // "subscription_status" field.
  String? _subscriptionStatus;
  String get subscriptionStatus => _subscriptionStatus ?? '';
  bool hasSubscriptionStatus() => _subscriptionStatus != null;

  // "tos_pp_agree" field.
  bool? _tosPpAgree;
  bool get tosPpAgree => _tosPpAgree ?? false;
  bool hasTosPpAgree() => _tosPpAgree != null;

  // "tos_pp_timestamp" field.
  DateTime? _tosPpTimestamp;
  DateTime? get tosPpTimestamp => _tosPpTimestamp;
  bool hasTosPpTimestamp() => _tosPpTimestamp != null;

  // "sessionId" field.
  String? _sessionId;
  String get sessionId => _sessionId ?? '';
  bool hasSessionId() => _sessionId != null;

  // "alerts" field.
  bool? _alerts;
  bool get alerts => _alerts ?? false;
  bool hasAlerts() => _alerts != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _liveOnly = snapshotData['live_only'] as bool?;
    _company = snapshotData['company'] as String?;
    _navOption = snapshotData['NavOption'] as String?;
    _areas = snapshotData['areas'] as String?;
    _location = snapshotData['location'] as LatLng?;
    _isLoggedIn = snapshotData['isLoggedIn'] as bool?;
    _subscriptionStatus = snapshotData['subscription_status'] as String?;
    _tosPpAgree = snapshotData['tos_pp_agree'] as bool?;
    _tosPpTimestamp = snapshotData['tos_pp_timestamp'] as DateTime?;
    _sessionId = snapshotData['sessionId'] as String?;
    _alerts = snapshotData['alerts'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  bool? liveOnly,
  String? company,
  String? navOption,
  String? areas,
  LatLng? location,
  bool? isLoggedIn,
  String? subscriptionStatus,
  bool? tosPpAgree,
  DateTime? tosPpTimestamp,
  String? sessionId,
  bool? alerts,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'live_only': liveOnly,
      'company': company,
      'NavOption': navOption,
      'areas': areas,
      'location': location,
      'isLoggedIn': isLoggedIn,
      'subscription_status': subscriptionStatus,
      'tos_pp_agree': tosPpAgree,
      'tos_pp_timestamp': tosPpTimestamp,
      'sessionId': sessionId,
      'alerts': alerts,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.liveOnly == e2?.liveOnly &&
        e1?.company == e2?.company &&
        e1?.navOption == e2?.navOption &&
        e1?.areas == e2?.areas &&
        e1?.location == e2?.location &&
        e1?.isLoggedIn == e2?.isLoggedIn &&
        e1?.subscriptionStatus == e2?.subscriptionStatus &&
        e1?.tosPpAgree == e2?.tosPpAgree &&
        e1?.tosPpTimestamp == e2?.tosPpTimestamp &&
        e1?.sessionId == e2?.sessionId &&
        e1?.alerts == e2?.alerts;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.liveOnly,
        e?.company,
        e?.navOption,
        e?.areas,
        e?.location,
        e?.isLoggedIn,
        e?.subscriptionStatus,
        e?.tosPpAgree,
        e?.tosPpTimestamp,
        e?.sessionId,
        e?.alerts
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
