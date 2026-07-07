class WaterLog {
  final int amount;
  final DateTime time;

  WaterLog({required this.amount, required this.time});

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'time': time.toIso8601String()};
  }

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(amount: json['amount'], time: DateTime.parse(json['time']));
  }
}
