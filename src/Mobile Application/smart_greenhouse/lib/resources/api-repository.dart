import 'package:smart_greenhouse/models/actions_model.dart';
import 'package:smart_greenhouse/models/measurements_model.dart';
import 'package:smart_greenhouse/resources/api-provider.dart';
import 'package:smart_greenhouse/models/tsh_model.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<TSHModel> fetchTsh() {
    return _provider.fetchTSH();
  }

  Future<ActionsModel> fetchActions() {
    return _provider.fetchActions();
  }

  Future<MeasurementsModel> fetchMeasurements() {
    return _provider.fetchMeasurements();
  }
}

class NetworkError extends Error {}
