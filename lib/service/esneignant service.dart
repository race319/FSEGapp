import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/Enseignement.dart';

class EnseignantService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/'));
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<List<Enseignement>> getGroupes(int codeEnseignant, String date) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'enseignant/$codeEnseignant/groupes',
        queryParameters: {'date': date}, // envoyer la date
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      List data = response.data;
      return data.map((json) => Enseignement.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getGroupes: $e");
      return [];
    }
  }


  Future<int> getChargeEnseignement() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'enseignant/charge',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.data['charge_enseignement'];
    } catch (e) {
      print("Erreur getChargeEnseignement: $e");
      return 0;
    }
  }
}
