import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/SeanceControllers.dart';
import '../../controller/authcontroller.dart';
import '../../models/Seances.dart';


class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final AuthController authController = Get.find();
  final SeanceController seanceController = Get.put(SeanceController());

  final RxString selectedDate = ''.obs;
  final RxString selectedHeure = ''.obs;

  // ← SUPPRIMÉ : int selectedIndex = 0;

  final List<String> heuresDisponibles = [
    '08:00', '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00', '17:00'
  ];

  final Color primaryBlue = const Color(0xFF1E3A8A);
  final Color background = const Color(0xFFF2F3F7);

  @override
  void initState() {
    super.initState();
    seanceController.fetchConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          "Espace Admin",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryBlue,
        elevation: 3,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: _getPageContent(), // ← Appelle directement le contenu
      // ← SUPPRIMÉ : bottomNavigationBar
    );
  }

  Widget _getPageContent() {
    // ← SUPPRIMÉ : if (selectedIndex == 1) return SurveillerView();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // 🔵 FILTRE
          Card(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Obx(() => Column(
                children: [
                  Row(
                    children: [
                      // 📅 Date picker
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              selectedDate.value =
                              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                            decoration: BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month, color: primaryBlue),
                                const SizedBox(width: 8),
                                Text(
                                  selectedDate.value.isEmpty
                                      ? "Sélectionnez une date"
                                      : selectedDate.value,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 🕒 Heure
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedHeure.value.isEmpty ? null : selectedHeure.value,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          hint: const Text("Heure"),
                          items: heuresDisponibles.map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e)
                          )).toList(),
                          onChanged: (value) => selectedHeure.value = value!,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 🔍 Filtrer
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (selectedDate.value.isNotEmpty) {
                            seanceController.filterSeances(
                              selectedDate.value,
                              heure: selectedHeure.value.isEmpty ? null : selectedHeure.value,
                            );
                          }
                        },
                        child: const Text("Filtrer",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              )),
            ),
          ),
          const SizedBox(height: 18),
          // 🧾 DATA TABLE
          Expanded(
            child: Obx(() {
              if (seanceController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (seanceController.seances.isEmpty) {
                return const Center(
                  child: Text("Aucune séance trouvée",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(primaryBlue.withOpacity(0.12)),
                    dataRowHeight: 70,
                    columnSpacing: 28,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                    columns: const [
                      DataColumn(label: Text("Enseignant")),
                      DataColumn(label: Text("Groupe")),
                      DataColumn(label: Text("Salle")),
                      DataColumn(label: Text("Matière")),
                      DataColumn(label: Text("Nature")),
                      DataColumn(label: Text("Heure")),
                      DataColumn(label: Text("Présence")),
                    ],
                    rows: seanceController.seances.map((Seance seance) {
                      return DataRow(
                        cells: [
                          DataCell(Text(seance.enseignant?.name ?? "N/A")),
                          DataCell(Text(seance.groupe?.nomGroupe ?? "N/A")),
                          DataCell(Text(seance.salle?.nomSalle ?? "N/A")),
                          DataCell(Text(seance.matiere?.nomMatiere ?? "N/A")),
                          DataCell(Text(seance.nature)),
                          DataCell(Text(seance.heureSeance)),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      seance.etat ? "Présent" : "Absent",
                                      style: TextStyle(
                                        color: seance.etat ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Switch(
                                      value: seance.etat,
                                      onChanged: seance.isLockedWithDuration(seanceController.absenceModificationSeconds)
                                          ? null
                                          : (value) => seanceController.toggleEtat(seance),
                                      activeColor: Colors.green,
                                      inactiveThumbColor: Colors.red,
                                    ),
                                  ],
                                ),
                                if (seance.surveillant != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      'Par: ${seance.surveillant!.name}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                if (seance.isLockedWithDuration(seanceController.absenceModificationSeconds))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      'Modification verrouillée',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}