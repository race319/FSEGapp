import 'groupes.dart';

class Enseignement {
  int? id;
  int codeEnseignant;
  int codeGroupe;
  int codeMatiere;
  String natureEnseignement;
  String? dateSeance;
  Groupe? groupe;

  Enseignement({
    this.id,
    required this.codeEnseignant,
    required this.codeGroupe,
    required this.codeMatiere,
    required this.natureEnseignement,
    this.dateSeance,
    this.groupe,
  });

  // ➤ Convertir JSON → Objet Dart
  factory Enseignement.fromJson(Map<String, dynamic> json) {
    return Enseignement(
      id: json['id'],
      codeEnseignant: json['code_enseignant'],
      codeGroupe: json['code_groupe'],
      codeMatiere: json['code_matiere'],
      natureEnseignement: json['nature_enseignement'],
      dateSeance: json['date_seance'], // nouveau champ
      groupe: json['groupe'] != null ? Groupe.fromJson(json['groupe']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code_enseignant': codeEnseignant,
      'code_groupe': codeGroupe,
      'code_matiere': codeMatiere,
      'nature_enseignement': natureEnseignement,
      'date_seance': dateSeance, // nouveau champ
      'groupe': groupe?.toJson(),
    };
  }
}
