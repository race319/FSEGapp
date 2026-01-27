import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../models/absence.dart';

class AbsenceService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/'));
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<Response> marquerAbsence(Absence absence) async {
    try {
      String? token = await _storage.read(key: 'token');


      final formattedDate = DateFormat('yyyy-MM-dd').format(absence.dateAbsence);

      final data = {
        'code_etudiant': absence.codeEtudiant,
        'code_matiere': absence.codeMatiere,
        'code_enseignant': absence.codeEnseignant,
        'seance': absence.seance,
        'statut': absence.statut,
        'justifie': absence.justifie ? 1 : 0,
        'date_absence': formattedDate,
      };

      print("📦 Données envoyées : $data");

      final response = await _dio.post(
        '/absence',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      return response;
    } catch (e) {
      print("❌ Erreur marquerAbsence : $e");
      rethrow;
    }
  }
  Future<bool> updateAbsence(int id, {String? statut, bool? justifie}) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.put(
        'absence/$id',
        data: {
          'statut': statut,
          'justifie': justifie,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Erreur updateAbsence: $e");
      return false;
    }
  }

  Future<List<dynamic>> getEnseignants() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'enseignants',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } catch (e) {
      print("Erreur getEnseignants: $e");
      return [];
    }
  }


  Future<Map<String, dynamic>> getAbsencesByTeacher(int id) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'absences/enseignant/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } catch (e) {
      print("Erreur getAbsencesByTeacher: $e");
      return {};
    }
  }
  Future<Map<String, dynamic>?> getNombreAbsences(
      int codeEtudiant,
      int codeMatiere
      ) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.get(
        'absences/etudiant/$codeEtudiant/matiere/$codeMatiere',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data['success']) {
        return response.data;
      }
      return null;
    } catch (e) {
      print("Erreur getNombreAbsences: $e");
      return null;
    }
  }
  Future<bool> marquerElimination({
    required int codeEtudiant,
    required int codeMatiere,
    required bool elimination,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token manquant");

      final response = await _dio.post(
        'absences/elimination',
        data: {
          'code_etudiant': codeEtudiant,
          'code_matiere': codeMatiere,
          'elimination': elimination ? 1 : 0,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},

        ),
      );

      return response.statusCode == 200 && response.data['success'];
    } catch (e) {
      print("Erreur marquerElimination: $e");
      return false;
    }
  }


}
