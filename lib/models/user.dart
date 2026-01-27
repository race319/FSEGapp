class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final int? codeEnseignant;
  final int? codeEtudiant;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.codeEnseignant,
    this.codeEtudiant,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      codeEnseignant: json['code_enseignant'],
      codeEtudiant: json['code_etudiant'], // ← récupérer depuis JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'code_enseignant': codeEnseignant,
      'code_etudiant': codeEtudiant,
    };
  }
}
