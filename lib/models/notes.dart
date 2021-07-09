class Note {
  String nom = "";
  double note = 1;

  Note(String nom, double note) {
    this.nom = nom;
    this.note = note;
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(json['nom'], json['note']);
  }

  @override
  String toString() {
    return "${note.toString()}";
  }
}
