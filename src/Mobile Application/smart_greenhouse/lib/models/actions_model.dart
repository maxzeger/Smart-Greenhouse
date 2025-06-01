class ActionsModel {
  List<Actions> actions = [];

  ActionsModel({required this.actions});

  ActionsModel.fromJson(Map<String, dynamic> json) {
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions.add(new Actions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.actions != null) {
      data['actions'] = this.actions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Actions {
  String duration = "";
  String timeStamp = "";

  Actions({required this.duration, required this.timeStamp});

  Actions.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}
