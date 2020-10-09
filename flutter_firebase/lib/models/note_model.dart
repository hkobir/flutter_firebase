import 'package:intl/intl.dart';

class Note {
  String noteId, title, details, date;

  Note({this.noteId, this.title, this.details, this.date});

  Map<String, dynamic> noteModelToMap() {
    return {"title": this.title, "details": this.details, "date": this.date};
  }
}
