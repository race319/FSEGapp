import 'package:get/get.dart';
import '../models/Matiere.dart';
import '../service/Groupeservice.dart';


class MatiereController extends GetxController {
  final GroupeService _service = GroupeService();

  var matieres = <Matiere>[].obs;
  var isLoading = false.obs;

  Future<void> fetchMatieres(int codeGroupe) async {
    try {
      isLoading.value = true;
      matieres.value = await _service.getMatieres(codeGroupe);
    } catch (e) {
      print("Erreur fetchMatieres: $e");
      matieres.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
