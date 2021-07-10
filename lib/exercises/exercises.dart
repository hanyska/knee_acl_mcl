enum ExerciseType {SECONDS, REPETITIONS}

class Exercise {
  final Duration time;
  final int repeat;
  final Duration pauseTime;
  final String title;
  final String subtitle;
  final ExerciseType type;

  Exercise({
    required this.time,
    required this.repeat,
    this.pauseTime = const Duration(seconds: 3),
    required this.title,
    required this.subtitle,
    this.type = ExerciseType.SECONDS
  });
}

List<Exercise> databaseExercise = [
  Exercise(time: Duration(seconds: 2), repeat: 10, pauseTime: Duration(seconds: 2), title: 'Łydka', subtitle: 'Napinanie łydki - ruchy stopą góra dół'),
  Exercise(time: Duration(seconds: 5), repeat: 10, title: 'Miesięń czworogłowy - napinanie', subtitle: 'Napinanie mięsnia czworogłowego - spinamy mieśnie czworogłowe najmocniej jak potrafimy.'),
  Exercise(time: Duration(seconds: 5), repeat: 10, title: 'Miesięń czworogłowy - dociskanie', subtitle: 'Napinanie mięsnia czworogłowego - podkładamy wałeczek pod kolano i dociskamy kolanem z całej siły.'),
  Exercise(time: Duration(seconds: 10), repeat: 10, pauseTime: Duration(seconds: 10), title: 'Zginanie nogi', subtitle: 'Stopa ma cały czas kontakt z podłożem. Powoli piętą, do granicy bólu, zginamy nogę.'),
  Exercise(time: Duration(seconds: 5), repeat: 10, pauseTime: Duration(seconds: 5), title: 'Podnoszenie nogi', subtitle: 'Noga prosto, spinamy mieśnie czworogłowe i podnosimy na wysokość 10cm.'),
  Exercise(time: Duration(seconds: 5), repeat: 10, pauseTime: Duration(seconds: 10), title: 'Piłka - unoszenie bioder', subtitle: 'Na piłce ustawiamy nogi tak, aby łydki leżały przyklejone do piłki. Podnosimy biodra do samej góry. Z czasem można zwiększyć trudność i dodatkowo spinać pośladki.'),
  Exercise(time: Duration(seconds: 5), repeat: 10, pauseTime: Duration(seconds: 10), title: 'Piłka - zginanie kolana', subtitle: 'Na piłce ustawiamy nogi tak, aby kostki leżały przyklejone do piłki. Powoli przyciągamy obydwa kolana do siebie do granicy bólu. Następnie powoli prostujemy kolana.'),
  Exercise(time: Duration(seconds: 5), repeat: 10, pauseTime: Duration(seconds: 2), title: 'Unoszenie kolana w leżeniu bokiem', subtitle: 'Ustawimy się bokiem. Chorą nogę kładziemy na zdrowej w pozycji wyprostowanej. Unosimy chorą nogę na wysokość ok 10cm po czym powoli opuszczamy. W przypadku trudności z tym ćwiczeniem można delikatnie ugiąć nogi w kolanie.'),
  Exercise(time: Duration(seconds: 60), repeat: 3, pauseTime: Duration(seconds: 2), title: 'Rolowanie uda wałkiem ręcznym', subtitle: 'Wałek np. do ciasta rolujemy przednią część uda, boczną lewą, boczną prawą i najważniejsze tył.'),

];