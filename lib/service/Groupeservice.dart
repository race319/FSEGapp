import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/Inscrit.dart';
import '../models/Matiere.dart';

class GroupeService {
  final Dio _dio = Dio(BaseOptions(baseUrl:'http://141.98.155.114:8080//api/'));
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<List<Inscrit>> getEtudiants(int codeGroupe) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'groupe/$codeGroupe/etudiants',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      List data = response.data; // Laravel renvoie directement la liste
      return data.map((json) => Inscrit.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getEtudiants: $e");
      return [];
    }
  }
  Future<List<Matiere>> getMatieres(int codeGroupe) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'groupe/$codeGroupe/matieres',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      List data = response.data;
      return data.map((json) => Matiere.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getMatieres: $e");
      return [];
    }
  }

}
