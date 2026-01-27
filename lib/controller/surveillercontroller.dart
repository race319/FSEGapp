import 'package:get/get.dart';
import '../models/surveiller.dart';
import '../service/surveillerservice.dart';


class SurveillerController extends GetxController {
  final SurveillerService _service = SurveillerService();

  var surveillances = <SurveillerModel>[].obs;
  var isLoading = false.obs;

  /// Charger la liste
  Future<void> fetchSurveillances({int? enseignantId, int? creneauId}) async {
    isLoading.value = true;
    final data = await _service.getSurveillances(
      enseignantId: enseignantId,
      creneauId: creneauId,
    );
    surveillances.value = data;
    isLoading.value = false;
  }

  /// Modifier la qualité (S ou C)
  Future<void> changeQualite(int id, String newValue) async {
    bool success = await _service.updateQualite(id, newValue);

    if (success) {
      int index = surveillances.indexWhere((s) => s.id == id);
      if (index != -1) {
        surveillances[index].qualite = newValue;
        surveillances.refresh();
        Get.snackbar("Succès", "Qualité modifiée");
      }
    } else {
      Get.snackbar("Erreur", "Impossible de modifier");
    }
  }
}
