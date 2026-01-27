import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/Voeuxexamincontroller.dart';
import '../../models/creneau.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class VoeuxExamenView extends StatefulWidget {
  const VoeuxExamenView({super.key});

  @override
  State<VoeuxExamenView> createState() => _VoeuxExamenViewState();
}

class _VoeuxExamenViewState extends State<VoeuxExamenView> {
  final VoeuxExamenController controller = Get.put(VoeuxExamenController());

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
    controller.fetchCreneaux();
    controller.fetchChargeSurveillance();
    controller.fetchVoeux();
  }

  @override
  Widget build(BuildContext context) {
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
                "Vœux Examens",
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
                    // Date du jour
                    _buildTodayDateCard(),
                    const SizedBox(height: 12),

                    // Carte charge surveillance
                    _buildChargeSurveillanceCard(),
                    const SizedBox(height: 20),

                    // Titre section créneaux
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
                          "Créneaux disponibles",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Liste des créneaux
                    _buildCreneauxList(),
                    const SizedBox(height: 16),

                    // Indicateur de sélection
                    _buildSelectionIndicator(),
                    const SizedBox(height: 16),

                    // Bouton valider
                    _buildValidateButton(),
                    const SizedBox(height: 24),
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
    final today = DateFormat('EEEE, dd MMMM yyyy', 'fr_FR').format(DateTime.now());
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

  Widget _buildChargeSurveillanceCard() {
    return Obx(() {
      final seancesAutorisees = (controller.chargeSurveillance.value / 2).round();

      return Container(
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
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.security_rounded,
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
                        "Charge de surveillance",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${controller.chargeSurveillance.value} heures",
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Sélectionnez exactement $seancesAutorisees séances",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCreneauxList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
            ),
          ),
        );
      }

      if (controller.creneauxList.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(Icons.event_busy_rounded, size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                "Aucun créneau disponible",
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
        children: controller.creneauxList.map((Creneau creneau) {
          final voeux = controller.voeuxList.firstWhereOrNull(
                (v) => v.codeCreneau == creneau.codeCreneau,
          );

          return _buildCreneauCard(creneau, voeux);
        }).toList(),
      );
    });
  }

  Widget _buildCreneauCard(Creneau creneau, dynamic voeux) {
    return Obx(() {
      final isSelected = controller.selectedCreneaux.contains(creneau.codeCreneau) || voeux != null;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF1E3A8A).withOpacity(0.1)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: isSelected,
                  activeColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (value) async {
                    final seancesAutorisees = (controller.chargeSurveillance.value / 2).round();
                    if (value == true) {
                      if (!controller.selectedCreneaux.contains(creneau.codeCreneau)) {
                        if (controller.selectedCreneaux.length +
                            controller.voeuxList.length >= seancesAutorisees) {
                          Get.snackbar(
                            "Limite atteinte",
                            "Vous devez sélectionner exactement $seancesAutorisees séances",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange.shade500,
                            colorText: Colors.white,
                            borderRadius: 12,
                            margin: const EdgeInsets.all(16),
                            icon: const Icon(Icons.warning_rounded, color: Colors.white),
                          );
                          return;
                        }
                        controller.selectedCreneaux.add(creneau.codeCreneau);
                      }
                    } else {
                      controller.selectedCreneaux.remove(creneau.codeCreneau);
                      if (voeux != null) {
                        await controller.supprimerVoeu(creneau.codeCreneau);
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Informations du créneau
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          creneau.date,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${creneau.heureDebut} - ${creneau.heureFin}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bouton delete si vœu enregistré
              if (voeux != null)
                IconButton(
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
                  onPressed: () async {
                    await controller.supprimerVoeu(creneau.codeCreneau);
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSelectionIndicator() {
    return Obx(() {
      final seancesAutorisees = (controller.chargeSurveillance.value / 2).round();
      final totalSelected = controller.selectedCreneaux.length +
          controller.voeuxList.where((v) => !controller.selectedCreneaux.contains(v.codeCreneau)).length;
      final progress = seancesAutorisees > 0 ? (totalSelected / seancesAutorisees).toDouble() : 0.0;
      final isComplete = totalSelected == seancesAutorisees;

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
                          : Icons.pending_outlined,
                      color: isComplete
                          ? Colors.green.shade600
                          : const Color(0xFF1E3A8A),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Séances sélectionnées",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? Colors.green.shade600
                        : const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$totalSelected / $seancesAutorisees",
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

  Widget _buildValidateButton() {
    return Obx(() {
      final seancesAutorisees = (controller.chargeSurveillance.value / 2).round();
      final totalSelected = controller.selectedCreneaux.length +
          controller.voeuxList.where((v) => !controller.selectedCreneaux.contains(v.codeCreneau)).length;
      final canValidate = totalSelected == seancesAutorisees;

      return Material(
        elevation: canValidate ? 4 : 0,
        borderRadius: BorderRadius.circular(16),
        shadowColor: canValidate
            ? const Color(0xFF1E3A8A).withOpacity(0.4)
            : Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: canValidate ? const Color(0xFF1E3A8A) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: canValidate
                  ? () async {
                await controller.storeVoeux();
              }
                  : null,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: canValidate ? Colors.white : Colors.grey.shade500,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Valider mes vœux",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: canValidate ? Colors.white : Colors.grey.shade500,
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
}