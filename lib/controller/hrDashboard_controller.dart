import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/hrDashboardCardsRes.dart';
import '../models/hr_Dashboard_Response.dart';
import '../provider/labourDashboard_Provider.dart';
import '../utilities/baseutitiles.dart';

class HrDashboardController extends GetxController{
  RxBool isLoading = false.obs;

  final entryFromDate = TextEditingController();
  final entryToDate = TextEditingController();

  Rx<HrDashboardResponse?> dashboardResponse = Rx<HrDashboardResponse?>(null);
  Rxn<KpiCards> hrCategoryList = Rxn<KpiCards>();
  Rxn<StaffAttendance> hrStaffAttendanceList = Rxn<StaffAttendance>();


  RxList<Employee> hrCardsactiveEmployeeList = <Employee>[].obs;
  RxList<Employee> hrCardspresentEmployeeList = <Employee>[].obs;
  RxList<Employee> hrCardsonLeaveEmployeeList = <Employee>[].obs;
  RxList<Employee> hrCardsLateEmployeeList = <Employee>[].obs;
  RxList<Employee> hrCardsOnTimeEmployeeList = <Employee>[].obs;
  RxList<Employee> hrCardsAbsentEmployeeList = <Employee>[].obs;


  Future<void> getHrDashboardDetails() async {
    dashboardResponse.value = null;
    try {
      isLoading.value = true;
      final response = await LabourDashboardProvider.getHrDashboard(entryFromDate.text,entryToDate.text);
      if (response != null && response.success == true) {
        dashboardResponse.value = response;
        hrCategoryList.value = response.result?.kpiCards;
        hrStaffAttendanceList.value = response.result?.staffAttendance;

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

  Future getHrCardsList() async {
    hrCardsactiveEmployeeList.value.clear();
    final value = await LabourDashboardProvider.getHrDashboardCardsList(entryFromDate.text, entryToDate.text);
    if (value != null) {
      if(value.success == true){
          hrCardsactiveEmployeeList.assignAll(value.result?.activeEmployee ?? []);
          hrCardspresentEmployeeList.assignAll(value.result?.presentEmployee ?? []);
          hrCardsonLeaveEmployeeList.assignAll(value.result?.onLeaveEmployee ?? []);
          hrCardsLateEmployeeList.assignAll(value.result?.lateEmployee ?? []);
          hrCardsOnTimeEmployeeList.assignAll(value.result?.onTimeEmployee ?? []);
          hrCardsAbsentEmployeeList.assignAll(value.result?.absentEmployee ?? []);
      }
      else {
        BaseUtitiles.showToast(value.message ?? 'Something went wrong..');
      }
    }
    else{
      BaseUtitiles.showToast('Something went wrong..');
    }
  }

  List<Employee> getEmployeesForCard(String title) {
    switch (title) {
      case "TOTAL EMPLOYEES":
        return hrCardsactiveEmployeeList.toList();

      case "PRESENT TODAY":
        return hrCardspresentEmployeeList.toList();

      case "ON LEAVE TODAY":
        return hrCardsonLeaveEmployeeList.toList();

      case "LATE PUNCH IN":
        return hrCardsLateEmployeeList.toList();

      case "ON TIME PUNCH IN":
        return hrCardsOnTimeEmployeeList.toList();

      case "ON ABSENT":
        return hrCardsAbsentEmployeeList.toList();


      default:
        return [];
    }
  }

}