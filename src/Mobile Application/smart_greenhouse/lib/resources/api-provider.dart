import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_greenhouse/models/actions_model.dart';
import 'package:smart_greenhouse/models/measurements_model.dart';
import 'package:smart_greenhouse/models/tsh_model.dart';
import 'package:smart_greenhouse/settings.dart';

class ApiProvider {
  final Dio _dio = Dio();

  Future<TSHModel> fetchTSH() async {
    try {
      Response response = await _dio.get('${Settings.address}/getTSH');
      return TSHModel.fromJson(response.data);
    } catch (error) {
       if (kDebugMode) {
         print(error);
       }
    }
    return TSHModel(temperature: 0, soilMoisture: 0, humidity: 0);
  }

  Future<ActionsModel> fetchActions() async {
    try {
      Response response = await _dio.get('${Settings.address}/getActions');
      return ActionsModel.fromJson(response.data);
    } catch (error) {
       if (kDebugMode) {
         print(error);
       }
    }
    return ActionsModel(actions: []);
  }

  Future<MeasurementsModel> fetchMeasurements() async {
    try {
      Response response =
          await _dio.get('${Settings.address}/getMeasurements');
      print(response.data);
      return MeasurementsModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return MeasurementsModel(measurments: []);
  }
}
