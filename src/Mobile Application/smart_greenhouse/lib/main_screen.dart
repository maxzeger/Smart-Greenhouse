import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speedometer/flutter_speedometer.dart';
import 'package:smart_greenhouse/blocs/actions-bloc.dart';
import 'package:smart_greenhouse/blocs/actions-event.dart';
import 'package:smart_greenhouse/blocs/actions-state.dart';
import 'package:smart_greenhouse/blocs/measurements-bloc.dart';
import 'package:smart_greenhouse/blocs/measurements-event.dart';
import 'package:smart_greenhouse/blocs/measurements-state.dart';
import 'package:smart_greenhouse/blocs/tsh-bloc.dart';
import 'package:smart_greenhouse/blocs/tsh-event.dart';
import 'package:smart_greenhouse/blocs/tsh-state.dart';
import 'package:smart_greenhouse/models/actions_model.dart' as ac;
import 'package:smart_greenhouse/models/measurements_model.dart';
import 'package:smart_greenhouse/models/settings_model.dart';
import 'package:smart_greenhouse/settings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

final TextEditingController durationController = TextEditingController();
final TextEditingController timeController = TextEditingController();

class _MainScreenState extends State<MainScreen> {
  Screens currentScreen = Screens.info;
  final TshBloc _tshBloc = TshBloc();
  final ActionsBloc _actionsBloc = ActionsBloc();
  final MeasurementsBloc _measurementsBloc = MeasurementsBloc();
  late String base64Image = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tshBloc.add(GetTshObject());
    _actionsBloc.add(GetActionsList());
    _measurementsBloc.add(GetMeasurementsList());
    pictureRequest();
    super.initState();
  }

  List<DataRow> getDataRowsForActions(List<ac.Actions> actions) {
    List<DataRow> dataRow = <DataRow>[];
    actions.forEach((element) {
      List<DataCell> dataCells = <DataCell>[];
      dataCells.add(DataCell(Text(element.duration)));
      dataCells.add(DataCell(Text(element.timeStamp)));
      dataRow.add(DataRow(cells: dataCells));
    });
    return dataRow;
  }

  List<DataRow> getDataRowsForMeasurements(List<Measurments> mm) {
    List<DataRow> dataRow = <DataRow>[];
    mm.forEach((element) {
      List<DataCell> dataCells = <DataCell>[];
      dataCells.add(DataCell(Text(element.temperature.toString())));
      dataCells.add(DataCell(Text(element.soilMoisture.toString())));
      dataCells.add(DataCell(Text(element.humidity.toString())));
      dataCells.add(DataCell(Text(element.timeStamp)));
      dataRow.add(DataRow(cells: dataCells));
    });
    return dataRow;
  }

  void watering() async {
    try {
      var dio = Dio();
      await dio.post("${Settings.address}/getActions");
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void setSettings(double durationOfPumping, double controllingTime) async {
    try {
      var dio = Dio();
      await dio.post("${Settings.address}/setEnv",
          data: json.encode(SettingsModel(int.parse(durationController.text),
              int.parse(timeController.text))));
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void pictureRequest() async {
    try {
      var dio = Dio();
      var response = await dio.get("${Settings.address}/getImage");
      base64Image = response.data.toString();
      base64Image.replaceAll('"', '');
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Greenhouse'),
      ),
      body: Center(
          child: currentScreen == Screens.info
              ? Center(
                  child: BlocProvider(
                      create: (_) => _tshBloc,
                      child: BlocListener<TshBloc, TshState>(
                        listener: (context, state) {},
                        child: BlocBuilder<TshBloc, TshState>(
                          builder: (context, state) {
                            if (state is TshLoaded) {
                              return ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Center(
                                          child: Card(
                                              elevation: 20,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: SizedBox(
                                                width: 185,
                                                height: 185,
                                                child: Center(
                                                    child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 7, 0, 0),
                                                        child: const Text(
                                                          "Temperature",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .deepOrange),
                                                        )),
                                                    Speedometer(
                                                      size: 150,
                                                      meterColor:
                                                          Colors.deepOrange,
                                                      kimColor: Colors.black,
                                                      backgroundColor:
                                                          Colors.white,
                                                      minValue: 0,
                                                      maxValue: 180,
                                                      currentValue: state
                                                          .tshModel.temperature,
                                                      warningValue: 800,
                                                      displayText: '°',
                                                    ),
                                                  ],
                                                )),
                                              )),
                                        )),
                                        Expanded(
                                            child: Center(
                                          child: Card(
                                              elevation: 20,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: SizedBox(
                                                width: 185,
                                                height: 185,
                                                child: Center(
                                                    child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 7, 0, 0),
                                                        child: const Text(
                                                          "Soil Moisture",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.brown),
                                                        )),
                                                    Speedometer(
                                                      size: 150,
                                                      meterColor: Colors.brown,
                                                      kimColor: Colors.black,
                                                      backgroundColor:
                                                          Colors.white,
                                                      minValue: 0,
                                                      maxValue: 100,
                                                      currentValue: state
                                                          .tshModel
                                                          .soilMoisture,
                                                      warningValue: 800,
                                                      displayText: '%',
                                                    ),
                                                  ],
                                                )),
                                              )),
                                        )),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Center(
                                          child: Card(
                                              elevation: 20,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: SizedBox(
                                                width: 185,
                                                height: 185,
                                                child: Center(
                                                    child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 7, 0, 0),
                                                        child: const Text(
                                                          "Humidity",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .blueAccent),
                                                        )),
                                                    Speedometer(
                                                      size: 150,
                                                      meterColor:
                                                          Colors.blueAccent,
                                                      kimColor: Colors.black,
                                                      backgroundColor:
                                                          Colors.white,
                                                      minValue: 0,
                                                      maxValue: 100,
                                                      currentValue: state
                                                          .tshModel.humidity,
                                                      warningValue: 800,
                                                      displayText: '%',
                                                    ),
                                                  ],
                                                )),
                                              )),
                                        )),
                                        Expanded(
                                          child: Center(
                                              child: Card(
                                                  elevation: 20,
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: SizedBox(
                                                    width: 180,
                                                    height: 180,
                                                    child: Center(
                                                      child: Image.memory(
                                                          base64Decode(
                                                              base64Image)),
                                                    ),
                                                  ))),
                                        )
                                      ],
                                    ),
                                    BlocProvider(
                                        create: (_) => _measurementsBloc,
                                        child:
                                            BlocListener<MeasurementsBloc,
                                                    MeasurementsState>(
                                                listener: (context, state) {},
                                                child: BlocBuilder<
                                                    MeasurementsBloc,
                                                    MeasurementsState>(
                                                  builder: (context, state) {
                                                    if (state
                                                        is MeasurementsLoaded) {
                                                      return Center(
                                                        child: Card(
                                                            elevation: 20,
                                                            color: Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: SizedBox(
                                                              width: 400,
                                                              height: 400,
                                                              child: Center(
                                                                  child:
                                                                      ListView(
                                                                children: <
                                                                    Widget>[
                                                                  Center(
                                                                    child: Container(
                                                                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                                        child: const Text(
                                                                          "Journal - Measurements",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w700),
                                                                        )),
                                                                  ),
                                                                  DataTable(
                                                                      columnSpacing:
                                                                          15.0,
                                                                      columns: const [
                                                                        DataColumn(
                                                                            label:
                                                                                Text(
                                                                          "Temperature",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        )),
                                                                        DataColumn(
                                                                            label:
                                                                                Text(
                                                                          "SMoisture",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        )),
                                                                        DataColumn(
                                                                            label:
                                                                                Text(
                                                                          "Humidity",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        )),
                                                                        DataColumn(
                                                                            label:
                                                                                Text(
                                                                          "Time",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ))
                                                                      ],
                                                                      rows: [
                                                                        ...getDataRowsForMeasurements(state
                                                                            .measurementsModel
                                                                            .measurments)
                                                                      ])
                                                                ],
                                                              )),
                                                            )),
                                                      );
                                                    } else {
                                                      return const Center();
                                                    }
                                                  },
                                                )))
                                  ]);
                            } else {
                              return ListView();
                            }
                          },
                        ),
                      )))
              : (currentScreen == Screens.history
                  ? Center(
                      child: Card(
                        elevation: 20,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                            child: BlocProvider(
                                create: (_) => _actionsBloc,
                                child: BlocListener<ActionsBloc, ActionsState>(
                                    listener: (context, state) {},
                                    child:
                                        BlocBuilder<ActionsBloc, ActionsState>(
                                      builder: (context, state) {
                                        if (state is ActionsLoaded) {
                                          return ListView(
                                            children: <Widget>[
                                              OutlinedButton(
                                                  onPressed: () => {watering()},
                                                  child: const Text(
                                                      "Start Watering",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .w700))),
                                              Center(
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 0, 0),
                                                    child: const Text(
                                                      "Journal - Actions",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    )),
                                              ),
                                              DataTable(
                                                  columnSpacing: 20.0,
                                                  columns: const [
                                                    DataColumn(
                                                        label: Text(
                                                      "Duration",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      "Time",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                  ],
                                                  rows: [
                                                    ...getDataRowsForActions(
                                                        state.actionsModel
                                                            .actions)
                                                  ])
                                            ],
                                          );
                                        } else {
                                          return ListView();
                                        }
                                      },
                                    )))),
                      ),
                    )
                  : Center(
                      child: Card(
                          elevation: 20,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView(
                            children: <Widget>[
                              Center(
                                child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                    child: const Text(
                                      "Settings",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 0),
                                      child: TextFormField(
                                        controller: durationController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.heat_pump),
                                          labelText:
                                              "Duration of the pumping process",
                                        ),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 0),
                                      child: TextFormField(
                                        controller: timeController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.timer),
                                          labelText: "Controlling time",
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 15),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setSettings(
                                                double.parse(
                                                    durationController.text),
                                                double.parse(
                                                    timeController.text));
                                          }
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(18.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () => setState(() => currentScreen = Screens.info),
                icon: Icon(Icons.equalizer,
                    color: currentScreen == Screens.info
                        ? Colors.white
                        : Colors.white70,
                    size: currentScreen == Screens.info ? 32.0 : 22.0),
                padding:
                    const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0)),
            IconButton(
                onPressed: () =>
                    setState(() => currentScreen = Screens.history),
                icon: Icon(Icons.history,
                    color: currentScreen == Screens.history
                        ? Colors.white
                        : Colors.white70,
                    size: currentScreen == Screens.history ? 32.0 : 22.0),
                padding:
                    const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0)),
            IconButton(
                onPressed: () =>
                    setState(() => currentScreen = Screens.settings),
                icon: Icon(Icons.settings,
                    color: currentScreen == Screens.settings
                        ? Colors.white
                        : Colors.white70,
                    size: currentScreen == Screens.settings ? 32.0 : 22.0),
                padding:
                    const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0)),
          ],
        ),
      ),
    );
  }
}

enum Screens { info, history, settings }
