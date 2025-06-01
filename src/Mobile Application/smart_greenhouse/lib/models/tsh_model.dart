class TSHModel {
  final int temperature;
  final int soilMoisture;
  final int humidity;

  TSHModel(
      {required this.temperature,
      required this.soilMoisture,
      required this.humidity});

  factory TSHModel.fromJson(Map<dynamic, dynamic> json) {
    try {
      return TSHModel(
          temperature: (json['temperature']),
          soilMoisture: (json['soilMoisture']),
          humidity: (json['humidity']));
    } catch (error) {
      print(error);
      return TSHModel(temperature: 0, soilMoisture: 0, humidity: 0);
    }
  }
}
