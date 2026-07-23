// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:bottom_bar/bottom_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:anusamm/controller/labourDashboard_controller.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../app_theme/app_colors.dart';
// import '../../commonpopup/labourAttendanceChart.dart';
// import '../../commonpopup/labourAttendanceTable.dart';
// import '../../constants/storage_constant.dart';
// import '../../constants/ui_constant/icons_const.dart';
// import '../../controller/logincontroller.dart';
// import '../../controller/menu_controller.dart';
// import '../../home/account_settings/account_setting.dart';
// import '../../models/labourDashboard_model.dart';
// import '../../utilities/baseutitiles.dart';
// import '../../utilities/requestconstant.dart';
// import '../menus/main_menuslist.dart';
// import '../pendinglist.dart';
// import '../reports/reports.dart';
// import 'dashboard.dart';
//
// class LabourDashboard extends StatefulWidget {
//   const LabourDashboard({super.key});
//
//   @override
//   State<LabourDashboard> createState() => _LabourDashboardState();
// }
//
// class _LabourDashboardState extends State<LabourDashboard> {
//   final _pageController = PageController();
//   Menu_Controller menuController = Get.put(Menu_Controller());
//   LoginController loginController = Get.put(LoginController());
//   int _currentPage = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Setmybackground,
//         bottomNavigationBar: BottomBar(
//           selectedIndex: _currentPage,
//           onTap: (int index) {
//             menuController.formMenuId.value = 0;
//             _pageController.jumpToPage(index);
//             setState(() => _currentPage = index);
//           },
//           items: const <BottomBarItem>[
//             BottomBarItem(
//               icon: Icon(Icons.home),
//               title: Text('Home'),
//               activeColor: Color(0xFF4B3FFF),
//             ),
//             BottomBarItem(
//               icon: Icon(Icons.menu_open),
//               title: Text('Menus'),
//               activeColor: Color(0xFF4B3FFF),
//             ),
//             BottomBarItem(
//               icon: Icon(Icons.list_alt),
//               title: Text('List'),
//               activeColor: Color(0xFF4B3FFF),
//             ),
//             BottomBarItem(
//               icon: Icon(Icons.file_copy_outlined),
//               title: Text('Reports'),
//               activeColor: Color(0xFF4B3FFF),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: ScrollConfiguration(
//             behavior: MyBehavior(),
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),
//                 Row(
//                   children: [
//                     const SizedBox(width: 15),
//                     const Expanded(
//                         flex: 3,
//                         child: Text(
//                           "Labour Dashboard",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         )),
//                     Container(
//                       child: InkWell(
//                         child: Container(
//                             margin:
//                             const EdgeInsets.only(left: 20, right: 10),
//                             child: Icon(Icons.settings,
//                                 color: Theme.of(context).primaryColor)),
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (BuildContext context) =>
//                                   const AccountSettings()));
//                         },
//                       ),
//                     ),
//                     Container(
//                       child: InkWell(
//                         child: Container(
//                             margin:
//                             const EdgeInsets.only(left: 20, right: 10),
//                             child: Icon(Icons.logout,
//                                 color: Theme.of(context).primaryColor)),
//                         onTap: () {
//                           logoutPopup(context);
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 15)
//                   ],
//                 ),
//                 const Divider(),
//                 SizedBox(
//                   height: BaseUtitiles.getheightofPercentage(context, 84),
//                   child: PageView(
//                     controller: _pageController,
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         child: const HomeScreen(),
//                       ),
//                       Container(
//                         alignment: Alignment.center,
//                         child: const MainManusList(),
//                       ),
//                       Container(
//                         alignment: Alignment.center,
//                         child: const PendingList_Screen(),
//                       ),
//                       Container(
//                         alignment: Alignment.center,
//                         child: const Reports_screen(),
//                       ),
//                     ],
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentPage = index;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Future logoutPopup(BuildContext context) async {
//     return await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Alert!'),
//         content: const Text('Are you sure to Logout?'),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(left: 20, right: 20),
//             child: IntrinsicHeight(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                         onPressed: () {
//                           return Navigator.of(context).pop();
//                         },
//                         child: const Text("Cancel",
//                             style: TextStyle(
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: RequestConstant.Lable_Font_SIZE))),
//                   ),
//                   VerticalDivider(
//                     color: Colors.grey.shade400,
//                     width: 5,
//                     thickness: 2,
//                     indent: 15,
//                     endIndent: 15, //Spacing at the bottom of divider.
//                   ),
//                   Expanded(
//                     child: TextButton(
//                         onPressed: () async {
//                           await loginController.usertoken_DeleteApi(context);
//                           await loginController.deleteLoginDetails();
//                           await SessionStorage.removeUser();
//                         },
//                         child: const Text("Logout",
//                             style: TextStyle(
//                                 color: Colors.red,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: RequestConstant.Lable_Font_SIZE))),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   LabourDashboardController labourDashboardController = Get.put(LabourDashboardController());
//   late TooltipBehavior _tooltipBehavior;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     DateTime currentDate = DateTime.now();
//     DateTime oneWeekBefore = currentDate.subtract(const Duration(days: 7));
//     labourDashboardController.labourEntryFromDate.text = oneWeekBefore.toString().substring(0, 10);
//     labourDashboardController.labourEntryToDate.text = currentDate.toString().substring(0, 10);
//     labourDashboardController.getLabourDashboardDetails();
//
//     _tooltipBehavior = TooltipBehavior(
//       enable: true,
//       color: Colors.black87,
//       textStyle: const TextStyle(
//         color: Colors.white,
//         fontSize: 12,
//         fontWeight: FontWeight.w500,
//       ),
//       canShowMarker: true,
//       header: '',
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Date -----------
//               Container(
//                 margin: EdgeInsets.only(top: 2),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       width: BaseUtitiles.getWidthtofPercentage(context, 45),
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(color: Colors.white70, width: 1),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 3),
//                           child: TextFormField(
//                             readOnly: true,
//                             controller:
//                             labourDashboardController.labourEntryFromDate,
//                             cursorColor: Colors.black,
//                             style: TextStyle(color: Colors.black),
//                             decoration:  InputDecoration(
//                               contentPadding: EdgeInsets.zero,
//                               border: InputBorder.none,
//                               labelText: "From Date",
//                               labelStyle: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: RequestConstant.Lable_Font_SIZE),
//                               prefixIconConstraints:
//                               BoxConstraints(minWidth: 0, minHeight: 0),
//                               prefixIcon: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 8),
//                                 child: Icon(Icons.calendar_today_outlined,size:18,color: Theme.of(context).primaryColor,),
//                               ),
//                               suffixIcon: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 8),
//                                 child: Icon(Icons.keyboard_arrow_down,size:18,color: Theme.of(context).primaryColor,),
//                               ),
//                             ),
//                             onTap: () async {
//                               var Frdate = await showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(2010),
//                                   lastDate: DateTime.now(),
//                                   builder: (context, child) {
//                                     return Theme(
//                                       data: Theme.of(context).copyWith(
//                                         colorScheme: ColorScheme.light(
//                                           primary:
//                                           Theme.of(context).primaryColor,
//                                           onPrimary: Colors.white,
//                                           onSurface:
//                                           Colors.black, // body text color
//                                         ),
//                                         textButtonTheme: TextButtonThemeData(
//                                           style: TextButton.styleFrom(
//                                             primary: Colors
//                                                 .black, // button text color
//                                           ),
//                                         ),
//                                       ),
//                                       child: child!,
//                                     );
//                                   });
//                               labourDashboardController.labourEntryFromDate.text =
//                                   Frdate.toString().substring(0, 10);
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Select Date';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: BaseUtitiles.getWidthtofPercentage(context, 45),
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(color: Colors.white70, width: 1),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 3),
//                           child: TextFormField(
//                             readOnly: true,
//                             controller:
//                             labourDashboardController.labourEntryToDate,
//                             cursorColor: Colors.black,
//                             style: TextStyle(color: Colors.black),
//                             decoration: InputDecoration(
//                               contentPadding: EdgeInsets.zero,
//                               border: InputBorder.none,
//                               labelText: "To Date",
//                               labelStyle: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: RequestConstant.Lable_Font_SIZE),
//                               prefixIconConstraints:
//                               BoxConstraints(minWidth: 0, minHeight: 0),
//                               prefixIcon: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 8, horizontal: 8),
//                                   child: Icon(Icons.calendar_today_outlined,size:18,
//                                       color: Theme.of(context).primaryColor)),
//                               suffixIcon: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 8),
//                                 child: Icon(Icons.keyboard_arrow_down,size:18,color: Theme.of(context).primaryColor,),
//                               ),
//                             ),
//                             onTap: () async {
//                               var Todate = await showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(2010),
//                                   lastDate: DateTime.now(),
//                                   builder: (context, child) {
//                                     return Theme(
//                                       data: Theme.of(context).copyWith(
//                                         colorScheme: ColorScheme.light(
//                                           primary:
//                                           Theme.of(context).primaryColor,
//                                           // header background color
//                                           onPrimary: Colors.white,
//                                           // header text color
//                                           onSurface:
//                                           Colors.black, // body text color
//                                         ),
//                                         textButtonTheme: TextButtonThemeData(
//                                           style: TextButton.styleFrom(
//                                             primary: Colors
//                                                 .black, // button text color
//                                           ),
//                                         ),
//                                       ),
//                                       child: child!,
//                                     );
//                                   });
//                               labourDashboardController.labourEntryToDate.text =
//                                   Todate.toString().substring(0, 10);
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Select Date';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               /// Cards ---------
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: labourCards.length,
//                 gridDelegate:
//                 const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 1.45,
//                 ),
//                 itemBuilder: (_, index) {
//                   final item = labourCards[index];
//
//                   return LabourCard(item: item, index: index);
//                   },
//               ),
//
//               SizedBox(height: 12,),
//
//               /// Labour category distribution---------
//
//               Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Column(
//               children: [
//
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Category-wise Labour Attendance",
//                     style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     /// Doughnut
//                     Expanded(
//                       flex: 4,
//                       child: SizedBox(
//                         height: 200,
//                         child: SfCircularChart(
//                           tooltipBehavior: _tooltipBehavior,
//                           annotations: [
//                             CircularChartAnnotation(
//                               widget: Obx(() => Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     // "456",
//                                     labourDashboardController.totalLabour.toString(),
//                                     style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   const Text(
//                                     "TOTAL LABOUR",
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                         color: Colors.grey),
//                                   )
//                                 ],
//                               )),
//                             )
//                           ],
//                           series: [
//                             DoughnutSeries<LabourCategoryWise, String>(
//                               dataSource: labourDashboardController.labourCategoryList,
//
//                               xValueMapper: (e, _) => e.categoryName ?? "",
//
//                               yValueMapper: (e, _) => e.totalNos ?? 0,
//
//                               pointColorMapper: (e, index) =>
//                                   labourDashboardController.getCategoryColor(index!),
//
//                               enableTooltip: true,
//
//                               innerRadius: "70%",
//
//                               radius: "130%",
//
//                               strokeWidth: 2,
//
//                               strokeColor: Colors.white,
//                             )
//                             // DoughnutSeries<LabourCategoryChartData,String>(
//                             //   dataSource: labourDashboardController.labourList,
//                             //   xValueMapper: (e,_)=>e.category,
//                             //   yValueMapper: (e,_)=>e.value,
//                             //   pointColorMapper: (e,_)=>e.color,
//                             //   innerRadius: "70%",
//                             //   radius: "130%",
//                             //   strokeWidth: 2,
//                             //   strokeColor: Colors.white,
//                             // )
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(width: 18),
//
//                     /// Legend
//                     Expanded(
//                       flex: 5,
//                       child: Obx(() {
//                         final visibleItems = labourDashboardController.showAll.value
//                             ? labourDashboardController.labourCategoryList
//                             : labourDashboardController.labourCategoryList.take(4).toList();
//                         return AnimatedSize(
//                           duration: const Duration(milliseconds: 300),
//                           child: Column(
//                             children: [
//                               ...visibleItems.asMap().entries.map((entry){
//                                 final index = entry.key;
//                                 final item = entry.value;
//                                 final color =
//                                 labourDashboardController.getCategoryColor(index);
//
//                                 final percent = labourDashboardController.totalLabour == 0
//                                     ? 0
//                                     : ((item.totalNos ?? 0) /
//                                     labourDashboardController.totalLabour) *
//                                     100;
//                                 return Container(
//                                   margin: const EdgeInsets.only(bottom: 4),
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(15),
//                                     border: Border.all(
//                                         color: Colors.grey.shade300),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 12,
//                                         backgroundColor: color.withOpacity(.15),
//                                         child: Icon(
//                                               labourDashboardController
//                                                   .getCategoryIcon(item.categoryName),
//                                           color: color,
//                                           size: 12,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: Text(
//                                           item.categoryName ?? "",
//                                           style: const TextStyle(fontSize: 11,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10,
//                                             vertical: 5),
//                                         decoration: BoxDecoration(
//                                             color: color.withOpacity(.15),
//                                             borderRadius: BorderRadius.circular(25)
//                                         ),
//                                         child: Text(
//                                           "${item.totalNos?.toInt()} (${percent.toStringAsFixed(1)}%)",
//                                           style: TextStyle(
//                                             color: color,
//                                             fontSize: 8,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 );
//                               }),
//                             ],
//                           ),
//                         );
//                       }),
//                     )
//                   ],
//                 ),
//                 Obx(() {
//                   if (labourDashboardController.labourCategoryList.length <= 4) {
//                     return const SizedBox();
//                   }
//
//                   return InkWell(
//                     onTap: () {
//                       labourDashboardController.showAll.toggle();
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             labourDashboardController.showAll.value
//                                 ? "Show Less"
//                                 : "Show More",
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           Icon(
//                             labourDashboardController.showAll.value
//                                 ? Icons.keyboard_arrow_up
//                                 : Icons.keyboard_arrow_down,
//                             size: 14,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 })
//               ],
//             ),
//           ),
//               SizedBox(height: 12,),
//
//
//               /// ------------- ATTENDANCE CHART ---------
//
//               // Container(
//               //   margin: const EdgeInsets.only(top: 15),
//               //   padding: const EdgeInsets.all(10),
//               //   decoration: BoxDecoration(
//               //     color: Colors.white,
//               //     borderRadius: BorderRadius.circular(15),
//               //     boxShadow: [
//               //       BoxShadow(
//               //         color: Colors.grey.withOpacity(.12),
//               //         blurRadius: 8,
//               //       )
//               //     ],
//               //   ),
//               //   child: Column(
//               //     mainAxisAlignment: MainAxisAlignment.start,
//               //     children: [
//               //       Row(
//               //         children: [
//               //
//               //           const Expanded(
//               //             child: Text(
//               //               "Labour Attendance Today",
//               //               style: TextStyle(
//               //                 fontSize: 16,
//               //                 fontWeight: FontWeight.bold,
//               //               ),
//               //             ),
//               //           ),
//               //
//               //           IconButton(
//               //             onPressed: () {},
//               //             icon: const Icon(Icons.arrow_forward_ios,size:16),
//               //           )
//               //         ],
//               //       ),
//               //       Row(
//               //         children: [
//               //           /// Doughnut Chart
//               //           Expanded(
//               //             flex: 4,
//               //             child: SizedBox(
//               //               height: 160,
//               //               child: AttendanceChart(chartData: chartData, totalCount: 19,),
//               //             ),
//               //           ),
//               //
//               //           const SizedBox(width:20),
//               //
//               //           /// Legend
//               //           Expanded(
//               //             flex: 5,
//               //             child: Column(
//               //
//               //               children: [
//               //
//               //                 attendanceRow(
//               //                   Colors.green,
//               //                   "Present",
//               //                   "212",
//               //                   "85.48%",
//               //                 ),
//               //
//               //                 const SizedBox(height:15),
//               //
//               //                 attendanceRow(
//               //                   Colors.red,
//               //                   "Absent",
//               //                   "28",
//               //                   "11.29%",
//               //                 ),
//               //
//               //                 const SizedBox(height:15),
//               //
//               //                 attendanceRow(
//               //                   Colors.orange,
//               //                   "On Leave",
//               //                   "8",
//               //                   "3.23%",
//               //                 ),
//               //
//               //                 const SizedBox(height:15),
//               //
//               //                 attendanceRow(
//               //                   Colors.purple,
//               //                   "Half Day",
//               //                   "6",
//               //                   "2.42%",
//               //                 ),
//               //
//               //                 const SizedBox(height:15),
//               //
//               //                 attendanceRow(
//               //                   Colors.cyan,
//               //                   "Permission",
//               //                   "4",
//               //                   "1.61%",
//               //                 ),
//               //               ],
//               //             ),
//               //           )
//               //         ],
//               //       )
//               //     ],
//               //   ),
//               // ),
//
//               SizedBox(height: 12),
//
//               /// ----------- OT ANALYSIS TODAY ------------
//
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(.15),
//                       blurRadius: 8,
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const Expanded(
//                           child: Text(
//                             "Project Wise Labour",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//
//                         _legend(Colors.blue, "NMR Work%"),
//                         const SizedBox(width: 15),
//                         _legend(Colors.orange, "Rate Work%"),
//
//                         const SizedBox(width: 8),
//
//                       ],
//                     ),
//
//                     const SizedBox(height: 15),
//
//                     SizedBox(
//                       height: 250,
//                       child: SfCartesianChart(
//                         plotAreaBorderWidth: 0,
//                         primaryXAxis: CategoryAxis(
//                           majorGridLines: const MajorGridLines(width: 0),
//                           axisLine: const AxisLine(width: 0),
//                         ),
//                         primaryYAxis: NumericAxis(
//                           minimum: 0,
//                           maximum: 100,
//                           interval: 20,
//                           axisLine: const AxisLine(width: 0),
//                           majorGridLines: MajorGridLines(
//                             color: Colors.grey.shade300,
//                           ),
//                         ),
//                         legend: Legend(isVisible: false),
//
//                         series: <CartesianSeries>[
//                           ColumnSeries<OTChartData, String>(
//                             width: .55,
//                             spacing: .2,
//                             dataSource: morningData,
//                             xValueMapper: (e, _) => e.x,
//                             yValueMapper: (e, _) => e.y,
//                             color: Colors.blue,
//                             dataLabelSettings:
//                             const DataLabelSettings(isVisible: true),
//                           ),
//
//                           ColumnSeries<OTChartData, String>(
//                             width: .55,
//                             spacing: .2,
//                             dataSource: eveningData,
//                             xValueMapper: (e, _) => e.x,
//                             yValueMapper: (e, _) => e.y,
//                             color: Colors.orange,
//                             dataLabelSettings:
//                             const DataLabelSettings(isVisible: true),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 12),
//
//               /// ----------- TABULAR COLUMN
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(.15),
//                       blurRadius: 8,
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const Expanded(
//                           child: Text(
//                             "Subcontractor Attendance",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//
//           InkWell(
//             onTap: () {
//               Get.to(() => const AttendanceListScreen());
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "View All",
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 5),
//                   Icon(
//                     Icons.keyboard_arrow_down,
//                     size: 14,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//                         const SizedBox(width: 8),
//
//                       ],
//                     ),
//
//                     const SizedBox(height: 15),
//
//                     SizedBox(
//                       height: 250,
//                       child: SfCartesianChart(
//                         plotAreaBorderWidth: 0,
//                         primaryXAxis: CategoryAxis(
//                           majorGridLines: const MajorGridLines(width: 0),
//                           axisLine: const AxisLine(width: 0),
//                         ),
//                         primaryYAxis: NumericAxis(
//                           minimum: 0,
//                           maximum: 100,
//                           interval: 20,
//                           axisLine: const AxisLine(width: 0),
//                           majorGridLines: MajorGridLines(
//                             color: Colors.grey.shade300,
//                           ),
//                         ),
//                         legend: Legend(isVisible: false),
//
//                         series: <CartesianSeries>[
//                           ColumnSeries<OTChartData, String>(
//                             width: .55,
//                             spacing: .2,
//                             dataSource: morningData,
//                             xValueMapper: (e, _) => e.x,
//                             yValueMapper: (e, _) => e.y,
//                             color: Colors.blue,
//                             dataLabelSettings:
//                             const DataLabelSettings(isVisible: true),
//                           ),
//
//                           ColumnSeries<OTChartData, String>(
//                             width: .55,
//                             spacing: .2,
//                             dataSource: eveningData,
//                             xValueMapper: (e, _) => e.x,
//                             yValueMapper: (e, _) => e.y,
//                             color: Colors.orange,
//                             dataLabelSettings:
//                             const DataLabelSettings(isVisible: true),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   final List<OTChartData> morningData = [
//     OTChartData("Hours", 68.5),
//     OTChartData("Amount (₹)", 75.2),
//   ];
//
//   final List<OTChartData> eveningData = [
//     OTChartData("Hours", 46),
//     OTChartData("Amount (₹)", 42.4),
//   ];
//
//   Widget _legend(Color color, String text) {
//     return Row(
//       children: [
//         Container(
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(width: 5),
//         Text(
//           text,
//           style: const TextStyle(fontSize: 12),
//         )
//       ],
//     );
//   }
//
//
//
//   List<LabourCardModel> get labourCards {
//     final data = labourDashboardController.dashboardResponse.value;
//
//     return [
//       LabourCardModel(
//         title: "TOTAL LABOUR",
//         value: "${data?.totalLabourStrength ?? 0}",
//         subtitle: "Active workers today",
//         icon: Icons.groups,
//         color: Color(0xFF2563EB),
//       ),
//
//       LabourCardModel(
//         title: "NMR WORK",
//         value:
//         "${data?.nmrLabourDetails?.isNotEmpty == true ? data!.nmrLabourDetails!.first.totalNmrNos ?? 0 : 0}",
//         subtitle:"No measurement rate basis",
//         icon: Icons.assignment_turned_in_outlined,
//         color: Color(0xFF7C3AED),
//       ),
//
//       LabourCardModel(
//         title: "RATE WORK",
//         value:
//         "${data?.rateWorkDetails?.isNotEmpty == true ? data!.rateWorkDetails!.first.totalNosRateWise ?? 0 : 0}",
//         subtitle: "Measured rate basis",
//         icon: Icons.view_week_outlined,
//         color: Color(0xFFD97706),
//       ),
//
//       LabourCardModel(
//         title: "TOTAL NMR COST",
//         value:
//         "${data?.todayLabourCost?.isNotEmpty == true ? data!.todayLabourCost!.first.todayLabourCost ?? 0 : 0}",
//         subtitle: "Cumulative this month",
//         // "₹ ${data?.todayLabourCost?.isNotEmpty == true ? data!.todayLabourCost!.first.differencePercentage ?? 0.0 : 0.0}",
//         icon: Icons.currency_rupee,
//         color: Color(0xFFE11D48),
//       ),
//
//       LabourCardModel(
//         title: "TOTAL CONTRACTOR",
//         value: "${data?.activeSubContractors ?? 0}",
//         subtitle: "Active subcontractors",
//         icon: Icons.apartment_outlined,
//         color: Color(0xFF0F9D8A),
//
//       ),
//
//       LabourCardModel(
//         title: "PENDING APPROVALS",
//         value: "${data?.pendingAttendanceApprovals ?? 0}",
//         subtitle: "Awaiting sign-off",
//         icon: Icons.access_time_outlined,
//         color: Color(0xFFEF4444),
//       ),
//     ];
//   }
//
//   List<ChartData> chartData = [
//     ChartData(
//         "Present",
//         34.9,
//         // controller.dashboard.value.present!.toDouble(),
//         Colors.green),
//
//     ChartData(
//         "Absent",
//         45.0,
//         // controller.dashboard.value.absent!.toDouble(),
//         Colors.red),
//
//     ChartData(
//         "On Leave",
//         90.8,
//         // controller.dashboard.value.onLeave!.toDouble(),
//         Colors.orange),
//
//     ChartData(
//         "Half Day",
//         34.09,
//         // controller.dashboard.value.halfDay!.toDouble(),
//         Colors.purple),
//
//     ChartData(
//         "Permission",
//         78.4,
//         // controller.dashboard.value.permission!.toDouble(),
//         Colors.cyan),
//   ];
//
//   Widget attendanceRow(
//       Color color,
//       String title,
//       String count,
//       String percentage,
//       ) {
//
//     return Row(
//       children: [
//         Container(
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ),
//
//         const SizedBox(width:12),
//
//         Expanded(
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 15,
//             ),
//           ),
//         ),
//
//         Text(
//           count,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//
//         const SizedBox(width:8),
//
//         Text(
//           "($percentage)",
//           style: const TextStyle(
//             color: Colors.grey,
//           ),
//         )
//       ],
//     );
//   }
// }
//
// class OTChartData {
//   final String x;
//   final double y;
//
//   OTChartData(this.x, this.y);
// }
//
// class LabourCardModel {
//   final String title;
//   final String value;
//   final String subtitle;
//   final IconData icon;
//   final Color color;
//
//   LabourCardModel({
//     required this.title,
//     required this.value,
//     required this.subtitle,
//     required this.icon,
//     required this.color,
//   });
// }
//
// class LabourCard extends StatelessWidget {
//   final LabourCardModel item;
//   final int index;
//
//   const LabourCard({
//     super.key,
//     required this.item,
//     required this.index,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Colors.grey.shade200,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.05),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               /// Icon Box
//               Container(
//                 height: 45,
//                 width: 42,
//                 decoration: BoxDecoration(
//                   color: item.color.withOpacity(.12),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   item.icon,
//                   color: item.color,
//                   size: 22,
//                 ),
//               ),
//
//               const SizedBox(width: 8),
//
//               /// Text Section
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Text(
//                       item.title.toUpperCase(),
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade700,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: .3,
//                       ),
//                     ),
//
//                     const SizedBox(height: 6),
//
//                     SizedBox(
//                       height: 18,
//                       child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           item.value,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 8),
//
//
//                   ],
//                 ),
//               ),
//
//             ],
//           ),
//           SizedBox(height: 5,),
//           Text(
//             item.subtitle,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
