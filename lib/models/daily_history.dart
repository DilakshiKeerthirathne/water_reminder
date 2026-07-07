class DailyHistory {
  final String date; // yyyy-MM-dd
  int total;

  DailyHistory({required this.date, required this.total});

  Map<String, dynamic> toJson() => {'date': date, 'total': total};

  factory DailyHistory.fromJson(Map<String, dynamic> json) {
    return DailyHistory(date: json['date'], total: json['total']);
  }
}
