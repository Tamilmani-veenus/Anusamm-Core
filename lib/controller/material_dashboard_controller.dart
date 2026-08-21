import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../models/MaterialDash_matHead_model.dart';
import '../models/materialDash_projectwise_model.dart';
import '../provider/labourDashboard_Provider.dart';

class MaterialDashboardController extends GetxController {
  final entryFromDate = TextEditingController();
  final entryToDate = TextEditingController();
  final selectedTab = 0.obs;
  RxBool isLoading = false.obs;
  Rx<MaterialDashProjectWise?> projectWiseResponse = Rx<MaterialDashProjectWise?>(null);
  Rx<MaterialDashMatHead?> materialHeadResponse = Rx<MaterialDashMatHead?>(null);
  RxList<ProjectComparison> poVsBillTableList = <ProjectComparison>[].obs;
  RxList<ProjectComparison> allPoVsBillTableList = <ProjectComparison>[].obs;
  RxList<BillingCompletion> billingCompletionList = <BillingCompletion>[].obs;
  RxList<BillingCompletion> allBillingCompletionList = <BillingCompletion>[].obs;
  RxList<PoVsBillReg> poVsBillRegList = <PoVsBillReg>[].obs;
  RxList<PoVsBillReg> allPoVsBillRegList = <PoVsBillReg>[].obs;

  RxString selectedStatus = "All Status".obs;
  final List<String> poVsBillStatusList = [
    "All Status",
    "Over Billed",
    "Under Billed",
  ];

  String convertDateForApi(String date) {
    final parsedDate = DateFormat("dd-MM-yyyy").parse(date);
    return DateFormat("yyyy-MM-dd").format(parsedDate);
  }

  Future<void> getMatProjWiseDashboardDetails() async {
    try {
      isLoading.value = true;
      final fromDate = convertDateForApi(entryFromDate.text);
      final toDate = convertDateForApi(entryToDate.text);

      final response = await LabourDashboardProvider.getMatDashProjectWise(fromDate,toDate);
      if (response != null && response.success == true) {
        projectWiseResponse.value = response;
        poVsBillTableList.assignAll(response.projectComparison ?? []);
        allPoVsBillTableList.assignAll(response.projectComparison ?? []);
        billingCompletionList.assignAll(response.billingCompletion ?? []);
        allBillingCompletionList.assignAll(response.billingCompletion ?? []);
        poVsBillRegList.assignAll(response.poVsBillReg ?? []);
        allPoVsBillRegList.assignAll(response.poVsBillReg ?? []);
      }
        else {
        projectWiseResponse.value = null;
      }
    } catch (e) {
      print("Dashboard Error : $e");
      projectWiseResponse.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMatHeadDashboardDetails() async {
    try {
      isLoading.value = true;
      final fromDate = convertDateForApi(entryFromDate.text);
      final toDate = convertDateForApi(entryToDate.text);

      final response = await LabourDashboardProvider.getMatDashMaterialHeadAPI(fromDate,toDate);
      if (response != null && response.success == true) {
        materialHeadResponse.value = response;
      }
      else {
        materialHeadResponse.value = null;
      }
    } catch (e) {
      print("Dashboard Error : $e");
      materialHeadResponse.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  double getProgress(
      String? billAmount,
      String? poAmount,
      ) {
    if (billAmount == null || poAmount == null) {
      return 0.0;
    }

    double parseAmount(String value) {
      value = value.trim().toUpperCase().replaceAll(',', '');

      if (value.isEmpty) return 0.0;

      // Crore
      if (value.endsWith('CR')) {
        final number = double.tryParse(
          value.replaceAll('CR', '').trim(),
        ) ??
            0.0;

        return number * 10000000;
      }

      // Lakh
      if (value.endsWith('L')) {
        final number = double.tryParse(
          value.replaceAll('L', '').trim(),
        ) ??
            0.0;

        return number * 100000;
      }

      // No suffix = Rupees
      return double.tryParse(value) ?? 0.0;
    }

    final po = parseAmount(poAmount);
    final bill = parseAmount(billAmount);

    if (po <= 0) {
      return 0.0;
    }

    return (bill / po).clamp(0.0, 1.0);
  }

  double getPercentProgress(String? percentage) {
    if (percentage == null || percentage.isEmpty) {
      return 0.0;
    }

    final value = double.tryParse(
      percentage.replaceAll('%', '').trim(),
    );

    return ((value ?? 0) / 100).clamp(0.0, 1.0);
  }

  void filterPoVsBillValues(String query) {
    if (query.trim().isEmpty) {
      poVsBillTableList.assignAll(allPoVsBillTableList);
      return;
    }
    query = query.toLowerCase();

    poVsBillTableList.assignAll(
      allPoVsBillTableList.where((item) {
        return (item.projectName ?? "").toLowerCase().contains(query) ||
            (item.billAmountInLakhs?.toString() ?? "").contains(query) ||
            (item.poAmountInLakhs ?? "").toLowerCase().contains(query);
      }).toList(),
    );
  }

  void filterBillingValues(String query) {
    final search = query.trim().toLowerCase();

    if (search.isEmpty) {
      billingCompletionList.assignAll(allBillingCompletionList);
      return;
    }

    billingCompletionList.assignAll(
      allBillingCompletionList.where((item) {
        final projectName =
        (item.projectName ?? '').toLowerCase();

        final percentage =
        (item.billingCompletionPercentage ?? 0)
            .toString()
            .toLowerCase();

        return projectName.contains(search) ||
            percentage.contains(search);
      }).toList(),
    );
  }

  void filterProjects() {
    if (selectedStatus.value == "All Status") {
      poVsBillTableList.assignAll(allPoVsBillTableList);
    // }  else if (selectedStatus.value == "Under Billed") {
    //   poVsBillTableList.assignAll(
    //     allPoVsBillTableList.where(
    //           (e) => e.varianceLabel?.startsWith("Under") ?? false,
    //     ),
    //   );
    // } else if (selectedStatus.value == "Over Billed") {
    //   poVsBillTableList.assignAll(
    //     allPoVsBillTableList.where(
    //           (e) => e.varianceLabel?.startsWith("Over") ?? false,
    //     ),
    //   );
    }
  }

  void filterPOVsBillRegValues(String query) {
    final search = query.trim().toLowerCase();

    if (search.isEmpty) {
      poVsBillRegList.assignAll(allPoVsBillRegList);
      return;
    }

    poVsBillRegList.assignAll(
      allPoVsBillRegList.where((item) {
        return (item.projectName ?? "")
            .toLowerCase()
            .contains(search) ||
            (item.address ?? "")
                .toLowerCase()
                .contains(search) ||
            (item.totalPos?.toString() ?? "")
                .contains(search) ||
            (item.poAmountInLakhs?.toString() ?? "")
                .contains(search) ||
            (item.billAmountInLakhs?.toString() ?? "")
                .contains(search) ||
            (item.approvedAmountInLakhs?.toString() ?? "")
                .contains(search) ||
            (item.unbilledAmountInLakhs?.toString() ?? "")
                .contains(search) ||
            (item.overBillAmountInLakhs?.toString() ?? "")
                .contains(search) ||
            (item.billingPercentage?.toString() ?? "")
                .contains(search) ||
            (item.billingStatus ?? "")
                .toLowerCase()
                .contains(search);
      }).toList(),
    );
  }

  Color getProgressColor(double? percentage) {
    if (percentage! > 100) {
      return Color(0xFFEF4444);
    } else if (percentage == 100) {
      return Color(0xFF10B981);
    } else if (percentage < 1) {
      return Color(0xF74F5DEE);
    } else {
      return Color(0xFFF59E0B);
    }
  }

  Color getStatusColor(String? status) {
    final value = status ?? "";

    switch (value) {
      case "Partial":
        return Color(0xF7EEB647);

      case "Over-Billed":
        return const Color(0xFFEF4444);

      case "Completed":
        return Color(0xFF10B981);

      case "Not Started":
        return Colors.blueGrey;

      default:
        return Color(0xFFF59E0B);
    }
  }


}