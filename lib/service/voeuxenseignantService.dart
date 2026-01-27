import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/veoux enseignant.dart';


class VoeuxEnseignementService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/'));
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<Map<String, dynamic>> addVoeux(int codeJour, int codeSeance) async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token manquant");
    }

    print("🔑 Token utilisé: ${token.substring(0, 20)}..."); // Debug
    print("📍 URL complète: ${_dio.options.baseUrl}voeux"); // Debug

    try {
      final response = await _dio.post(
        'voeux',
        data: {'code_jour': codeJour, 'code_seance': codeSeance},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print("✅ Status: ${response.statusCode}");
      print("📦 Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'],
          'reste': response.data['reste'],
          'voeu': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Erreur inconnue',
        };
      }
    } on DioException catch (e) {
      print("❌ DioException: ${e.type}");
      print("❌ Response: ${e.response?.data}");
      print("❌ Status Code: ${e.response?.statusCode}");

      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message ?? 'Erreur réseau',
      };
    } catch (e) {
      print("⛔ Erreur addVoeux: $e");
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  Future<bool> deleteVoeuxEnseignant(int id) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.delete(
        'voeux-enseignement/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Erreur deleteVoeuxEnseignant: $e");
      return false;
    }
  }
  Future<Map<String, dynamic>> getVoeux() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token manquant");
    }

    try {
      final response = await _dio.get(
        'voeux',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print("✅ getVoeux status: ${response.statusCode}");
      print("📦 getVoeux data: ${response.data}");

      if (response.statusCode == 200) {
        return {
          'success': true,
          'voeux': response.data['voeux'],
          'charge_totale': response.data['charge_totale'],
          'heures_selectionnees': response.data['heures_selectionnees'],
          'reste': response.data['reste'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Erreur inconnue',
        };
      }
    } on DioException catch (e) {
      print("❌ DioException getVoeux: ${e.type}");
      print("❌ Response: ${e.response?.data}");
      print("❌ Status Code: ${e.response?.statusCode}");

      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message ?? 'Erreur réseau',
      };
    } catch (e) {
      print("⛔ Erreur getVoeux: $e");
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  Future<Map<String, dynamic>> updateVoeuxBulk(List<Map<String, int>> nouveauxVoeux) async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token manquant");
    }

    try {
      final response = await _dio.put(
        'voeux/update',
        data: {'voeux': nouveauxVoeux},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print("✅ updateVoeuxBulk status: ${response.statusCode}");
      print("📦 updateVoeuxBulk data: ${response.data}");

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'],
          'reste': response.data['reste'],
          'voeux': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Erreur inconnue',
        };
      }
    } on DioException catch (e) {
      print("❌ DioException updateVoeuxBulk: ${e.type}");
      print("❌ Response: ${e.response?.data}");
      print("❌ Status Code: ${e.response?.statusCode}");

      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message ?? 'Erreur réseau',
      };
    } catch (e) {
      print("⛔ Erreur updateVoeuxBulk: $e");
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  Future<List<dynamic>> fetchVoeuxEnseignant() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'voeux-enseignement',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data['voeux'] as List<dynamic>;
    } catch (e) {
      print("Erreur fetchVoeuxEnseignant: $e");
      return [];
    }
  }








}
