import 'User.dart';


class Inscrit {
  int? id;
  int codeEtudiant;
  int codeGroupe;
  String dateInscription;
  final UserModel? etudiant;

  Inscrit({
    this.id,
    required this.codeEtudiant,
    required this.codeGroupe,
    required this.dateInscription,
      this.etudiant,
  });

  factory Inscrit.fromJson(Map<String, dynamic> json) {
    return Inscrit(
      id: json['id'],
      codeEtudiant: json['code_etudiant'],
      codeGroupe: json['code_groupe'],
      dateInscription: json['date_inscription'],
      etudiant: json['etudiant'] != null
          ? UserModel.fromJson(json['etudiant'])
          : null,
    );
  }


}
