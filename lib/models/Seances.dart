import 'Matiere.dart';
import 'Salle.dart';
import 'User.dart';
import 'groupes.dart';

class Seance {
  int? id;
  String dateSeance;
  String heureSeance;
  int numeroSeance;
  int codeSalle;
  String nature;
  int nbSeances;
  int codeEnseignant;
  int codeGroupe;
  int? codeMatiere;
  bool etat;
  int? codeSurveillance; // ← Nouveau : ID de l'admin qui a fait l'absence
  DateTime? lockedAt;
  Salle? salle;
  UserModel? enseignant;
  Groupe? groupe;
  UserModel? surveillant;
  Matiere? matiere;// ← Nouveau : Objet UserModel de l'admin surveillant

  Seance({
    this.id,
    required this.dateSeance,
    required this.heureSeance,
    required this.numeroSeance,
    required this.codeSalle,
    required this.nature,
    required this.nbSeances,
    required this.codeEnseignant,
    required this.codeGroupe,
    required this.etat,
    this.codeSurveillance, // ← Ajouter
    this.salle,
    this.enseignant,
    this.groupe,
    this.surveillant,
    this.lockedAt,
    this.codeMatiere,
    this.matiere,// ← Ajouter
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: json['id'],
      dateSeance: json['date_seance'],
      heureSeance: json['heure_seance'],
      numeroSeance: json['numero_seance'],
      codeSalle: json['code_salle'],
      nature: json['nature'],
      nbSeances: json['nb_seances'],
      codeEnseignant: json['code_enseignant'],
      codeGroupe: json['code_groupe'],
      codeMatiere: json['code_matiere'],
      etat: json['etat'] == 1,
      codeSurveillance: json['code_surveillance'], // ← Récupérer l'ID
      salle: json['salle'] != null ? Salle.fromJson(json['salle']) : null,
      enseignant: json['enseignant'] != null ? UserModel.fromJson(json['enseignant']) : null,
      groupe: json['groupe'] != null ? Groupe.fromJson(json['groupe']) : null,
      surveillant: json['surveillant'] != null ? UserModel.fromJson(json['surveillant']) : null,
      matiere: json['matiere'] != null ? Matiere.fromJson(json['matiere']) : null,
      lockedAt: json['locked_at'] != null ? DateTime.parse(json['locked_at']) : null,// ← UserModel avec role='admin'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_seance': dateSeance,
      'heure_seance': heureSeance,
      'numero_seance': numeroSeance,
      'code_salle': codeSalle,
      'nature': nature,
      'nb_seances': nbSeances,
      'code_enseignant': codeEnseignant,
      'code_groupe': codeGroupe,
      'code_matiere': codeMatiere,
      'etat': etat ? 1 : 0,
      'code_surveillance': codeSurveillance, // ← Envoyer au backend si besoin
    };
  }
  bool isLockedWithDuration(int durationSeconds) {
    if (lockedAt == null) return false;
    final limit = lockedAt!.add(Duration(seconds: durationSeconds));
    return DateTime.now().isAfter(limit);
  }

}