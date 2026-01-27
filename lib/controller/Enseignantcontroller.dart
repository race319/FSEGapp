import 'package:get/get.dart';
import '../models/Enseignement.dart';
import '../service/esneignant service.dart';
import 'package:intl/intl.dart';


class EnseignantControllerFlutter extends GetxController {
  final EnseignantService _service = EnseignantService();
  var groupes = <Enseignement>[].obs;
  var isLoading = false.obs;
  var chargeEnseignement = 0.obs;


  Future<void> fetchGroupes(int codeEnseignant, {String? date}) async {
    try {
      print("\n========== DEBUT fetchGroupes CONTROLLER ==========");
      isLoading.value = true;

      // ✅ LOG 1 : Date avant formatage
      print("📅 Date reçue en paramètre : ${date ?? 'NULL'}");

      final selectedDateStr = date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

      // ✅ LOG 2 : Date après formatage
      print("📅 Date formatée : $selectedDateStr");
      print("👤 Code enseignant : $codeEnseignant");

      // Appel du service
      print("🔄 Appel du service...");
      final data = await _service.getGroupes(codeEnseignant, selectedDateStr);

      // ✅ LOG 3 : Résultat
      print("📦 Données reçues du service : ${data.length} groupes");

      groupes.value = data;

      if (groupes.isEmpty) {
        print("⚠️ ATTENTION : Aucun groupe dans le controller");
      } else {
        print("✅ ${groupes.length} groupes chargés dans le controller");
        print("📋 IDs des groupes : ${groupes.map((g) => g.id).toList()}");
      }

      print("========== FIN fetchGroupes CONTROLLER ==========\n");
    } catch (e, stackTrace) {
      print("❌ EXCEPTION dans fetchGroupes : $e");
      print("📚 Stack trace : $stackTrace");
      groupes.clear();
      print("========== FIN fetchGroupes CONTROLLER ==========\n");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchCharge() async {
    try {
      isLoading.value = true;
      chargeEnseignement.value = await _service.getChargeEnseignement();
    } catch (e) {
      print("Erreur fetchCharge: $e");
    } finally {
      isLoading.value = false;
    }
  }



}
