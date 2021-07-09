class Notes {
  String nom = "";
  double note = 1;

  Notes(String nom, double note) {
    this.nom = nom;
    this.note = note;
  }

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(json['nom'], json['note']);
  }
}
