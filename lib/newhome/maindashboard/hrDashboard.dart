import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:anusamm/controller/hrDashboard_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../commonpopup/hrDashboardViewAllScreen.dart';
import '../../controller/logincontroller.dart';
import '../../models/hrDashboardCardsRes.dart';
import '../../utilities/baseutitiles.dart';
import 'dashboard.dart';
import 'labourDashboard.dart';

class HrDashboard extends StatefulWidget {
  const HrDashboard({super.key});

  @override
  State<HrDashboard> createState() => _HrDashboardState();
}

class _HrDashboardState extends State<HrDashboard> {

  HrDashboardController hrDashboardController = Get.put(HrDashboardController());
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime currentDate = DateTime.now();
    hrDashboardController.entryFromDate.text =
        currentDate.toString().substring(0, 10);
    hrDashboardController.entryToDate.text =
        currentDate.toString().substring(0, 10);
    hrDashboardController.getHrDashboardDetails();
    hrDashboardController.getHrCardsList();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Dashboard_screen(),
          ),
        );
        return false;
      },
      child: SafeArea(
        top: false,
          child: Scaffold(
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      height: 125,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Header content
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 10,
                              right: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "HR Analytics & Operations",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${BaseUtitiles().getGreeting()}, ${loginController.UserName()}!  👋",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Date filter - Bottom Right
                          Positioned(
                            bottom: 8,
                            right: 10,
                            child: SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _compactDateField(
                                    title: "From",
                                    controller: hrDashboardController.entryFromDate,
                                    onTap: () async {
                                      final date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2010),
                                          lastDate: DateTime.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: Theme.of(context).primaryColor,
                                                  onPrimary: Colors.white,
                                                  onSurface: Colors.black, // body text color
                                                ),
                                                textButtonTheme: TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    primary: Colors
                                                        .black, // button text color
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          });
                                      if (date != null) {
                                        setState(() {
                                          hrDashboardController.entryFromDate.text =
                                              date.toString().substring(0, 10);
                                        });

                                        await hrDashboardController.getHrDashboardDetails();
                                      }
                                    },
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                      color: Color(0xff667085),
                                    ),
                                  ),

                                  _compactDateField(
                                    title: "To",
                                    controller: hrDashboardController.entryToDate,
                                    onTap: () async {
                                      final date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2010),
                                          lastDate: DateTime.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: Theme.of(context).primaryColor,
                                                  onPrimary: Colors.white,
                                                  onSurface: Colors.black, // body text color
                                                ),
                                                textButtonTheme: TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    primary: Colors.black, // button text color
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          });
                                      if (date != null) {
                                        setState(() {
                                          hrDashboardController.entryToDate.text =
                                              date.toString().substring(0, 10);
                                        });
                                        await hrDashboardController.getHrDashboardDetails();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(()=>
                      GridView.builder(
                        padding: EdgeInsets.only(top: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: hrCards.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 2,
                          mainAxisExtent: 105,
                          // childAspectRatio: 1.45,
                        ),
                        itemBuilder: (_, index) {
                          final item = hrCards[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              _showEmployeeListDialog(
                                context,
                                title: item.title,
                                employees: hrDashboardController.getEmployeesForCard(item.title),
                                icon: item.icon,
                                color: item.color,
                              );
                            },
                            child: LabourCard(
                              item: item,
                              index: index,
                            ),
                          );
                          },
                      ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(18),
                  //     border: Border.all(
                  //       color: const Color(0xffEAECF0),
                  //       width: 1,
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(.06),
                  //         blurRadius: 12,
                  //         offset: const Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     children: [
                  //
                  //       /// Header
                  //       Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Expanded(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   "Staff Attendance (Today)",
                  //                   style: TextStyle(
                  //                     fontSize: 14,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Color(0xff16172B),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 4),
                  //                 Text(
                  //                   "Workforce attendance breakdown",
                  //                   style: TextStyle(
                  //                     fontSize: 11.5,
                  //                     color: Colors.grey,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           Container(
                  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  //             decoration: BoxDecoration(
                  //               color: const Color(0xff22C55E),
                  //               borderRadius: BorderRadius.circular(20),
                  //             ),
                  //             child: const Text(
                  //               "Live",
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 10.5,
                  //                 fontWeight: FontWeight.bold,
                  //                 letterSpacing: 0.3,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //
                  //       const SizedBox(height: 14),
                  //       const Divider(color: Color(0xffEEF0F4), thickness: 1),
                  //       const SizedBox(height: 12),
                  //
                  //       /// Donut
                  //       Obx(() {
                  //         final total = hrDashboardController.hrStaffAttendanceList.pre.value;
                  //         final present = hrDashboardController.hrStaffAttendanceList.present.value;
                  //         final absent = hrDashboardController.hrStaffAttendanceList.absent.value;
                  //         final onLeave = hrDashboardController.hrStaffAttendanceList.onLeave.value;
                  //
                  //         return SizedBox(
                  //           height: 210,
                  //           child: SfCircularChart(
                  //             annotations: [
                  //               CircularChartAnnotation(
                  //                 widget: Column(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     const Text(
                  //                       "TOTAL",
                  //                       style: TextStyle(
                  //                         fontSize: 10,
                  //                         fontWeight: FontWeight.bold,
                  //                         letterSpacing: 0.8,
                  //                         color: Colors.grey,
                  //                       ),
                  //                     ),
                  //                     Text(
                  //                       "$total",
                  //                       style: const TextStyle(
                  //                         fontSize: 30,
                  //                         fontWeight: FontWeight.w800,
                  //                         color: Color(0xff16172B),
                  //                       ),
                  //                     ),
                  //                     const Text(
                  //                       "STAFF",
                  //                       style: TextStyle(
                  //                         fontSize: 10,
                  //                         fontWeight: FontWeight.bold,
                  //                         letterSpacing: 0.8,
                  //                         color: Colors.grey,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //             series: <DoughnutSeries<_AttendanceSlice, String>>[
                  //               DoughnutSeries<_AttendanceSlice, String>(
                  //                 dataSource: [
                  //                   _AttendanceSlice("Present", present, const Color(0xff22C55E)),
                  //                   _AttendanceSlice("Absent", absent, const Color(0xffEF4444)),
                  //                   _AttendanceSlice("On Leave", onLeave, const Color(0xffF59E0B)),
                  //                 ].where((e) => e.value > 0).toList(),
                  //                 xValueMapper: (e, _) => e.label,
                  //                 yValueMapper: (e, _) => e.value,
                  //                 pointColorMapper: (e, _) => e.color,
                  //                 innerRadius: "75%",
                  //                 radius: "95%",
                  //                 strokeWidth: 3,
                  //                 strokeColor: Colors.white,
                  //                 cornerStyle: CornerStyle.bothCurve,
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       }),
                  //
                  //       const SizedBox(height: 18),
                  //
                  //       /// Rows
                  //       Obx(() => Column(
                  //         children: [
                  //           _attendanceRow(
                  //             icon: Icons.people_alt_rounded,
                  //             label: "PRESENT",
                  //             value: attendanceController.present.value,
                  //             percent: attendanceController.presentPercent,
                  //             color: const Color(0xff22C55E),
                  //             bgColor: const Color(0xffDCF5E4),
                  //           ),
                  //           const SizedBox(height: 10),
                  //           _attendanceRow(
                  //             icon: Icons.person_off_rounded,
                  //             label: "ABSENT",
                  //             value: attendanceController.absent.value,
                  //             percent: attendanceController.absentPercent,
                  //             color: const Color(0xffEF4444),
                  //             bgColor: const Color(0xffFBDEDE),
                  //           ),
                  //           const SizedBox(height: 10),
                  //           _attendanceRow(
                  //             icon: Icons.beach_access_rounded,
                  //             label: "ON LEAVE",
                  //             value: attendanceController.onLeave.value,
                  //             percent: attendanceController.onLeavePercent,
                  //             color: const Color(0xffF59E0B),
                  //             bgColor: const Color(0xffFDECD1),
                  //           ),
                  //         ],
                  //       )),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _compactDateField({
    required String title,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 130,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xffF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xffE4E7EC),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Color(0xff667085),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff667085),
                    ),
                  ),
                  Text(
                    controller.text.isEmpty
                        ? "Select date"
                        : controller.text,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff101828),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<LabourCardModel> get hrCards {
    final data = hrDashboardController.hrCategoryList.value;
    return [
      LabourCardModel(
        title: "TOTAL EMPLOYEES",
        value: "${data?.activeEmployee ?? 0}",
        subtitle: "Active Employees",
        icon: Icons.groups_outlined,
        color: Color(0xFF2563EB),
      ),

      LabourCardModel(
        title: "PRESENT TODAY",
        value: "${data?.totalPresentEmployee ?? 0}",
        subtitle:"${data?.presentPercentage ?? 0.0} of Total",
        icon: Icons.verified_user_sharp,
        color: Color(0xFF0F9D8A),
      ),

      LabourCardModel(
        title: "ON LEAVE TODAY",
        value: "${data?.onLeaveEmployee ?? 0}",
        subtitle: "${data?.onLeavePercentage ?? 0.0} of Total",
        icon: Icons.calendar_today_outlined,
        color: Color(0xFFD97706),
      ),

      LabourCardModel(
        title: "LATE PUNCH IN",
        value: "${data?.latePunchinEmployee ?? 0}",
        subtitle: "${data?.latePunchInPercentage ?? 0} of Total",
        icon: Icons.access_time,
        color: Color(0xFFE11D48),
      ),

      LabourCardModel(
        title: "ON TIME PUNCH IN",
        value: "${data?.onTimePunchinEmployee ?? 0}",
        subtitle: "${data?.onTimePunchinPercentage ?? 0} of Total",
        icon: Icons.login_rounded,
        color: Color(0xFF0F9D8A),

      ),

      LabourCardModel(
        title: "ON ABSENT",
        value: "${data?.absentEmployee ?? 0}",
        subtitle: "${data?.absentPercentage ?? 0} of Total",
        icon: Icons.warning_amber_rounded,
        color: Color(0xFFD97706),
      ),
    ];
  }


  void _showEmployeeListDialog(
      BuildContext context, {
        required String title,
        required List<Employee> employees,
        required IconData icon,
        required Color color,
      }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: SizedBox(
            width: 650,
            height: 450,
            child: EmployeeListDialog(
              title: title,
              employees: employees,
              icon: icon,
              color: color,
            ),
          ),
        );
      },
    );
  }
}





