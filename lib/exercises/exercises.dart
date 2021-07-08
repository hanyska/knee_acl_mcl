enum ExerciseType {SECONDS, REPETITIONS}

class Exercise {
  final int count;
  final String title;
  final String subtitle;
  final ExerciseType type;

  Exercise({
    required this.count,
    required this.title,
    required this.subtitle,
    this.type = ExerciseType.SECONDS
  });
}

List<Exercise> exercises = [
  Exercise(count: 10, title: 'Łydka', subtitle: 'Napinanie łydki - ruchy stopą góra dół', type: ExerciseType.REPETITIONS),
  Exercise(count: 10, title: 'Miesięń czworogłowy', subtitle: 'Napinanie mięsnia czworogłowego - spinamy mieśnie czworogłowe najmocniej jak potrafimy')
];