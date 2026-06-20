import '../constants/storage_constant.dart';
import '../controller/logincontroller.dart';
import '../login/animation_signinpage/welcomepage.dart';
import '../provider/authendication_provider.dart';
import '../provider/mrn_request_indent_provider.dart';
import '../utilities/baseutitiles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSetingController  extends GetxController {

  LoginController loginController = Get.put(LoginController());
  final repassword_controller = TextEditingController();
  final password_controller = TextEditingController();

  RxList checkApprovalLevelData = [].obs;


  changePasswordDetails(BuildContext context) async {
    Map<String, String> body = {
      "newPassword": password_controller.text.trim(),
      "confirmPassword": repassword_controller.text.trim(),
    };
    final value = await AuthendicationProvider.changePassword(body);
    if (value != null) {
      if (value.success == true) {
        BaseUtitiles.showToast(value.result);
        SessionStorage.removeUser();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
              (Route<dynamic> route) => false,
        );
      } else {
        BaseUtitiles.showToast(value?.result ?? "Password change failed");
      }
    }
    else {
      BaseUtitiles.showToast("Something Went Wrong..");
    }
  }

  Future getCheckApprovalLevel() async {
    checkApprovalLevelData.value = [];
    var response = await Mrn_Req_provider.getCheckApprovalLevel();
    if (response != null) {
      if (response["success"] == true) {
        if (response["result"]!.isNotEmpty) {
          checkApprovalLevelData.value = response["result"];
        } else {
          BaseUtitiles.showToast('No Data Found');
        }
      } else {
        BaseUtitiles.showToast(response["message"] ?? 'Something went wrong..');
      }
    } else {
      BaseUtitiles.showToast("Something went wrong..");
    }
  }
}