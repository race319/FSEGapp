import 'package:get/get.dart';

import '../models/absence.dart';
import '../service/Absenceservice.dart';


class AbsenceControllerFlutter extends GetxController {
  final AbsenceService _service = AbsenceService();

  RxList enseignants = [].obs;
  RxList absences = [].obs;
  RxInt totalAbsences = 0.obs;
  RxBool isLoading = false.obs;
  RxInt selectedEnseignantId = 0.obs;
  var nombreAbsences = 0.obs;
  var estElimine = false.obs;
  var statutElimination = ''.obs;


  @override
  void onInit() {
    super.onInit();

  }

  Future<bool> marquerAbsence(Absence absence) async {
    try {
      print("📤 Envoi absence : ${absence.toJson()}");

      final response = await _service.marquerAbsence(absence);

      if (response.statusCode == 200) {
        print("✅ Absence enregistrée avec succès");
        return true;
      } else {
        print("❌ Erreur : ${response.statusCode} - ${response.data}");
        return false;
      }
    } catch (e) {
      print("❌ Exception : $e");
      return false;
    }
  }
  Future<bool> updateAbsence(int id, {String? statut, bool? justifie}) async {
    isLoading.value = true;
    final result = await _service.updateAbsence(id, statut: statut, justifie: justifie);
    isLoading.value = false;
    return result;
  }
  Future<Map<String, dynamic>?> loadAbsencesInfo(int codeEtudiant, int codeMatiere) async {
    try {
      isLoading.value = true;

      final data = await _service.getNombreAbsences(codeEtudiant, codeMatiere);

      if (data != null && data['success'] == true) {
        nombreAbsences.value = data['nombre_absences'] ?? 0;
        estElimine.value = data['est_elimine'] ?? false;
        statutElimination.value = data['statut_elimination'] ?? 'Non éliminé';

        return data;
      }

      return null;
    } catch (e) {
      print('Erreur loadAbsencesInfo: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> toggleElimination({
    required int codeEtudiant,
    required int codeMatiere,
  }) async {
    final newStatut = !estElimine.value;

    final success = await _service.marquerElimination(
      codeEtudiant: codeEtudiant,
      codeMatiere: codeMatiere,
      elimination: newStatut,
    );

    if (success) {
      estElimine.value = newStatut;
      statutElimination.value = newStatut ? 'Éliminé' : 'Non éliminé';


      await loadAbsencesInfo(codeEtudiant, codeMatiere);
    }

    return success;
  }

  Future<bool> changerElimination({
    required int codeEtudiant,
    required int codeMatiere,
    required bool elimination,
  }) async {
    try {
      // Appeler la méthode du service
      final success = await _service.marquerElimination(
        codeEtudiant: codeEtudiant,
        codeMatiere: codeMatiere,
        elimination: elimination,
      );

      if (success) {
        // Optionnel : Afficher un message de succès
        Get.snackbar(
          'Succès',
          elimination ? 'Étudiant éliminé' : 'Élimination annulée',

        );
      }

      return success;
    } catch (e) {
      print("Erreur changerElimination: $e");
      Get.snackbar(
        'Erreur',
        'Impossible de modifier l\'élimination',

      );
      return false;
    }
  }


  Future<bool> marquerElimine({
    required int codeEtudiant,
    required int codeMatiere,
  }) async {
    return await changerElimination(
      codeEtudiant: codeEtudiant,
      codeMatiere: codeMatiere,
      elimination: true,
    );
  }


  Future<bool> marquerNonElimine({
    required int codeEtudiant,
    required int codeMatiere,
  }) async {
    return await changerElimination(
      codeEtudiant: codeEtudiant,
      codeMatiere: codeMatiere,
      elimination: false,
    );
  }

}
