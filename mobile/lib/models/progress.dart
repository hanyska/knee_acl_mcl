class Progress {
  final String? id;
  final DateTime date;
  final List<String?> doneIdExercises;
  final bool isDone;

  Progress({
    this.id,
    DateTime? date,
    this.doneIdExercises = const [],
    this.isDone = false
  }) : this.date = date ?? new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Map<String, dynamic> toJson() => {
    'date': date.toString(),
    'doneIdExercises': doneIdExercises,
    'isDone': isDone,
  };

  factory Progress.fromJson(String id, Map<String, dynamic> json) => Progress(
    id: id,
    date: DateTime.parse(json['date']),
    doneIdExercises: json['doneIdExercises'].toList().length != 0 ? List<String?>.from(json['doneIdExercises']) : [],
    isDone: json['isDone']
  );

  static List<Progress> fromJsonToList(dynamic json) => List<Progress>
      .from((json as List)
      .map((i) => Progress.fromJson(i.id, i.data())))
      .toList();
}
