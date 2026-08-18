import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/bumil_schedule_controller.dart';

class BumilScheduleView extends GetView<BumilScheduleController> {
  const BumilScheduleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(child: Column(children: [_buildCalender()])),
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
                  onPressed: () async {
                    final result = await Get.toNamed(
                      '/bumil-add-reminder',
                      arguments: {'date': controller.selectedDay.value},
                    );

                    // if (result == true) {
                    //   controller.loadEventsFromStorage();
                    //   Get.find<BumilHomeController>().loadEventsToday();
                    // }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
