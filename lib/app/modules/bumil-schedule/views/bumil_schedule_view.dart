import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart';
import 'package:monitoring_bumil_application/app/data/models/schedule_anc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../controllers/bumil_schedule_controller.dart';

class BumilScheduleView extends GetView<BumilScheduleController> {
  const BumilScheduleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.refreshSchedule(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                _buildCalender(),

                // sort and filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showSortPopup(),
                      label: Text(controller.getSortName()),
                      icon: const Icon(Icons.sort_rounded),
                    ),
                    Obx(
                      () => TextButton.icon(
                        onPressed: () => _showFilterPopup(),
                        label: Text(controller.getFilterName()),
                        icon: const Icon(Icons.filter_alt_rounded),
                      ),
                    ),
                  ],
                ),

                _buildListReminder(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalender() {
    return Obx(() {
      // paksa GetX baca observable-nya duluan biar ke-subscribe
      final focused = controller.now.value;
      final selected = controller.selectedDay.value;

      return Card(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadiusGeometry.directional(
                topStart: Radius.circular(13),
                topEnd: Radius.circular(13),
              ),
              child: TableCalendar(
                firstDay: DateTime(2000),
                lastDay: DateTime(2999),
                focusedDay: focused,
                locale: "id_ID",
                selectedDayPredicate: (day) => isSameDay(selected, day),
                onDaySelected: (selectedDay, focusedDay) {
                  controller.selectedDay.value = selectedDay;
                  controller.now.value = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  tablePadding: const EdgeInsets.all(4),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.teal.withAlpha(102),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  titleCentered: true,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border(
                      bottom: BorderSide(
                        color: const Color.fromARGB(255, 211, 211, 211),
                        width: 1.25,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 🔽 Tombol Tambah Jadwal
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Color(0xFFFFFFFF)),
                  label: const Text(
                    "Tambah Jadwal",
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(16),
                      ),
                    ),
                  ),
                  onPressed: () => Get.toNamed("/bumil-add-anc-schedule"),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildListReminder() {
    return Obx(() {
      final eventList = controller.getFilteredSchedule;

      if (eventList.isEmpty) {
        return Column(
          children: [
            // const SizedBox(height: 24),
            Image.asset('assets/images/error-in-calendar.png', height: 120),
            // const SizedBox(height: 12),
            const Text(
              'Jadwal pemeriksaan kosong',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: eventList.length,
        itemBuilder: (context, index) {
          final item = eventList[index];

          return Card(
            child: Column(
              children: [
                ExpansionTile(
                  leading: _buildStatusChip(item.status),
                  title: Text(
                    DateFormat(
                      "EEEE, dd MMMM",
                      "ID_id",
                    ).format(item.tanggalJadwal).toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  shape: Border(),
                  trailing: item.status == StatusJadwalAnc.terjadwal
                      ? PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.grey,
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              Get.toNamed(
                                "/bumil-edit-jadwal",
                                arguments: {"jadwal_id": item.id},
                              );
                            } else if (value == 'batal') {
                              _showDeleteConfirmation();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.grey,
                                ),
                                title: Text('Ubah Jadwal'),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'batal',
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Batalkan'),
                              ),
                            ),
                          ],
                        )
                      : IconButton(
                          style: ButtonStyle(),
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        ),

                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(42, 8, 8, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.note, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.catatan ?? "-",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildStatusChip(StatusJadwalAnc status) {
    Color color;

    switch (status) {
      case StatusJadwalAnc.selesai:
        color = Colors.green;
        break;
      case StatusJadwalAnc.terjadwal:
        color = Colors.blue;
        break;
      case StatusJadwalAnc.dibatalkan || StatusJadwalAnc.terlewat:
        color = Colors.red;
        break;
    }

    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Icon(status.icon, color: Colors.white, size: 14),
      ),
    );
  }

  void _showScheduleOption(int scheduleId) {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.grey,
              ),
              title: const Text('Ubah Jadwal'),
              onTap: () {
                Get.toNamed(
                  "/bumil-edit-jadwal",
                  arguments: {"jadwal_id": scheduleId},
                );
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Batalkan'),
              onTap: () {
                _showDeleteConfirmation();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortPopup() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Sortir Jadwal", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),

              ListTile(
                dense: true,
                leading: const Icon(Icons.filter_alt_off, color: Colors.grey),
                title: const Text("Terbaru"),
                trailing: controller.activeSort.value == Sort.terbaru
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  controller.activeSort.value = Sort.terbaru;
                  Get.back();
                },
              ),

              Divider(color: Colors.grey.shade400, indent: 16, endIndent: 16),

              ListTile(
                dense: true,
                leading: const Icon(
                  Icons.monitor_heart_rounded,
                  color: Colors.grey,
                ),
                title: const Text("Terlama"),
                trailing: controller.activeSort.value == Sort.terlama
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  controller.activeSort.value = Sort.terlama;
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterPopup() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Filter Jadwal", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              ListTile(
                dense: true,
                leading: const Icon(Icons.today, color: Colors.grey),
                title: const Text("Semua"),
                trailing: controller.activeFilter.value == Filter.semua
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  controller.activeFilter.value = Filter.semua;
                  Get.back();
                },
              ),

              Divider(color: Colors.grey.shade400, indent: 16, endIndent: 16),

              ListTile(
                dense: true,
                leading: const Icon(Icons.today, color: Colors.grey),
                title: const Text("Per Hari"),
                trailing: controller.activeFilter.value == Filter.harian
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  controller.activeFilter.value = Filter.harian;
                  Get.back();
                },
              ),

              Divider(color: Colors.grey.shade400, indent: 16, endIndent: 16),

              ListTile(
                dense: true,
                leading: const Icon(Icons.date_range, color: Colors.grey),
                title: const Text("Per Minggu"),
                trailing: controller.activeFilter.value == Filter.mingguan
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  controller.activeFilter.value = Filter.mingguan;
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {}
}
