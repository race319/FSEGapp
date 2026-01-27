import 'package:get/get.dart';
import '../models/Voeuxexamen.dart';
import '../models/creneau.dart';
import '../service/voeuxexaminservice.dart';

class VoeuxExamenController extends GetxController {
  final VoeuxExamenService _service = Get.put(VoeuxExamenService());

  var creneauxList = <Creneau>[].obs;
  var voeuxList = <VoeuxExamen>[].obs;

  var isLoading = false.obs;



  var chargeTotale = 0.obs;
  RxList<int> selectedCreneaux = <int>[].obs;

  /// Heures restantes
  RxInt reste = 0.obs;

  /// Charge totale surveillance
  RxInt chargeSurveillance = 0.obs;


  final int heuresParCreneau = 2;




  @override
  void onInit() {
    super.onInit();
    fetchCreneaux();
    fetchVoeux();
  }


  Future<void> fetchCreneaux() async {
    try {
      isLoading.value = true;
      creneauxList.value = await _service.getCreneaux();
    } catch (e) {
      print("Erreur fetchCreneaux: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> storeVoeux() async {
    if (selectedCreneaux.isEmpty) {
      Get.snackbar("Info", "Aucun créneau sélectionné");
      return;
    }

    isLoading.value = true;

    try {
      // Envoyer la liste complète des créneaux
      final response = await _service.storeVoeux(selectedCreneaux);

      if (response['success'] == true) {
        Get.snackbar("Succès", response['message'] ?? "Vœux enregistrés",
            snackPosition: SnackPosition.BOTTOM);

        // Optionnel : vider la sélection après enregistrement
        selectedCreneaux.clear();
        await fetchVoeux();

      } else {
        Get.snackbar("Erreur", response['message'] ?? "Erreur lors de l'enregistrement",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Erreur", "Impossible d'enregistrer les vœux",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Heures déjà sélectionnées
  int get heuresSelectionnees => selectedCreneaux.length * heuresParCreneau;

  /// 🔹 Nombre de créneaux autorisés
  int get seancesAutorisees => (chargeSurveillance.value / heuresParCreneau).round();




  Future<void> supprimerVoeu(int codeCreneau) async {
    isLoading.value = true;
    try {
      final success = await _service.deleteVoeu(codeCreneau);
      if (success) {
        voeuxList.removeWhere((c) => c.codeCreneau == codeCreneau);
        Get.snackbar("Succès", "Vœu supprimé");
      } else {
        Get.snackbar("Erreur", "Impossible de supprimer le vœu");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChargeSurveillance() async {
    try {
      isLoading.value = true;
      chargeSurveillance.value = await _service.fetchChargeSurveillance();
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de charger la charge de surveillance");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchVoeux() async {
    isLoading.value = true;
    try {
      final data = await _service.fetchVoeux();
      voeuxList.value = data.map((json) => VoeuxExamen.fromJson(json)).toList();
    } finally {
      isLoading.value = false;
    }
  }


}
