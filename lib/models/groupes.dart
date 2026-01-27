class Groupe {
  int? codeGroupe;
  String nomGroupe;

  Groupe({this.codeGroupe, required this.nomGroupe});

  factory Groupe.fromJson(Map<String, dynamic> json) {
    return Groupe(
      codeGroupe: json['code_groupe'],
      nomGroupe: json['nom_groupe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code_groupe': codeGroupe,
      'nom_groupe': nomGroupe,
    };
  }
}
