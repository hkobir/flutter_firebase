class Note {
  String noteId, title, details;

  Note({this.noteId, this.title, this.details});

  Map<String, dynamic> noteModelToMap() {
    return {
      "title": this.title,
      "details": this.details
    };
  }
}
