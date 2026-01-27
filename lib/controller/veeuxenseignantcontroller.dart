import 'package:get/get.dart';
import '../models/veoux enseignant.dart';
import '../service/voeuxenseignantService.dart';

class VoeuxEnseignementController extends GetxController {
  final VoeuxEnseignementService _service = VoeuxEnseignementService();

  var voeuxList = <VoeuxEnseignement>[].obs;
  var isLoading = false.obs;


  var chargeTotale = 0.obs;
  var heuresSelectionnees = 0.obs;
  var reste = 0.obs;


  var selections = <String, RxSet<int>>{}.obs;
  final List<String> jours = [
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi",
    "Dimanche"
  ];

  @override
  void onInit() {
    super.onInit();
    initSelections();
    getVoeux();
  }

  /// Initialiser les sélections
  void initSelections() {
    for (var jour in jours) {
      selections[jour] = <int>{}.obs;
    }
  }

  /// Réinitialiser les sélections depuis l’extérieur
  void resetSelections() {
    initSelections();
  }

  /// Getter pour le total des heures sélectionnées
  int get totalHeuresSelectionnees {
    int total = 0;
    selections.forEach((_, set) {
      total += set.length; // Chaque créneau = 1h, adapter si nécessaire
    });
    return total;
  }

  /// Ajouter un vœu
  Future<bool> addVoeux(int codeJour, int codeSeance) async {
    try {
      final result = await _service.addVoeux(codeJour, codeSeance);
      if (result['success'] == true && result['data'] != null) {
        voeuxList.add(VoeuxEnseignement.fromJson(result['data']));

        String jour = jours[codeJour - 1];
        selections[jour]?.add(codeSeance - 1);

        reste.value = result['reste'] ?? 0;

        return true; // Succès
      } else {
        print("Erreur: ${result['message']}");
        return false; // Échec
      }
    } catch (e) {
      print("Erreur addVoeux: $e");
      return false;
    }
  }


  Future<void> getVoeux() async {
    isLoading.value = true;
    try {
      final result = await _service.getVoeux();
      if (result['success'] == true) {
        voeuxList.value = (result['voeux'] as List)
            .map((e) => VoeuxEnseignement.fromJson(e))
            .toList();

        // Remplir les sélections existantes
        for (var voeu in voeuxList) {
          String jour = jours[voeu.codeJour - 1];
          int creneauIndex = voeu.codeSeance - 1;
          selections[jour]?.add(creneauIndex);
        }

        // Mettre à jour la charge
        chargeTotale.value = result['charge_totale'] ?? 0;
        heuresSelectionnees.value = result['heures_selectionnees'] ?? 0;
        reste.value = result['reste'] ?? 0;
      }
    } catch (e) {
      print("Erreur getVoeux: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Mise à jour des vœux en bulk
  Future<void> updateVoeuxBulk(List<Map<String, int>> nouveauxVoeux) async {
    isLoading.value = true;
    try {
      final result = await _service.updateVoeuxBulk(nouveauxVoeux);
      if (result['success'] == true && result['voeux'] != null) {
        voeuxList.value = (result['voeux'] as List)
            .map((e) => VoeuxEnseignement.fromJson(e))
            .toList();

        resetSelections();
        for (var voeu in voeuxList) {
          String jour = jours[voeu.codeJour - 1];
          selections[jour]?.add(voeu.codeSeance - 1);
        }

        reste.value = result['reste'] ?? 0;

        Get.snackbar(
          "Succès",
          result['message'] ?? "Vœux mis à jour",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Erreur",
          result['message'] ?? "Erreur lors de la mise à jour",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Erreur updateVoeuxBulk: $e");
      Get.snackbar("Erreur", "Une erreur est survenue");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchVoeux() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchVoeuxEnseignant();
      voeuxList.value = data.map((json) => VoeuxEnseignement.fromJson(json)).toList();
    } catch (e) {
      print("Erreur fetchVoeux GetX: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> supprimerVoeu(int id) async {
    try {
      final success = await _service.deleteVoeuxEnseignant(id);
      if (success) {
        voeuxList.removeWhere((v) => v.id == id);
        Get.snackbar("Succès", "Vœu supprimé avec succès");
      } else {
        Get.snackbar("Erreur", "Impossible de supprimer le vœu");
      }

    } catch (e) {
      print("Erreur supprimerVoeu GetX: $e");
      Get.snackbar("Erreur", "Erreur lors de la suppression du vœu");
    }
  }
}
