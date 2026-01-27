import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../controller/Enseignantcontroller.dart';
import '../../controller/veeuxenseignantcontroller.dart';

class VoeuxEnseignementView extends StatelessWidget {
  VoeuxEnseignementView({Key? key}) : super(key: key);

  final VoeuxEnseignementController controller =
  Get.put(VoeuxEnseignementController());

  final EnseignantControllerFlutter enseignantController =
  Get.put(EnseignantControllerFlutter());

  final List<String> creneaux = ["08-10", "10-12", "12-14", "14-16", "16-18"];

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null);

    enseignantController.fetchCharge();
    controller.fetchVoeux();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: CustomScrollView(
        slivers: [
          // AppBar moderne avec dégradé
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: const Text(
                "Vœux Enseignement",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E3A8A),
                      Color(0xFF1E40AF),
                      Color(0xFF3B82F6),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date du jour avec icône
                    _buildTodayDateCard(),
                    const SizedBox(height: 12),

                    // Carte charge enseignant
                    _buildChargeEnseignantCard(),
                    const SizedBox(height: 20),

                    // Titre section planning
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Planifiez vos créneaux",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tableau de saisie horizontal
                    SizedBox(
                      height: 380,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Obx(() => Row(
                          children: controller.jours.map((jour) {
                            bool isWeekend =
                            (jour == "Samedi" || jour == "Dimanche");

                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 140,
                              child: Card(
                                elevation: 2,
                                shadowColor: Colors.black12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isWeekend
                                        ? Colors.grey.shade200
                                        : Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      // En-tête du jour
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        decoration: BoxDecoration(
                                          color: isWeekend
                                              ? Colors.red.shade400
                                              : const Color(0xFF1E3A8A),
                                          borderRadius:
                                          const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              jour.substring(0, 3),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8,
                                                  vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    8),
                                              ),
                                              child: Text(
                                                jour,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Créneaux horaires
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: List.generate(
                                                creneaux.length, (index) {
                                              final selected = controller
                                                  .selections[jour]
                                                  ?.contains(index) ??
                                                  false;

                                              return InkWell(
                                                onTap: () {
                                                  if (selected) {
                                                    controller
                                                        .selections[jour]!
                                                        .remove(index);
                                                  } else {
                                                    controller
                                                        .selections[jour]!
                                                        .add(index);
                                                  }
                                                },
                                                borderRadius:
                                                BorderRadius.circular(
                                                    12),
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    color: selected
                                                        ? Colors.blueAccent
                                                        : Colors
                                                        .grey.shade200,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                    boxShadow: selected
                                                        ? [
                                                      BoxShadow(
                                                        color: Colors
                                                            .blueAccent
                                                            .withOpacity(
                                                            0.4),
                                                        blurRadius: 8,
                                                        offset:
                                                        const Offset(
                                                            0, 4),
                                                      ),
                                                    ]
                                                        : null,
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .access_time_rounded,
                                                          size: 14,
                                                          color: selected
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        Text(
                                                          creneaux[index],
                                                          style: TextStyle(
                                                            color: selected
                                                                ? Colors
                                                                .white
                                                                : Colors
                                                                .black,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Indicateur d'heures sélectionnées
                    _buildHoursIndicator(),
                    const SizedBox(height: 16),

                    // Bouton enregistrer
                    _buildSaveButton(),
                    const SizedBox(height: 24),

                    // Vœux enregistrés
                    _buildVoeuxEnregistres(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayDateCard() {
    final today =
    DateFormat('EEEE, dd MMMM yyyy', 'fr_FR').format(DateTime.now());
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: Color(0xFF1E3A8A),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Aujourd'hui",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  today,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeEnseignantCard() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.schedule_rounded,
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
                  "Charge semaine prochaine",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${enseignantController.chargeEnseignement.value} heures",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildHoursIndicator() {
    return Obx(() {
      int totalHeures = controller.totalHeuresSelectionnees * 2;
      int chargeRequise = enseignantController.chargeEnseignement.value;
      double progress = chargeRequise > 0 ? totalHeures / chargeRequise : 0;
      bool isComplete = totalHeures == chargeRequise;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isComplete ? Colors.green.shade200 : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isComplete
                          ? Icons.check_circle_rounded
                          : Icons.timer_outlined,
                      color: isComplete
                          ? Colors.green.shade600
                          : const Color(0xFF1E3A8A),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Heures sélectionnées",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? Colors.green.shade600
                        : const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$totalHeures / $chargeRequise h",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isComplete ? Colors.green.shade500 : const Color(0xFF1E3A8A),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSaveButton() {
    return Obx(() {
      int totalHeures = controller.totalHeuresSelectionnees * 2;
      bool canSave =
          totalHeures == enseignantController.chargeEnseignement.value;

      return Material(
        elevation: canSave ? 4 : 0,
        borderRadius: BorderRadius.circular(16),
        shadowColor: canSave
            ? const Color(0xFF1E3A8A).withOpacity(0.4)
            : Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: canSave ? const Color(0xFF1E3A8A) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: canSave
                  ? () async {
                List<Map<String, int>> voeux = [];

                controller.selections.forEach((jour, set) {
                  int codeJour = controller.jours.indexOf(jour) + 1;
                  for (var index in set) {
                    voeux.add(
                        {'code_jour': codeJour, 'code_seance': index + 1});
                  }
                });

                for (var v in voeux) {
                  await controller.addVoeux(
                      v['code_jour']!, v['code_seance']!);
                }

                await enseignantController.fetchCharge();
                await controller.fetchVoeux();

                controller.resetSelections();

                Get.snackbar(
                  "Succès",
                  "Vœux enregistrés avec succès",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.shade500,
                  colorText: Colors.white,
                  borderRadius: 12,
                  margin: const EdgeInsets.all(16),
                  icon: const Icon(Icons.check_circle,
                      color: Colors.white),
                );
              }
                  : null,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.save_rounded,
                      color: canSave ? Colors.white : Colors.grey.shade500,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Enregistrer les vœux",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: canSave ? Colors.white : Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildVoeuxEnregistres() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
            ),
          ),
        );
      }

      if (controller.voeuxList.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(Icons.event_busy_rounded,
                  size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                "Aucun vœu enregistré",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Vœux enregistrés",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${controller.voeuxList.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...controller.voeuxList.map((v) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event_available_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              title: Text(
                jourFromCode(v.codeJour),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1F2937),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      seanceFromCode(v.codeSeance),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade600,
                    size: 20,
                  ),
                ),
                onPressed: () => controller.supprimerVoeu(v.id),
              ),
            ),
          )),
        ],
      );
    });
  }

  String jourFromCode(int code) {
    const jours = [
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi",
      "Dimanche"
    ];
    return (code >= 1 && code <= jours.length) ? jours[code - 1] : "Inconnu";
  }

  String seanceFromCode(int code) {
    const seances = ["08-10", "10-12", "12-14", "14-16", "16-18"];
    return (code >= 1 && code <= seances.length)
        ? seances[code - 1]
        : "Inconnue";
  }
}