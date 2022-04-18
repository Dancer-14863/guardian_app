import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_app/components/analytics_screen/analytics_card.dart';
import 'package:guardian_app/components/analytics_screen/distance_log_data_table.dart';
import 'package:guardian_app/components/analytics_screen/pressure_plate_log_data_table.dart';
import 'package:guardian_app/components/analytics_screen/pressure_plate_pie_chart.dart';
import 'package:guardian_app/components/analytics_screen/water_gun_pie_chart.dart';
import 'package:guardian_app/components/common/custom_app_bar.dart';
import 'package:guardian_app/components/common/custom_drawer.dart';
import 'package:guardian_app/models/models.dart';
import 'package:guardian_app/pages/home_screen/home_screen.dart';
import 'package:guardian_app/services/guardian_service.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _numberOfAlarms = 0;
  String _latestAlarmTime = '-';
  List<DistanceLog> _distanceLogs = [];
  List<PressurePlateLog> _pressurePlateLogs = [];
  List<WaterGunLog> _waterGunLogs = [];
  late GuardianService _guardianService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await _getAnalyticsData();
    });
  }

  Future<void> _getAnalyticsData() async {
    _guardianService = ref.watch(guardianService);
    int numberOfAlarms = await _guardianService.getNumberOfAlarmLogs();
    String latestAlarmTime = await _guardianService.getLatestAlarmDateTime();
    List<DistanceLog> distanceLogs = await _guardianService.getDistanceLogs();
    List<PressurePlateLog> pressurePlateLogs =
        await _guardianService.getPressurePlateLogs();
    List<WaterGunLog> waterGunLogs = await _guardianService.getWaterGunLogs();

    setState(() {
      _numberOfAlarms = numberOfAlarms;
      _latestAlarmTime = latestAlarmTime;
      _distanceLogs = distanceLogs;
      _pressurePlateLogs = pressurePlateLogs;
      _waterGunLogs = waterGunLogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return Scaffold(
      backgroundColor: _themeOptions.backgroundColor,
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentRoute: '/analytics'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 6.sp),
        child: ListView(
          children: [
            Text(
              'Analytics',
              style: TextStyle(
                color: _themeOptions.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: _themeOptions.textSize1,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: AnalyticsCard(
                    title: 'Number of times Alarm was Triggered',
                    value: _numberOfAlarms.toString(),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: AnalyticsCard(
                    title: 'Last time Alarm was Triggered',
                    value: _latestAlarmTime,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: DistanceLogDataTable(data: _distanceLogs),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: PressurePlateLogDataTable(data: _pressurePlateLogs),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            PressurePlatePieChart(data: _pressurePlateLogs),
            SizedBox(height: 2.h),
            WaterGunPieChart(data: _waterGunLogs),
          ],
        ),
      ),
    );
  }
}
