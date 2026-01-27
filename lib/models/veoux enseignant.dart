class VoeuxEnseignement {
  final int id;
  final int codeEnseignant;
  final int codeJour;
  final int codeSeance;

  final DateTime createdAt;
  final DateTime updatedAt;

  VoeuxEnseignement({
    required this.id,
    required this.codeEnseignant,
    required this.codeJour,
    required this.codeSeance,

    required this.createdAt,
    required this.updatedAt,
  });

  factory VoeuxEnseignement.fromJson(Map<String, dynamic> json) {
    return VoeuxEnseignement(
      id: json['id'],
      codeEnseignant: json['code_enseignant'],
      codeJour: json['code_jour'],
      codeSeance: json['code_seance'],
      // ⚠️ Ajouter ça
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code_enseignant': codeEnseignant,
      'code_jour': codeJour,
      'code_seance': codeSeance,
       // ⚠️ Ajouter ça
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
