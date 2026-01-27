import 'package:get/get.dart';
import '../models/Inscrit.dart';
import '../service/Groupeservice.dart';


class GroupeControllerFlutter extends GetxController {
  final GroupeService _service = GroupeService();

  var etudiants = <Inscrit>[].obs;
  var isLoading = false.obs;

  Future<void> fetchEtudiants(int codeGroupe) async {
    try {
      isLoading.value = true;
      final data = await _service.getEtudiants(codeGroupe);
      etudiants.value = data;
    } catch (e) {
      print("Erreur fetchEtudiants: $e");
      etudiants.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
