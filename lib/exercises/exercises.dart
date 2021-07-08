enum ExerciseType {SECONDS, REPETITIONS}

class Exercise {
  final int count;
  final int repeat;
  final String title;
  final String subtitle;
  final ExerciseType type;

  Exercise({
    required this.count,
    required this.repeat,
    required this.title,
    required this.subtitle,
    this.type = ExerciseType.SECONDS
  });
}

List<Exercise> exercises = [
  Exercise(count: 2, repeat: 3, title: 'Łydka', subtitle: 'Napinanie łydki - ruchy stopą góra dół'),
  Exercise(count: 5, repeat: 10, title: 'Miesięń czworogłowy', subtitle: 'Napinanie mięsnia czworogłowego - spinamy mieśnie czworogłowe najmocniej jak potrafimy')
];