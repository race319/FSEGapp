import 'creneau.dart';

class VoeuxExamen {
  final int id;
  final int codeEnseignant;
  final int codeCreneau;
  final Creneau? creneau;

  VoeuxExamen({
    required this.id,
    required this.codeEnseignant,
    required this.codeCreneau,
    this.creneau,
  });

  factory VoeuxExamen.fromJson(Map<String, dynamic> json) {
    return VoeuxExamen(
      id: json['id'],
      codeEnseignant: json['code_enseignant'],
      codeCreneau: json['code_creneau'],
      creneau: json['creneau'] != null ? Creneau.fromJson(json['creneau']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code_enseignant': codeEnseignant,
      'code_creneau': codeCreneau,
      'creneau': creneau?.toJson(),
    };
  }
}
