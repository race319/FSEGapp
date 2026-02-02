import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://141.98.155.114:8080//api/auth",
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  final FlutterSecureStorage storage = const FlutterSecureStorage();


  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/loginn',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print('📦 Réponse du login: ${response.data}');

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        // ✅ Stocker le token
        await saveToken(response.data['access_token']);

        // ✅ NOUVEAU : Stocker le code_enseignant (ID de l'utilisateur)
        if (response.data['user'] != null && response.data['user']['id'] != null) {
          await storage.write(
            key: 'code_enseignant',
            value: response.data['user']['id'].toString(),
          );
          print('✅ Code enseignant stocké : ${response.data['user']['id']}');
        }

        // ✅ BONUS : Stocker d'autres infos utiles
        if (response.data['user'] != null) {
          await storage.write(
            key: 'user_name',
            value: response.data['user']['name'] ?? '',
          );
          await storage.write(
            key: 'user_email',
            value: response.data['user']['email'] ?? '',
          );
          await storage.write(
            key: 'user_role',
            value: response.data['user']['role'] ?? '',
          );
          print('✅ Informations utilisateur stockées');
        }
      }

      return response;
    } catch (e) {
      print('❌ Erreur de login: $e');
      rethrow;
    }
  }

  // Enregistrer le token
  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
    print('✅ Token stocké');
  }

  // Récupérer le token
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // ✅ NOUVEAU : Récupérer le code_enseignant
  Future<String?> getCodeEnseignant() async {
    return await storage.read(key: 'code_enseignant');
  }

  // ✅ NOUVEAU : Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    final codeEnseignant = await storage.read(key: 'code_enseignant');
    return token != null && codeEnseignant != null;
  }

  // ✅ NOUVEAU : Debug du storage
  Future<void> debugStorage() async {
    print("\n========== CONTENU DU STORAGE ==========");

    final token = await storage.read(key: 'token');
    final codeEnseignant = await storage.read(key: 'code_enseignant');
    final userName = await storage.read(key: 'user_name');
    final userEmail = await storage.read(key: 'user_email');
    final userRole = await storage.read(key: 'user_role');

    print("🔑 Token : ${token != null ? 'PRÉSENT' : 'ABSENT'}");
    print("👤 Code enseignant : ${codeEnseignant ?? 'ABSENT'}");
    print("📝 Nom : ${userName ?? 'ABSENT'}");
    print("📧 Email : ${userEmail ?? 'ABSENT'}");
    print("🎭 Rôle : ${userRole ?? 'ABSENT'}");

    print("========================================\n");
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      final token = await storage.read(key: 'token');

      if (token != null) {
        await _dio.post(
          '/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }

      // ✅ Supprimer TOUTES les données du storage
      await storage.deleteAll();
      print("✅ Déconnecté avec succès - Storage nettoyé");

    } on DioException catch (e) {
      print("❌ Erreur logout: ${e.response?.data}");
      // Même en cas d'erreur, on nettoie le storage local
      await storage.deleteAll();
    } catch (e) {
      print("❌ Erreur logout: $e");
      await storage.deleteAll();
    }
  }
}