import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../provider/common_provider.dart';
import '../provider/reports_provider.dart';
import '../utilities/baseutitiles.dart';
import '../utilities/requestconstant.dart';
import 'logincontroller.dart';

class ReportsController extends GetxController{


  LoginController loginController=Get.put(LoginController());

  final projectname = TextEditingController();
  final sitename = TextEditingController();
  final Subheadername = TextEditingController();
  final suppliername = TextEditingController();
  final subcontractorname = TextEditingController();

  //---Projects--
  RxList getProjectdropDownvalue=[].obs;
  RxList projectDropdownName=[].obs;
  RxString selectedProjectName = "".obs;
  RxInt selectedProjectId = 0.obs;

  //---Sites--
  RxList getSiteDropdownvalue = [].obs;
  RxList siteDropdownName = [].obs;
  RxString selectedsitedropdownName = "".obs;
  RxInt selectedsiteId = 0.obs;

  //---Supplier--
  RxList supplierListDropdown = [].obs;
  RxList supplierDropdownName = [].obs;
  RxString selectedSupplierName = "".obs;
  RxInt selectedsuppliertId = 0.obs;


  //---Subcontractor--
  RxList getdropDownvalue=[].obs;
  RxList getSuncontDropdownvalue=[].obs;
  RxString selectedSubconttName = "".obs;
  RxInt selectedSubcontId = 0.obs;

  RxList getMaterialdropDownvalue = [].obs;
  RxInt materialDropdowntId = 0.obs;
  RxString materiaDropdownName = "".obs;
  RxBool validateProject = false.obs;

  //-------------Get Projects Reports---------------

  Future getReportProjectList({String? type}) async {
    getProjectdropDownvalue.value=[];
    final value = await CommonProvider.getproject();
    if (value != null ) {
    if(value.success == true) {
      getProjectdropDownvalue.value = value.result!;
    }
    else {
      BaseUtitiles.showToast(value.message ?? 'Something went wrong..');
    }
    }
    else{
      BaseUtitiles.showToast('Something went wrong..');
    }
  }

  Future getReportMaterialList() async {
    getMaterialdropDownvalue.value.clear();
    final value = await ReportsProvider.getReportMrnMaterial();
    if (value != null ) {
      if(value.success == true) {
        getMaterialdropDownvalue.value = value.result!;
      }
      else {
        BaseUtitiles.showToast(value.message ?? 'Something went wrong..');
      }
    }
    else{
      BaseUtitiles.showToast('Something went wrong..');
    }
  }

  //---------------Get Sites Reports-------------

  Future getSiteReportList(BuildContext context,int pId) async {
    getSiteDropdownvalue.value.clear();
    final value = await ReportsProvider.getsiteReports(pId);
    if (value != null ) {
      if(value.success == true)
        {
          getSiteDropdownvalue.value = value.result!;
          getSiteDropdownvalue.forEach((element) {
            return siteDropdownName.value.add(element.siteName);
          });
        }
      else {
        BaseUtitiles.showToast(value.message ?? 'Something went wrong..');
      }
    }
    else{
      BaseUtitiles.showToast('Something went wrong..');
    }
  }


  //------------Get Supplier Reports----------



  Future getSupplierReportList() async {
    supplierListDropdown.value.clear();
    final value = await ReportsProvider.getsupplierReports();
    if (value != null ) {
      if(value.success == true) {
        supplierListDropdown.value = value.response!;
      }else {
        BaseUtitiles.showToast(value.message ?? 'Something went wrong..');
      }
    }
    else{
      BaseUtitiles.showToast('Something went wrong..');
    }
  }


 //------------Get Supplier Reports----------

  Future getSubcontactorReportList() async {
    getdropDownvalue.value=[];
    final value = await ReportsProvider.getsubcontactorReports();
    if (value != null ) {
      if(value.success == true) {
        getdropDownvalue.value = value.result!;
      }else {
        BaseUtitiles.showToast(value.message ?? 'Something went wrong..');
      }
    }
    else{
      BaseUtitiles.showToast('Something went wrong..');
    }
  }


  ///--------ReqLeaveType Report-------
  RxList ReqLevList = [].obs;





}