import 'User.dart';
import 'creneau.dart';


class SurveillerModel {
  final int? id;
  final int codeEnseignant;
  final int codeCreneau;
  String qualite; // peut être modifiable dans le controller
  final String? createdAt;
  final String? updatedAt;

  // Relations
  final UserModel? enseignant; // enseignant récupéré depuis API
  final Creneau? creneau; // si tu as un model creneau

  SurveillerModel({
    this.id,
    required this.codeEnseignant,
    required this.codeCreneau,
    required this.qualite,
    this.createdAt,
    this.updatedAt,
    this.enseignant,
    this.creneau,
  });

  factory SurveillerModel.fromJson(Map<String, dynamic> json) {
    return SurveillerModel(
      id: json['id'],
      codeEnseignant: json['code_enseignant'],
      codeCreneau: json['code_creneau'],
      qualite: json['qualite'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      enseignant: json['enseignant'] != null
          ? UserModel.fromJson(json['enseignant'])
          : null,
      creneau: json['creneau'] != null
          ? Creneau.fromJson(json['creneau'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code_enseignant': codeEnseignant,
      'code_creneau': codeCreneau,
      'qualite': qualite,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'enseignant': enseignant?.toJson(),
      'creneau': creneau?.toJson(),
    };
  }
}
