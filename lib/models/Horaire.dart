class Horaire {
  final int id;
  final String jour;
  final String creneau;

  Horaire({
    required this.id,
    required this.jour,
    required this.creneau,
  });

  factory Horaire.fromJson(Map<String, dynamic> json) {
    return Horaire(
      id: json['id'],
      jour: json['jour'],
      creneau: json['creneau'],
    );
  }
}
