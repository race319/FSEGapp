class Creneau {
  final int codeCreneau;
  final String date;
  final String heureDebut;
  final String heureFin;

  Creneau({
    required this.codeCreneau,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
  });
  factory Creneau.fromJson(Map<String, dynamic> json) {
    return Creneau(
      codeCreneau: json['code_creneau'],
      date: json['date'],
      heureDebut: json['heure_debut'],
      heureFin: json['heure_fin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code_creneau': codeCreneau,
      'date': date,
      'heure_debut': heureDebut,
      'heure_fin': heureFin,
    };
  }
}
