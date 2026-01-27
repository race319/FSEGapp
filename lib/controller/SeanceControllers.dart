import 'package:get/get.dart';

import '../models/Seances.dart';
import '../service/SeanceServices.dart';


class SeanceController extends GetxController {
  final SeanceService _service = SeanceService();

  var seances = <Seance>[].obs;
  var selectedDate = ''.obs;
  var isLoading = false.obs;
  int absenceModificationSeconds = 0;
  Future<void> filterSeances(String date, {String? heure}) async {
    try {
      isLoading.value = true;
      selectedDate.value = date;


      final data = await _service.filterSeances(date, heure: heure);
      seances.value = data;
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchConfig() async {
    await _service.fetchConfig();
    absenceModificationSeconds = _service.absenceModificationSeconds;
  }

  Future<bool> toggleEtat(Seance seance) async {
    final newEtat = !seance.etat;

    try {
      final updatedSeance = await _service.updateEtat(seance.id!, newEtat);
      if (updatedSeance != null) {
        final index = seances.indexWhere((s) => s.id == seance.id);
        if (index != -1) {
          seances[index].etat = newEtat;
          seances[index].lockedAt = DateTime.now();
          seances.refresh();
        }
        return true;
      }
    } catch (e) {
      _afficherMessageErreur(e);
    }
    return false;
  }


  void _afficherMessageErreur(dynamic error) {
    String errorMessage = "Une erreur s'est produite";

    if (error.toString().contains('délai dépassé') ||
        error.toString().contains('Modification impossible')) {
      errorMessage = "⏱️ Délai de modification dépassé ! Vous ne pouvez plus modifier cette séance.";
    }

    Get.snackbar(
      "❌ Modification refusée",
      errorMessage,
      duration: Duration(seconds: 4),
      snackPosition: SnackPosition.BOTTOM,
    );
  }


}
