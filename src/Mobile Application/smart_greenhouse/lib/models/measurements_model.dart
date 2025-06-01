class MeasurementsModel {
  List<Measurments> measurments = [];

  MeasurementsModel({required this.measurments});

  MeasurementsModel.fromJson(Map<String, dynamic> json) {
    if (json['measurements'] != null) {
      measurments = <Measurments>[];
      json['measurements'].forEach((v) {
        measurments.add(new Measurments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.measurments != null) {
      data['measurements'] = this.measurments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Measurments {
  int temperature = 0;
  int soilMoisture = 0;
  int humidity = 0;
  String timeStamp = "";

  Measurments(
      {required this.temperature,
      required this.soilMoisture,
      required this.humidity,
      required this.timeStamp});

  Measurments.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'];
    soilMoisture = json['soilMoisture'];
    humidity = json['humidity'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temperature;
    data['soilMoisture'] = this.soilMoisture;
    data['humidity'] = this.humidity;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}
