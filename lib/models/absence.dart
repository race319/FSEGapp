class Absence {
  int? id;
  int codeEtudiant;
  int codeMatiere;
  int codeEnseignant;
  DateTime dateAbsence;
  int seance;
  String statut;
  bool justifie;
  bool elimination;

  Absence({
    this.id,
    required this.codeEtudiant,
    required this.codeMatiere,
    required this.codeEnseignant,
    required this.dateAbsence,
    required this.seance,
    required this.statut,
    required this.justifie,
    this.elimination = false,
  });

  // ➤ Convertir JSON → Objet Dart
  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
      codeEtudiant: json['code_etudiant'],
      codeMatiere: json['code_matiere'],
      codeEnseignant: json['code_enseignant'],
      dateAbsence: json['date_absence'],
      seance: json['seance'],
      statut: json['statut'],
      justifie: json['justifie'] == 1 || json['justifie'] == true,
      elimination: json['elimination'] == 1 || json['elimination'] == true,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code_etudiant': codeEtudiant,
      'code_matiere': codeMatiere,
      'code_enseignant': codeEnseignant,
      'date_absence': dateAbsence,
      'seance': seance,
      'statut': statut,
      'justifie': justifie ? 1 : 0,
      'elimination': elimination ? 1 : 0,
    };
  }

  bool get isElimine => elimination;


  String get statutElimination => elimination ? 'Éliminé' : 'Non éliminé';
}
