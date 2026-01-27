import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../models/Voeuxexamen.dart';
import '../models/creneau.dart';

class VoeuxExamenService extends GetxService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8000/api/', // ton API
    receiveDataWhenStatusError: true,
  ));

  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }


  Future<bool> addVoeuxExamen(int codeCreneau) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.post(
        'voeuxexa',
        data: {'code_creneau': codeCreneau},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Erreur addVoeuxExamen: $e");
      return false;
    }
  }

  Future<bool> deleteVoeu(int codeCreneau) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      await _dio.delete(
        '/voeuxexa/$codeCreneau',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> fetchVoeux() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'voeuxexa',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.data['data'];
    } catch (e) {
      return [];
    }
  }


  Future<List<Creneau>> getCreneaux() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'creneaux',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      List data = response.data['data'];
      return data.map((json) => Creneau.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getCreneaux: $e");
      return [];
    }
  }


  Future<int> fetchChargeSurveillance() async {
    try {
      final token = await _getToken();

      final response = await _dio.get(
        '/enseignant/charge-surveillance',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.data['charge_surveillance'];
    } catch (e) {
      print("Erreur fetchChargeSurveillance: $e");
      throw Exception("Impossible de récupérer la charge");
    }
  }

  Future<Map<String, dynamic>> storeVoeux(List<int> codeCreneaux) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      // Envoyer un POST pour chaque créneau (ton backend accepte un seul code à la fois)
      List<Map<String, dynamic>> results = [];
      for (var code in codeCreneaux) {
        final response = await _dio.post(
          '/voeuxexa',
          data: {'code_creneau': code},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );
        results.add(response.data);
      }

      return {
        'success': true,
        'results': results,
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? 'Erreur lors de l\'ajout',
        'results': [],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur inattendue',
        'results': [],
      };
    }
  }
}
