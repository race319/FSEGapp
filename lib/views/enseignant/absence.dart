import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../controller/Enseignantcontroller.dart';
import '../../controller/MatiereController.dart';
import '../../controller/groupescontrollers.dart';
import '../../controller/AbsenceController.dart';
import '../../models/Enseignement.dart';
import '../../models/Matiere.dart';
import '../../models/absence.dart';

class AbsenceView2 extends StatefulWidget {
  const AbsenceView2({Key? key}) : super(key: key);

  @override
  State<AbsenceView2> createState() => _AbsenceView2State();
}

class _AbsenceView2State extends State<AbsenceView2> {
  final EnseignantControllerFlutter enseignantController =
  Get.put(EnseignantControllerFlutter());
  final MatiereController matiereController = Get.put(MatiereController());
  final GroupeControllerFlutter groupeController =
  Get.put(GroupeControllerFlutter());
  final AbsenceControllerFlutter absenceController =
  Get.put(AbsenceControllerFlutter());

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLoading = true;

  Enseignement? selectedGroupe;
  Matiere? selectedMatiere;
  int selectedSeance = 1;

  RxString selectedDate = DateTime.now().toIso8601String().split('T')[0].obs;
  final Map<int, bool> _presenceStatus = {};
  final Map<int, int> _absencesCount = {};
  final Map<int, bool> _eliminationStatus = {};

  @override
  void initState() {
    super.initState();
    _initializeCodeEnseignant();
  }

  Future<void> _initializeCodeEnseignant() async {
    String? codeStr = await _storage.read(key: 'code_enseignant');
    if (codeStr != null) {
      await enseignantController.fetchGroupes(
        int.parse(codeStr),
        date: selectedDate.value,
      );
    }
    setState(() => _isLoading = false);
  }

  void _setPresence(int studentId, bool status) {
    setState(() {
      _presenceStatus[studentId] = status;
    });
  }

  Future<void> _loadAbsencesInfo() async {
    if (selectedMatiere == null) return;

    for (var etu in groupeController.etudiants) {
      final studentId = etu.etudiant?.id ?? etu.codeEtudiant;

      final info = await absenceController.loadAbsencesInfo(
          studentId, selectedMatiere!.codeMatiere!);

      if (info != null) {
        setState(() {
          _absencesCount[studentId] = info['nombre_absences'] ?? 0;
          _eliminationStatus[studentId] = info['est_elimine'] ?? false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 16),
                _buildFiltersSection(),
              ],
            ),
          ),
          _buildEtudiantsList(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: _buildSaveButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF1E3A8A),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "Gestion des Absences",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        background: Container(
          color: const Color(0xFF1E3A8A),
        ),
      ),
      elevation: 0,
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Obx(() {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Date de séance",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE dd MMMM yyyy', 'fr_FR')
                        .format(DateTime.parse(selectedDate.value)),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _pickDate,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_calendar,
                  color: Color(0xFF1E3A8A),
                  size: 20,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Filtres de sélection",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          _buildGroupeDropdown(),
          const SizedBox(height: 12),
          _buildMatiereDropdown(),
          const SizedBox(height: 12),
          _buildSeanceDropdown(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(selectedDate.value),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = DateFormat('yyyy-MM-dd').format(picked);

      String? codeStr = await _storage.read(key: 'code_enseignant');

      if (codeStr != null) {
        await enseignantController.fetchGroupes(
          int.parse(codeStr),
          date: selectedDate.value,
        );

        setState(() {
          selectedGroupe = null;
          selectedMatiere = null;
          _presenceStatus.clear();
          _absencesCount.clear();
          _eliminationStatus.clear();
        });
      }
    }
  }

  Widget _buildGroupeDropdown() {
    return Obx(() {
      return _buildStyledDropdown<Enseignement>(
        hint: "Sélectionner un groupe",
        icon: Icons.groups_rounded,
        value: selectedGroupe,
        items: enseignantController.groupes,
        displayText: (g) => g.groupe?.nomGroupe ?? "N/A",
        onChanged: (val) {
          setState(() {
            selectedGroupe = val;
            selectedMatiere = null;
            _presenceStatus.clear();
            _absencesCount.clear();
            _eliminationStatus.clear();
          });
          if (val != null) {
            matiereController.fetchMatieres(val.codeGroupe);
            groupeController.fetchEtudiants(val.codeGroupe);
          }
        },
      );
    });
  }

  Widget _buildMatiereDropdown() {
    return Obx(() {
      return _buildStyledDropdown<Matiere>(
        hint: "Sélectionner une matière",
        icon: Icons.school_rounded,
        value: selectedMatiere,
        items: matiereController.matieres,
        displayText: (m) => m.nomMatiere ?? "N/A",
        onChanged: (val) {
          setState(() => selectedMatiere = val);
          if (val != null) {
            _loadAbsencesInfo();
          }
        },
      );
    });
  }

  Widget _buildSeanceDropdown() {
    return _buildStyledDropdown<int>(
      hint: "Sélectionner la séance",
      icon: Icons.access_time_rounded,
      value: selectedSeance,
      items: [1, 2, 3, 4],
      displayText: (s) => "Séance $s",
      onChanged: (v) => setState(() => selectedSeance = v!),
    );
  }

  Widget _buildStyledDropdown<T>({
    required String hint,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) displayText,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<T>(
              isExpanded: true,
              underline: const SizedBox(),
              hint: Text(
                hint,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
              ),
              value: items.contains(value) ? value : null,
              items: items
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  displayText(e),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtudiantsList() {
    return Obx(() {
      if (groupeController.etudiants.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  "Aucun étudiant trouvé",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final etu = groupeController.etudiants[index];
              final studentId = etu.etudiant?.id ?? etu.codeEtudiant;

              if (!_presenceStatus.containsKey(studentId)) {
                _presenceStatus[studentId] = true;
              }

              final absenceCount = _absencesCount[studentId] ?? 0;
              final isElimine = _eliminationStatus[studentId] ?? false;
              final isPresent = _presenceStatus[studentId]!;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isElimine
                        ? Colors.red.shade200
                        : const Color(0xFFE2E8F0),
                    width: isElimine ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    leading: Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isPresent
                                  ? [
                                const Color(0xFF10B981),
                                const Color(0xFF059669)
                              ]
                                  : [
                                const Color(0xFFEF4444),
                                const Color(0xFFDC2626)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: (isPresent
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444))
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              etu.etudiant?.name?[0].toUpperCase() ?? '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (isElimine)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      etu.etudiant?.name ?? "Étudiant",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    subtitle: selectedMatiere != null
                        ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: absenceCount > 0
                                  ? Colors.orange.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.event_busy_rounded,
                                  size: 14,
                                  color: absenceCount > 0
                                      ? Colors.orange.shade700
                                      : Colors.green.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$absenceCount absence${absenceCount > 1 ? 's' : ''}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: absenceCount > 0
                                        ? Colors.orange.shade700
                                        : Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isElimine) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.block_rounded,
                                    size: 14,
                                    color: Colors.red.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'ÉLIMINÉ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                        : null,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isPresent
                              ? [const Color(0xFF10B981), const Color(0xFF059669)]
                              : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: (isPresent
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444))
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          _setPresence(studentId, !isPresent);
                        },
                        child: Text(
                          isPresent ? "Présent" : "Absent",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    children: selectedMatiere != null
                        ? [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Actions d'élimination",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isElimine
                                        ? null
                                        : () async {
                                      final success =
                                      await absenceController
                                          .marquerElimine(
                                        codeEtudiant: studentId,
                                        codeMatiere: selectedMatiere!
                                            .codeMatiere!,
                                      );

                                      if (success) {
                                        Get.snackbar(
                                          'Succès',
                                          'Étudiant marqué comme éliminé',
                                          backgroundColor:
                                          Colors.orange,
                                          colorText: Colors.white,
                                          icon: const Icon(
                                              Icons.check_circle,
                                              color: Colors.white),
                                        );
                                        await _loadAbsencesInfo();
                                      }
                                    },
                                    icon: const Icon(Icons.cancel_rounded,
                                        size: 18),
                                    label: const Text('Éliminer'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isElimine
                                          ? Colors.grey.shade300
                                          : Colors.red,
                                      foregroundColor: isElimine
                                          ? Colors.grey.shade500
                                          : Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      elevation: isElimine ? 0 : 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: !isElimine
                                        ? null
                                        : () async {
                                      final success =
                                      await absenceController
                                          .marquerNonElimine(
                                        codeEtudiant: studentId,
                                        codeMatiere: selectedMatiere!
                                            .codeMatiere!,
                                      );

                                      if (success) {
                                        Get.snackbar(
                                          'Succès',
                                          'Élimination annulée',
                                          backgroundColor:
                                          Colors.green,
                                          colorText: Colors.white,
                                          icon: const Icon(
                                              Icons.check_circle,
                                              color: Colors.white),
                                        );
                                        await _loadAbsencesInfo();
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.check_circle_rounded,
                                        size: 18),
                                    label: const Text('Rétablir'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: !isElimine
                                          ? Colors.grey.shade300
                                          : Colors.green,
                                      foregroundColor: !isElimine
                                          ? Colors.grey.shade500
                                          : Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      elevation: !isElimine ? 0 : 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]
                        : [],
                  ),
                ),
              );
            },
            childCount: groupeController.etudiants.length,
          ),
        ),
      );
    });
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _saveAbsences,
        icon: const Icon(Icons.save_rounded, color: Colors.white, size: 24),
        label: const Text(
          "Enregistrer les absences",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _saveAbsences() async {
    if (selectedMatiere == null || selectedGroupe == null) {
      Get.snackbar(
        "Erreur",
        "Vous devez sélectionner un groupe et une matière",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    int successCount = 0;
    for (var etu in groupeController.etudiants) {
      final studentId = etu.etudiant?.id ?? etu.codeEtudiant;
      final statut = (_presenceStatus[studentId] ?? true) ? "Present" : "Absent";

      Absence absence = Absence(
        codeEtudiant: studentId,
        codeMatiere: selectedMatiere!.codeMatiere!,
        codeEnseignant: selectedGroupe!.codeEnseignant,
        seance: selectedSeance,
        statut: statut,
        justifie: false,
        dateAbsence: DateTime.now(),
        elimination: false,
      );

      bool success = await absenceController.marquerAbsence(absence);
      if (success) successCount++;
    }

    Get.snackbar(
      "✓ Succès",
      "$successCount/${groupeController.etudiants.length} absences enregistrées avec succès",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );

    await _loadAbsencesInfo();
  }
}