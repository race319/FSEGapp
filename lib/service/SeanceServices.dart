import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/Seances.dart';


class SeanceService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://141.98.155.114:8080//api/',
  ));

  final _storage = const FlutterSecureStorage();
  int absenceModificationSeconds = 0;

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }


  Future<List<Seance>> filterSeances(String date, {String? heure}) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.post(
        'seances',
        data: {
          'date_seance': date,
          if (heure != null) 'heure_seance': heure,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      List data = response.data['data'];
      return data.map((json) => Seance.fromJson(json)).toList();
    } catch (e) {
      print("Erreur filterSeances: $e");
      return [];
    }
  }
  Future<void> fetchConfig() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        '/seances/config',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        absenceModificationSeconds = response.data['absence_modification_seconds'];
        print('Durée récupération : $absenceModificationSeconds secondes');
      }
    } catch (e) {
      print("Erreur fetchConfig: $e");
    }
  }

  Future<Seance?> updateEtat(int seanceId, bool etat) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.put(
        'seances/$seanceId/etat',
        data: {'etat': etat ? 1 : 0},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );
      print("📥 Réponse backend: ${response.data}");


      if (response.statusCode == 200 && response.data['data'] != null) {
        return Seance.fromJson(response.data['data']);
      }

      return null;
    } catch (e) {
      print("Erreur updateEtat: $e");
      return null;
    }
  }
}
