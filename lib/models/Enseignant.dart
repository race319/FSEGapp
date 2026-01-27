import 'Horaire.dart';

class Enseignant {
  final int id;
  final int chargeEnseignement;
  final int chargeSurveillance;
  final Horaire? horaire;


  Enseignant({
    required this.id,
    required this.chargeEnseignement,
    required this.chargeSurveillance,
    this.horaire,
  });

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json['id'],
      chargeEnseignement: json['charge_enseignement'],
      chargeSurveillance: json['charge_surveillance'],
      horaire: json['horaire'] != null ? Horaire.fromJson(json['horaire']) : null,
    );
  }
}
