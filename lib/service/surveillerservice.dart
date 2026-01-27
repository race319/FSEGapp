import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/surveiller.dart';


class SurveillerService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/'));
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  /// 📌 Récupérer toutes les surveillances
  Future<List<SurveillerModel>> getSurveillances({int? enseignantId, int? creneauId}) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      Map<String, dynamic> queryParams = {};
      if (enseignantId != null) queryParams['enseignant_id'] = enseignantId;
      if (creneauId != null) queryParams['creneau_id'] = creneauId;

      final response = await _dio.get(
        'surveiller',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      List data = response.data['data']; // prend la liste dans "data"
      return data.map((json) => SurveillerModel.fromJson(json)).toList();

    } catch (e) {
      print("Erreur getSurveillances: $e");
      return [];
    }
  }

  /// ✏️ Modifier la qualité (S ou C)
  Future<bool> updateQualite(int id, String qualite) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.put(
        'surveiller/$id/qualite',  // correspond à updateQualite dans Laravel
        data: {'qualite': qualite},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;

    } catch (e) {
      print("Erreur updateQualite: $e");
      return false;
    }
  }
}
