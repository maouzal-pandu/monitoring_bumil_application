import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart';
import 'package:monitoring_bumil_application/app/data/models/schedule_anc.dart';
import 'package:monitoring_bumil_application/app/modules/bumil-history/views/bumil_history_view.dart';
import 'package:monitoring_bumil_application/app/modules/bumil-schedule/views/bumil_schedule_view.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/bumil_home_controller.dart';
import 'package:monitoring_bumil_application/app/core/widgets/settings_button.dart';

class BumilHomeView extends GetView<BumilHomeController> {
  const BumilHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: IndexedStack(
            index: controller.indexPage.value,
            children: [BumilHome(), BumilScheduleView(), BumilHistoryView()],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: BorderDirectional(
              top: BorderSide(color: const Color(0x33000000)),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onTap: (value) => controller.changeIndexPage(value),
                showSelectedLabels: false,
                showUnselectedLabels: false,

                items: [
                  _buildBottomNavItem(
                    activeIcon: Icons.home_rounded,
                    notActiveIcon: Icons.home_outlined,
                    index: 0,
                    name: "Dashboard",
                  ),
                  _buildBottomNavItem(
                    activeIcon: Icons.calendar_month_rounded,
                    notActiveIcon: Icons.calendar_month_outlined,
                    index: 1,
                    name: "ANC",
                  ),
                  _buildBottomNavItem(
                    activeIcon: Icons.history_rounded,
                    notActiveIcon: Icons.history_outlined,
                    index: 2,
                    name: "Riwayat",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData activeIcon,
    required IconData notActiveIcon,
    required int index,
    required String name,
  }) {
    final isActive = controller.indexPage.value == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isActive ? activeIcon : notActiveIcon,
          color: isActive ? AppColors.white : AppColors.subtext,
        ),
      ),
      label: name,
    );
  }
}

class BumilHome extends GetView<BumilHomeController> {
  const BumilHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [SettingsButton(), _buildTodayReminder()]),
      ),
    );
  }

  Widget _buildTodayReminder() {
    return Card(
      color: const Color(0xFF222831),
      child: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime(2000),
              lastDay: DateTime(2999),
              calendarFormat: CalendarFormat.week,
              locale: "id_ID",
              headerVisible: false,
              availableGestures: AvailableGestures.none,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white),
                weekendStyle: TextStyle(color: Colors.white),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: const Color(0xFF00ADB5),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                defaultTextStyle: TextStyle(color: Colors.grey),
                weekendTextStyle: TextStyle(color: Colors.grey),
              ),
            ),

            Divider(indent: 10, endIndent: 10),

            Obx(() {
              if (controller.schedule.isEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 24),
                    Image.asset(
                      'assets/images/error-in-calendar.png',
                      height: 160,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Belum ada jadwal di tanggal ini',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              }

              final today = DateTime.now();
              final jadwalHariIni = controller.schedule
                  .where((j) => isSameDay(j.tanggalJadwal, today))
                  .toList();
              final jadwalMingguIni =
                  controller.schedule
                      .where((j) => !isSameDay(j.tanggalJadwal, today))
                      .toList()
                    ..sort(
                      (a, b) => a.tanggalJadwal.compareTo(b.tanggalJadwal),
                    );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (jadwalHariIni.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Hari Ini',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    ...jadwalHariIni.map((j) => _buildJadwalTile(j)),
                  ],
                  if (jadwalMingguIni.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Minggu Ini',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    ...jadwalMingguIni.map((j) => _buildJadwalTile(j)),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalTile(dynamic jadwal) {
    final statusInfo = _statusInfo(jadwal.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: AppColors.surface0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: statusInfo.color, width: 1.2),
        ),
        leading: Container(
          width: 4,
          decoration: BoxDecoration(
            color: statusInfo.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          DateFormat("EEEE", "id_ID").format(jadwal.tanggalJadwal),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Text(
          DateFormat("dd MMMM yyyy", "id_ID").format(jadwal.tanggalJadwal),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusInfo.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            statusInfo.label,
            style: TextStyle(
              color: statusInfo.color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  ({Color color, String label}) _statusInfo(StatusJadwalAnc status) {
    switch (status) {
      case StatusJadwalAnc.terjadwal:
        return (color: AppColors.primary, label: 'Terjadwal');
      case StatusJadwalAnc.selesai:
        return (color: AppColors.success, label: 'Selesai');
      case StatusJadwalAnc.terlewat:
        return (color: AppColors.error, label: 'Terlewat');
      case StatusJadwalAnc.dibatalkan:
        return (color: AppColors.subtext, label: 'Dibatalkan');
    }
  }
}
