class Matiere {
  int? codeMatiere;
  String nomMatiere;

  Matiere({
    this.codeMatiere,
    required this.nomMatiere,
  });


  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      codeMatiere: json['code_matiere'],
      nomMatiere: json['nom_matiere'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'code_matiere': codeMatiere,
      'nom_matiere': nomMatiere,
    };
  }
}
