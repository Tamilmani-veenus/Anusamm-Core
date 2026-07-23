import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../commonpopup/labourAttendanceChart.dart';
import '../models/labourDashboard_model.dart';
import '../provider/labourDashboard_Provider.dart';
import '../utilities/baseutitiles.dart';

class LabourDashboardController extends GetxController{

  final labourEntryFromDate = TextEditingController();
  final labourEntryToDate = TextEditingController();
  RxString selectedDate = BaseUtitiles.selectDateFormat(DateTime.now()).obs;
  RxBool isLoading = false.obs;

  Rx<LabourDashboardResponse?> dashboardResponse = Rx<LabourDashboardResponse?>(null);
  RxList<LabourCategoryWise> labourCategoryList = <LabourCategoryWise>[].obs;
  RxList<TodayAttendance> todayAttendanceList = <TodayAttendance>[].obs;
  RxList<TodayAttendance> allTodayAttendanceList = <TodayAttendance>[].obs;

/// -------Category-wise
  final RxBool showAllLabours = false.obs;
  RxBool showAll = false.obs;
  RxList<String> projectList = <String>[].obs;

  Future<void> getLabourDashboardDetails() async {

    try {
      isLoading.value = true;
      final response = await LabourDashboardProvider.getLabourDashboard("2026-07-01", selectedDate.value);
      if (response != null && response.success == true) {
        dashboardResponse.value = response;
        labourCategoryList.assignAll(
            response.labourCategoryWise ?? []);
        todayAttendanceList.assignAll(
          response.todayAttendance ?? [],
        );
        allTodayAttendanceList.assignAll(response.todayAttendance ?? []);
        projectList.assignAll(
          allTodayAttendanceList
              .map((e) => e.projectName ?? "")
              .toSet()
              .toList(),
        );
        projectList.insert(0, "All");

      } else {
        dashboardResponse.value = null;
      }
    } catch (e) {
      print("Dashboard Error : $e");
      dashboardResponse.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  RxList<LabourCategoryChartData> labourList =
      <LabourCategoryChartData>[
        LabourCategoryChartData(
            category: "Mason",
            value: 220,
            color: Colors.blue,
          icon: Icons.co2_outlined
        ),

        LabourCategoryChartData(
            category: "Male Coolie (MC)",
            value: 180,
            color: Colors.deepPurple,
            icon: Icons.co2_outlined
        ),

        LabourCategoryChartData(
            category: "Female Coolie (FC)",
            value: 150,
            color: Colors.orange,
            icon: Icons.co2_outlined
        ),

        LabourCategoryChartData(
            category: "Helper",
            value: 130,
            color: Colors.teal,
            icon: Icons.co2_outlined
        ),

        LabourCategoryChartData(
            category: "Skilled Labour",
            value: 90,
            color: Colors.amber,
            icon: Icons.co2_outlined
        ),

        LabourCategoryChartData(
            category: "Electrician",
            value: 70,
            color: Colors.red,
            icon: Icons.co2_outlined
        ),

        LabourCategoryChartData(
            category: "Carpenter",
            value: 55,
            color: Colors.blueGrey,
            icon: Icons.co2_outlined
        ),

        LabourCategoryChartData(
            category: "Painter",
            value: 50,
            color: Colors.green,
            icon: Icons.co2_outlined
        ),
      ].obs;


  Color getCategoryColor(int index) {
    const colors = [
      Color(0xff4F46E5),
      Color(0xff06B6D4),
      Color(0xff10B981),
      Color(0xffF59E0B),
      Color(0xffEF4444),
      Color(0xff8B5CF6),
      Color(0xffEC4899),
      Color(0xff14B8A6),
      Color(0xff84CC16),
      Color(0xffF97316),
    ];

    return colors[index % colors.length];
  }

  IconData getCategoryIcon(String? name) {
    switch ((name ?? "").toLowerCase()) {
      case "mc":
        return Icons.engineering;

      case "fc":
        return Icons.person;

      case "mason":
        return Icons.construction;

      case "fitter":
        return Icons.build;

      case "fitter helper":
        return Icons.handyman;

      case "surveyor":
        return Icons.straighten;

      case "painter":
        return Icons.format_paint;

      case "plumber":
        return Icons.plumbing;

      case "tiles mason":
        return Icons.grid_view;

      default:
        return Icons.groups;
    }
  }
  double get totalLabour {
    return labourCategoryList.fold(
      0.0,
          (sum, item) => sum + (item.totalNos ?? 0),
    );
  }

  void filterAttendance(String query) {
    if (query.trim().isEmpty) {
      todayAttendanceList.assignAll(allTodayAttendanceList);
      return;
    }

    query = query.toLowerCase();

    todayAttendanceList.assignAll(
      allTodayAttendanceList.where((item) {
        return (item.labourAttendanceNo ?? "")
            .toLowerCase()
            .contains(query) ||
            (item.projectName ?? "")
                .toLowerCase()
                .contains(query) ||
            (item.siteName ?? "")
                .toLowerCase()
                .contains(query) ||
            (item.subContractorName ?? "")
                .toLowerCase()
                .contains(query) ||
            (item.employeeName ?? "")
                .toLowerCase()
                .contains(query) ||
            (item.totNos?.toString() ?? "")
                .contains(query) ||
            (item.totAmt?.toString() ?? "")
                .contains(query);
      }).toList(),
    );
  }

  void filterByProject(String project) {
    if (project == "All") {
      todayAttendanceList.assignAll(allTodayAttendanceList);
      return;
    }

    todayAttendanceList.assignAll(
      allTodayAttendanceList.where(
            (e) => e.projectName == project,
      ),
    );
  }
}