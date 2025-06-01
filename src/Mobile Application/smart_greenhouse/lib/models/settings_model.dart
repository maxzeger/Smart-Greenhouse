class SettingsModel {

  int duration = 0;
  int interval = 0;

  SettingsModel(this.duration, this.interval);

  SettingsModel.fromJson(Map<String, dynamic> json)
      : duration = json['duration'],
        interval = json['interval'];

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'interval': interval,
    };
  }
}