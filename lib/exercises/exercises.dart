import 'package:knee_acl_mcl/helpers/main_helper.dart';

enum ExerciseGroup {LEVEL1, LEVEL2, LEVEL3, ALL}

class Exercise {
  final String? id;
  final int? orderId;
  final Duration time;
  final int repeat;
  final Duration pauseTime;
  final String title;
  final String subtitle;
  final List<ExerciseGroup> group;

  Exercise({
    this.id,
    this.orderId,
    required this.time,
    required this.repeat,
    this.pauseTime = const Duration(seconds: 3),
    required this.title,
    required this.subtitle,
    this.group = const [ExerciseGroup.LEVEL1]
  });

  Map<String, dynamic> toJson() => {
    'userId': id,
    'orderId': orderId,
    'time': time.inSeconds,
    'repeat': repeat,
    'pauseTime': pauseTime.inSeconds,
    'title': title,
    'subtitle': subtitle,
    'group': group.map((e) => MainHelper.enumToString(e)).toList(),
  };

  factory Exercise.fromJson(String id, Map<String, dynamic> json) {
    List<ExerciseGroup> _groups = [];
    json['group'].forEach((e) => _groups.add(MainHelper.enumFromString(e, ExerciseGroup.values)!));

    return new Exercise(
      id: id,
      orderId: json['orderId'],
      time: Duration(seconds: json['time']),
      repeat: json['repeat'],
      pauseTime: Duration(seconds: json['pauseTime']),
      title: json['title'],
      subtitle: json['subtitle'],
      group: _groups
    );
  }

  static List<Exercise> fromJsonToList(dynamic json) => List<Exercise>
    .from((json as List)
    .map((i) => Exercise.fromJson(i.id, i.data())))
    .toList();
}