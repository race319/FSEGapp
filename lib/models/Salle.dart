class Salle {
  int? codeSalle;
  String nomSalle;

  Salle({this.codeSalle, required this.nomSalle});

  factory Salle.fromJson(Map<String, dynamic> json) {
    return Salle(
      codeSalle: json['code_salle'],
      nomSalle: json['nom_salle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code_salle': codeSalle,
      'nom_salle': nomSalle,
    };
  }
}
