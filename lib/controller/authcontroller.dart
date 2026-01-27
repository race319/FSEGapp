import 'package:get/get.dart';
import '../models/user.dart';
import '../service/authservice.dart';
import '../views/admin/admin hompage.dart';
import '../views/enseignant/EnseignantHome.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var user = Rxn<UserModel>();
  var token = ''.obs;
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    try {
      final response = await _authService.login(email, password);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>; // <-- correction
        token.value = data['access_token'];
        user.value = UserModel.fromJson(data['user']);

        // Sauvegarder le token dans le stockage sécurisé
        await _authService.saveToken(token.value);

        Get.snackbar("Bienvenue", "Connexion réussie !");
        _navigateByRole(user.value!.role);
      } else {
        Get.snackbar("Erreur", "Identifiants invalides");
      }
    } catch (e) {
      print("Erreur login: $e");
      Get.snackbar("Erreur", "Une erreur est survenue");
    }

    isLoading.value = false;
  }

  Future<void> logout() async {
    try {
      await _authService.logout(); // supprime le token et appelle l'API si besoin
      token.value = '';
      user.value = null;

      Get.offAllNamed('/login');
      Get.snackbar("Déconnecté", "Vous êtes déconnecté !");
    } catch (e) {
      print("Erreur logout: $e");
      Get.snackbar("Erreur", "Une erreur est survenue lors de la déconnexion");
    }
  }

  void _navigateByRole(String role) {
    if (role == 'admin') {
      Get.offAll(HomeAdmin());
    } else if (role == 'enseignant') {
      Get.offAll(HomeEnseignant());
    } else {
      Get.snackbar("Erreur", "Rôle inconnu");
    }
  }
}
