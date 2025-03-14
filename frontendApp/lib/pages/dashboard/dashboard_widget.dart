import '';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:map_launcher/map_launcher.dart' as $ml;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  static String routeName = 'Dashboard';
  static String routePath = '/dashboard';

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late DashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (RootPageContext.isInactiveRootPage(context)) {
        return;
      }
      _model.userEvents = await queryEventsRecordOnce(
        queryBuilder: (eventsRecord) => eventsRecord.where(
          'emails',
          arrayContains: currentUserEmail,
        ),
      );
      _model.myEvents = _model.userEvents!.toList().cast<EventsRecord>();
      safeSetState(() {});
      FFAppState().eventCont = _model.userEvents!.length;
    });

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.06,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).tertiary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 20.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context.pushNamed(
                              AccountWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 250),
                                ),
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 20.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.map,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context.pushNamed(
                              MapPageWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 250),
                                ),
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.924,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 60.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: StreamBuilder<List<EventsRecord>>(
                          stream: queryEventsRecord(
                            queryBuilder: (eventsRecord) => eventsRecord
                                .where(
                                  'emails',
                                  arrayContains: currentUserEmail,
                                )
                                .orderBy('unix', descending: true),
                          )..listen((snapshot) {
                              List<EventsRecord> listViewEventsRecordList =
                                  snapshot;
                              if (_model.listViewPreviousSnapshot != null &&
                                  !const ListEquality(
                                          EventsRecordDocumentEquality())
                                      .equals(listViewEventsRecordList,
                                          _model.listViewPreviousSnapshot)) {
                                () async {
                                  _model.latestEvents =
                                      await queryEventsRecordOnce(
                                    queryBuilder: (eventsRecord) =>
                                        eventsRecord.where(
                                      'emails',
                                      arrayContains: currentUserEmail,
                                    ),
                                  );
                                  if (_model.latestEvents!.length >
                                      FFAppState().eventCont) {
                                    _model.soundPlayer ??= AudioPlayer();
                                    if (_model.soundPlayer!.playing) {
                                      await _model.soundPlayer!.stop();
                                    }
                                    _model.soundPlayer!.setVolume(1.0);
                                    _model.soundPlayer!
                                        .setAsset('assets/audios/Success.wav')
                                        .then(
                                            (_) => _model.soundPlayer!.play());

                                    FFAppState().eventCont =
                                        _model.latestEvents!.length;
                                  } else {
                                    FFAppState().eventCont =
                                        _model.latestEvents!.length;
                                  }

                                  safeSetState(() {});
                                }();
                              }
                              _model.listViewPreviousSnapshot = snapshot;
                            }),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<EventsRecord> listViewEventsRecordList =
                                snapshot.data!;

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: listViewEventsRecordList.length,
                              itemBuilder: (context, listViewIndex) {
                                final listViewEventsRecord =
                                    listViewEventsRecordList[listViewIndex];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 10.0, 5.0, 5.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (Navigator.of(context).canPop()) {
                                        context.pop();
                                      }
                                      context.pushNamed(
                                        AlertPageWidget.routeName,
                                        queryParameters: {
                                          'alertPullTrough': serializeParam(
                                            listViewEventsRecord,
                                            ParamType.Document,
                                          ),
                                        }.withoutNulls,
                                        extra: <String, dynamic>{
                                          'alertPullTrough':
                                              listViewEventsRecord,
                                          kTransitionInfoKey: TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.fade,
                                            duration:
                                                Duration(milliseconds: 100),
                                          ),
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF4F3F3),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4.0,
                                            color: Color(0x33000000),
                                            offset: Offset(
                                              10.0,
                                              10.0,
                                            ),
                                          )
                                        ],
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        border: Border.all(
                                          color: Color(0xFFE1DEDE),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 0.0, 15.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Text(
                                                              listViewEventsRecord
                                                                  .eventType,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ),
                                                          ),
                                                          if (listViewEventsRecord
                                                                      .timeLive ==
                                                                  '')
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          5.0,
                                                                          0.0,
                                                                          5.0),
                                                              child: Text(
                                                                listViewEventsRecord
                                                                    .time,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    5.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              listViewEventsRecord
                                                                  .locality,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    5.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              listViewEventsRecord
                                                                  .location
                                                                  .maybeHandleOverflow(
                                                                maxChars: 25,
                                                                replacement:
                                                                    '…',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (listViewEventsRecord
                                                              .source ==
                                                          'Waze')
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            if (listViewEventsRecord
                                                                    .source ==
                                                                'Waze')
                                                              Text(
                                                                'Likes: ${listViewEventsRecord.numThumbsUp.toString()}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                              ),
                                                            Text(
                                                              'User: ${listViewEventsRecord.reportedBy != '' ? listViewEventsRecord.reportedBy : 'Anonymous'}'
                                                                  .maybeHandleOverflow(
                                                                maxChars: 25,
                                                                replacement:
                                                                    '…',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    5.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              listViewEventsRecord
                                                                  .status,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: () {
                                                                      if (listViewEventsRecord
                                                                              .status ==
                                                                          'Live') {
                                                                        return Color(
                                                                            0xFFFF0000);
                                                                      } else if (listViewEventsRecord
                                                                              .status ==
                                                                          'Cleared') {
                                                                        return Color(
                                                                            0xFF000AFF);
                                                                      } else {
                                                                        return Color(
                                                                            0xFF511685);
                                                                      }
                                                                    }(),
                                                                    fontSize:
                                                                        15.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ),
                                                            Text(
                                                              formatNumber(
                                                                functions.returnDistanceBetweenTwoPoints(
                                                                    currentUserLocationValue,
                                                                    listViewEventsRecord
                                                                        .coordinates),
                                                                formatType:
                                                                    FormatType
                                                                        .custom,
                                                                format:
                                                                    '0.0Kms',
                                                                locale: '',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                            Text(
                                                              listViewEventsRecord
                                                                  .source,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: () {
                                                                      if (listViewEventsRecord
                                                                              .source ==
                                                                          'Waze') {
                                                                        return Color(
                                                                            0xFF046BD2);
                                                                      } else if (listViewEventsRecord
                                                                              .source ==
                                                                          'QFES') {
                                                                        return Color(
                                                                            0xFFFF0000);
                                                                      } else if (listViewEventsRecord
                                                                              .source ==
                                                                          'AusRoads') {
                                                                        return Color(
                                                                            0xFFB6C300);
                                                                      } else {
                                                                        return Colors
                                                                            .black;
                                                                      }
                                                                    }(),
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    5.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            FFButtonWidget(
                                                              onPressed:
                                                                  () async {
                                                                if (valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.navOption,
                                                                        '') ==
                                                                    'Waze') {
                                                                  if (Navigator.of(
                                                                          context)
                                                                      .canPop()) {
                                                                    context
                                                                        .pop();
                                                                  }
                                                                  context
                                                                      .pushNamed(
                                                                    AlertPageWidget
                                                                        .routeName,
                                                                    queryParameters:
                                                                        {
                                                                      'alertPullTrough':
                                                                          serializeParam(
                                                                        listViewEventsRecord,
                                                                        ParamType
                                                                            .Document,
                                                                      ),
                                                                    }.withoutNulls,
                                                                    extra: <String,
                                                                        dynamic>{
                                                                      'alertPullTrough':
                                                                          listViewEventsRecord,
                                                                      kTransitionInfoKey:
                                                                          TransitionInfo(
                                                                        hasTransition:
                                                                            true,
                                                                        transitionType:
                                                                            PageTransitionType.fade,
                                                                        duration:
                                                                            Duration(milliseconds: 100),
                                                                      ),
                                                                    },
                                                                  );

                                                                  await launchMap(
                                                                    mapType: $ml
                                                                        .MapType
                                                                        .waze,
                                                                    location:
                                                                        listViewEventsRecord
                                                                            .coordinates,
                                                                    title: '',
                                                                  );

                                                                  return;
                                                                } else {
                                                                  if (valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.navOption,
                                                                          '') ==
                                                                      'Apple') {
                                                                    if (Navigator.of(
                                                                            context)
                                                                        .canPop()) {
                                                                      context
                                                                          .pop();
                                                                    }
                                                                    context
                                                                        .pushNamed(
                                                                      AlertPageWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'alertPullTrough':
                                                                            serializeParam(
                                                                          listViewEventsRecord,
                                                                          ParamType
                                                                              .Document,
                                                                        ),
                                                                      }.withoutNulls,
                                                                      extra: <String,
                                                                          dynamic>{
                                                                        'alertPullTrough':
                                                                            listViewEventsRecord,
                                                                        kTransitionInfoKey:
                                                                            TransitionInfo(
                                                                          hasTransition:
                                                                              true,
                                                                          transitionType:
                                                                              PageTransitionType.fade,
                                                                          duration:
                                                                              Duration(milliseconds: 100),
                                                                        ),
                                                                      },
                                                                    );

                                                                    await launchMap(
                                                                      mapType: $ml
                                                                          .MapType
                                                                          .apple,
                                                                      location:
                                                                          listViewEventsRecord
                                                                              .coordinates,
                                                                      title: '',
                                                                    );

                                                                    return;
                                                                  } else {
                                                                    if (valueOrDefault(
                                                                            currentUserDocument?.navOption,
                                                                            '') ==
                                                                        'Google') {
                                                                      if (Navigator.of(
                                                                              context)
                                                                          .canPop()) {
                                                                        context
                                                                            .pop();
                                                                      }
                                                                      context
                                                                          .pushNamed(
                                                                        AlertPageWidget
                                                                            .routeName,
                                                                        queryParameters:
                                                                            {
                                                                          'alertPullTrough':
                                                                              serializeParam(
                                                                            listViewEventsRecord,
                                                                            ParamType.Document,
                                                                          ),
                                                                        }.withoutNulls,
                                                                        extra: <String,
                                                                            dynamic>{
                                                                          'alertPullTrough':
                                                                              listViewEventsRecord,
                                                                          kTransitionInfoKey:
                                                                              TransitionInfo(
                                                                            hasTransition:
                                                                                true,
                                                                            transitionType:
                                                                                PageTransitionType.fade,
                                                                            duration:
                                                                                Duration(milliseconds: 100),
                                                                          ),
                                                                        },
                                                                      );

                                                                      await launchMap(
                                                                        mapType: $ml
                                                                            .MapType
                                                                            .google,
                                                                        location:
                                                                            listViewEventsRecord.coordinates,
                                                                        title:
                                                                            '',
                                                                      );

                                                                      return;
                                                                    } else {
                                                                      if (Navigator.of(
                                                                              context)
                                                                          .canPop()) {
                                                                        context
                                                                            .pop();
                                                                      }
                                                                      context
                                                                          .pushNamed(
                                                                        AlertPageWidget
                                                                            .routeName,
                                                                        queryParameters:
                                                                            {
                                                                          'alertPullTrough':
                                                                              serializeParam(
                                                                            listViewEventsRecord,
                                                                            ParamType.Document,
                                                                          ),
                                                                        }.withoutNulls,
                                                                        extra: <String,
                                                                            dynamic>{
                                                                          'alertPullTrough':
                                                                              listViewEventsRecord,
                                                                          kTransitionInfoKey:
                                                                              TransitionInfo(
                                                                            hasTransition:
                                                                                true,
                                                                            transitionType:
                                                                                PageTransitionType.fade,
                                                                            duration:
                                                                                Duration(milliseconds: 100),
                                                                          ),
                                                                        },
                                                                      );

                                                                      await launchMap(
                                                                        location:
                                                                            listViewEventsRecord.coordinates,
                                                                        title:
                                                                            '',
                                                                      );

                                                                      return;
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                              text: 'Navigate',
                                                              options:
                                                                  FFButtonOptions(
                                                                width: 150.0,
                                                                height: 40.0,
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        24.0,
                                                                        0.0,
                                                                        24.0,
                                                                        0.0),
                                                                iconPadding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                textStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: Colors
                                                                          .white,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                                elevation: 3.0,
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                            ),
                                                            if ((listViewEventsRecord
                                                                        .source ==
                                                                    'Waze') &&
                                                                (valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.navOption,
                                                                        '') !=
                                                                    'Waze'))
                                                              AuthUserStreamWidget(
                                                                builder:
                                                                    (context) =>
                                                                        FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await launchMap(
                                                                      mapType: $ml
                                                                          .MapType
                                                                          .waze,
                                                                      location:
                                                                          listViewEventsRecord
                                                                              .coordinates,
                                                                      title: '',
                                                                    );
                                                                  },
                                                                  text:
                                                                      'View on Waze',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        150.0,
                                                                    height:
                                                                        40.0,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            24.0,
                                                                            0.0,
                                                                            24.0,
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Readex Pro',
                                                                          color:
                                                                              Colors.white,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
