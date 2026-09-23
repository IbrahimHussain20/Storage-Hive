import 'package:hive/hive.dart';
import 'package:store/models/notes_models.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}
