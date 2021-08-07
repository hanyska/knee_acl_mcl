import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/components/progress_bar.dart';
import 'package:knee_acl_mcl/components/toast.dart';
import 'package:knee_acl_mcl/exercises/widgets/exercise_model.dart';
import 'package:knee_acl_mcl/helpers/custom_dialog.dart';
import 'package:knee_acl_mcl/helpers/navigation_service.dart';
import 'package:knee_acl_mcl/providers/exercises_service.dart';
import 'package:knee_acl_mcl/utils/number_utils.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class ExerciseFormDialog extends StatefulWidget {
  final Exercise? exercise;

  const ExerciseFormDialog({
    Key? key,
    this.exercise
  }) : super(key: key);

  static Future<bool> show([Exercise? exercise]) {
    BuildContext _context = NavigationService.navigatorKey.currentContext!;

    return showDialog(
      context: _context,
      builder: (BuildContext context) => ExerciseFormDialog(exercise: exercise),
    )
    .then((value) {
      if (value) return true;
      return false;
    });
  }

  @override
  _ExerciseFormDialogState createState() => _ExerciseFormDialogState();
}

class _ExerciseFormDialogState extends State<ExerciseFormDialog> {
  final ProgressBar _progressBar = new ProgressBar();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();
  TextEditingController _repeatController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _pauseTimeController = TextEditingController();

  void onAddExercise() {
    _progressBar.show();
    ExercisesService.addExercise(Exercise(
      title: _titleController.text,
      subtitle: _subtitleController.text,
      repeat: NumberUtils.toInt(_repeatController.text) ?? 0,
      time: Duration(seconds: NumberUtils.toInt(_timeController.text) ?? 0),
    )).then((value) {
      Toaster.show('Pomyślnie dodano ćwiczenie!');
      _progressBar.hide();
      Navigator.of(context).pop(true);
    });
  }

  void onUpdateExercise() {
    _progressBar.show();
    ExercisesService.updatedExercise(Exercise(
      id: widget.exercise!.id,
      orderId: widget.exercise!.orderId,
      group: widget.exercise!.group,
      title: _titleController.text,
      subtitle: _subtitleController.text,
      repeat: NumberUtils.toInt(_repeatController.text) ?? 0,
      time: Duration(seconds: NumberUtils.toInt(_timeController.text) ?? 0),
    )).then((value) {
      Toaster.show('Pomyślnie zaktualizowano ćwiczenie!');
      _progressBar.hide();
      Navigator.of(context).pop(true);
    });
  }

  Widget get _body {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: 'Nazwa'),
        ),
        TextField(
          controller: _subtitleController,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(labelText: 'Opis'),
        ),
        TextField(
          controller: _repeatController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: 'Ilość powtórek',
              suffixText: 's'
          ),
        ),
        TextField(
          controller: _timeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Czas jednego powtórzenia',
            suffixText: 's'
          ),
        ),
        TextField(
          controller: _pauseTimeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Przerwa między ćwiczeniami',
            suffixText: 's'
          ),
        ),
      ],
    );
  }

  Widget get _footer {
    bool _exist = widget.exercise != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text('Anuluj'),
          style: TextButton.styleFrom(primary: kBlack),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text(_exist ? 'Zapisz' : 'Dodaj'),
          style: TextButton.styleFrom(primary: kPrimaryColor),
          onPressed: () => _exist ? onUpdateExercise() : onAddExercise(),
        ),
      ],
    );
  }


  @override
  void initState() {
    if (widget.exercise != null) {
      _titleController.text = widget.exercise!.title;
      _subtitleController.text = widget.exercise!.subtitle;
      _repeatController.text = widget.exercise!.repeat.toString();
      _timeController.text = widget.exercise!.time.inSeconds.toString();
      _pauseTimeController.text = widget.exercise!.pauseTime.inSeconds.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: widget.exercise?.title ?? 'Nowe ćwiczenie',
      body: _body,
      footer: _footer,
    );
  }
}
