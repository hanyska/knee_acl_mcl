class Exercise {
  final String? id;
  int? orderId;
  final Duration time;
  final int repeat;
  final Duration pauseTime;
  final String title;
  final String subtitle;
  bool inMainList;

  Exercise({
    this.id,
    this.orderId,
    required this.time,
    required this.repeat,
    this.pauseTime = const Duration(seconds: 3),
    required this.title,
    required this.subtitle,
    this.inMainList = false
  });

  Map<String, dynamic> toJson() => {
    'userId': id,
    'orderId': orderId,
    'time': time.inSeconds,
    'repeat': repeat,
    'pauseTime': pauseTime.inSeconds,
    'title': title,
    'subtitle': subtitle,
    'inMainList': inMainList,
  };

  factory Exercise.fromJson(String id, Map<String, dynamic> json) => Exercise(
    id: id,
    orderId: json['orderId'],
    time: Duration(seconds: json['time']),
    repeat: json['repeat'],
    pauseTime: Duration(seconds: json['pauseTime']),
    title: json['title'],
    subtitle: json['subtitle'],
    inMainList: json['inMainList'] ?? false,
  );

  static List<Exercise> fromJsonToList(dynamic json) => List<Exercise>
    .from((json as List)
    .map((i) => Exercise.fromJson(i.id, i.data())))
    .toList();
}
