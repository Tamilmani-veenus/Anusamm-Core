import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;
import '../../app_theme/app_colors.dart';
import '../../commonpopup/adminDashViewAllScreen.dart';
import '../../commonpopup/labourAttendanceTable.dart';
import '../../constants/storage_constant.dart';
import '../../controller/admin_dashboard_controller.dart';
import '../../controller/labourDashboard_controller.dart';
import '../../controller/logincontroller.dart';
import '../../controller/menu_controller.dart';
import '../../home/account_settings/account_setting.dart';
import '../../models/admin_dashboard_response.dart';
import '../../utilities/baseutitiles.dart';
import '../../utilities/requestconstant.dart';
import '../menus/main_menuslist.dart';
import '../pendinglist.dart';
import '../reports/reports.dart';
import 'dashboard.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _pageController = PageController();
  Menu_Controller menuController = Get.put(Menu_Controller());
  LoginController loginController = Get.put(LoginController());
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: Setmybackground,
          bottomNavigationBar: BottomBar(
            selectedIndex: _currentPage,
            onTap: (int index) {
              menuController.formMenuId.value = 0;
              _pageController.jumpToPage(index);
              setState(() => _currentPage = index);
            },
            items: const <BottomBarItem>[
              BottomBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeColor: Color(0xFF4B3FFF),
              ),
              BottomBarItem(
                icon: Icon(Icons.menu_open),
                title: Text('Menus'),
                activeColor: Color(0xFF4B3FFF),
              ),
              BottomBarItem(
                icon: Icon(Icons.list_alt),
                title: Text('List'),
                activeColor: Color(0xFF4B3FFF),
              ),
              BottomBarItem(
                icon: Icon(Icons.file_copy_outlined),
                title: Text('Reports'),
                activeColor: Color(0xFF4B3FFF),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      const Expanded(
                          flex: 3,
                          child: Text(
                            "Admin Dashboard",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                      Container(
                        child: InkWell(
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: Icon(Icons.settings,
                                  color: Theme.of(context).primaryColor)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const AccountSettings()));
                          },
                        ),
                      ),
                      Container(
                        child: InkWell(
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: Icon(Icons.logout,
                                  color: Theme.of(context).primaryColor)),
                          onTap: () {
                            logoutPopup(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 15)
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    height: BaseUtitiles.getheightofPercentage(context, 84),
                    child: PageView(
                      controller: _pageController,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: const AdminHomeScreen(),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const MainManusList(),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const PendingList_Screen(),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const Reports_screen(),
                        ),
                      ],
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future logoutPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert!'),
        content: const Text('Are you sure to Logout?'),
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          return Navigator.of(context).pop();
                        },
                        child: const Text("Cancel",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: RequestConstant.Lable_Font_SIZE))),
                  ),
                  VerticalDivider(
                    color: Colors.grey.shade400,
                    width: 5,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15, //Spacing at the bottom of divider.
                  ),
                  Expanded(
                    child: TextButton(
                        onPressed: () async {
                          await loginController.usertoken_DeleteApi(context);
                          await loginController.deleteLoginDetails();
                          await SessionStorage.removeUser();
                        },
                        child: const Text("Logout",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: RequestConstant.Lable_Font_SIZE))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  AdminDashboardController adminDashboardController = Get.put(AdminDashboardController());
  LoginController loginController = Get.put(LoginController());
  late TooltipBehavior _tooltipBehavior;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    final currentDate = DateTime.now();
    final today = currentDate.toString().substring(0, 10);

    adminDashboardController.entryFromDate.text = today;
    adminDashboardController.entryToDate.text = today;

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      color: Colors.black87,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      canShowMarker: true,
      header: '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      adminDashboardController.getAdminDashboardDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Theme.of(context).primaryColor,
            onRefresh: () async {
              await adminDashboardController.getAdminDashboardDetails();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xffE4E7EC),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _dashboardDateCard(
                            context: context,
                            title: "From Date",
                            controller:
                            adminDashboardController.entryFromDate,
                            accentColor: Theme.of(context).primaryColor,
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
                                          primary:
                                          Theme.of(context).primaryColor,
                                          onPrimary: Colors.white,
                                          onSurface:
                                          Colors.black, // body text color
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
                                  }
                              );

                              if (date != null) {
                                adminDashboardController.entryFromDate.text = date.toString().substring(0, 10);
                                    // DateFormat('dd MMM yyyy').format(date);

                                setState(() {});

                                _refreshIndicatorKey.currentState?.show();
                              }
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Range separator
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xffF8FAFC),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xffE4E7EC),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "–",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff667085),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _dashboardDateCard(
                            context: context,
                            title: "To Date",
                            controller:
                            adminDashboardController.entryToDate,
                            accentColor: Theme.of(context).primaryColor,
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
                                          primary:
                                          Theme.of(context).primaryColor,
                                          onPrimary: Colors.white,
                                          onSurface:
                                          Colors.black, // body text color
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
                                  }
                              );

                              if (date != null) {

                                adminDashboardController.entryToDate.text = date.toString().substring(0, 10);
                                    // DateFormat('dd MMM yyyy').format(date);
                                setState(() {});

                                _refreshIndicatorKey.currentState?.show();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      height: 110,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, right: 120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  "${BaseUtitiles().getGreeting()}, \n${loginController.UserName()}!",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Material heads insights \nfor selected date",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Image.asset(
                              "assets/images/adminDashIcon.png",
                              height: 90,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => GridView.builder(
                        padding: EdgeInsets.only(top: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: adminCards.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 2,
                          childAspectRatio: 1.45,
                        ),
                        itemBuilder: (_, index) {
                          final item = adminCards[index];

                          return AdminCard(item: item, index: index);
                        },
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "PO Value vs Billed Amount",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Obx(
                              () => Visibility(
                                visible: adminDashboardController.poVsBillTableList.length>3,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => POVsBillListViewAll(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.4)),
                                    ),
                                    child: Text(
                                      "View All",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Obx(() {
                          final itemList =
                              adminDashboardController.poVsBillTableList;
                          if (itemList.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text("No PO data available for the selected period",style: TextStyle(color: Colors.grey),),
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemList.length > 3 ? 3 : itemList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = itemList[index];
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 44,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              item.projectName!
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.blueGrey.shade700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.projectName!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                "PO: ₹${item.poValue!}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 13,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              item.varianceLabel!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: adminDashboardController
                                                    .getVarianceColor(
                                                        item.varianceLabel),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    SegmentedProgressBar(
                                      progress: adminDashboardController
                                          .getProgress(item.billingPercent),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Bill: ₹${item.billValue!}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${item.billingPercent!} of PO",
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        })
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  /// -----------Budget vs Actual
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(flex: 3,
                              child: Text(
                                "Budget Vs Actual",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => BudgetVsActualDialog(),
                                );},
                              child: Obx(()=>
                                  Visibility(
                                    visible: adminDashboardController.filteredBudgetVsActualList.length>3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.4)),
                                      ),
                                      child: Text(
                                        "View All",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _legend(
                              const Color(0xfff97316),
                              "Budget %",
                            ),
                            const SizedBox(width: 15),
                            _legend(
                              const Color(0xff2563eb),
                              "Actual %",
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        Obx(() {
                          final budgetPercentage = parse_Percentage(
                            adminDashboardController
                                .dashboardResponse
                                .value
                                ?.budgetUsed,
                          );

                          final chartData = List<ProjectCompletion>.from(
                            adminDashboardController.filteredBudgetVsActualList,
                          )
                            ..sort(
                                  (a, b) =>
                                  (b.completionPercentage ?? 0.0)
                                      .compareTo(
                                    a.completionPercentage ?? 0.0,
                                  ),
                            );

                          final topThree = chartData.take(3).toList();
                          return SizedBox(
                            height: 250,
                            child: SfCartesianChart(
                              plotAreaBorderWidth: 0,

                              legend: Legend(
                                isVisible: false,
                              ),

                              margin: const EdgeInsets.only(
                                left: 5,
                                right: 10,
                                top: 20,
                                bottom: 5,
                              ),

                              primaryXAxis: CategoryAxis(
                                majorGridLines: const MajorGridLines(width: 0),

                                majorTickLines: const MajorTickLines(size: 0),

                                axisLine: const AxisLine(width: 0),

                                labelStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),

                                labelIntersectAction:
                                AxisLabelIntersectAction.multipleRows,
                              ),


                              primaryYAxis: NumericAxis(
                                minimum: 0,
                                maximum: 110,
                                interval: 20,
                                axisLine: const AxisLine(width: 0,),

                                majorTickLines: const MajorTickLines(size: 0),

                                majorGridLines: MajorGridLines(color: Colors.grey.shade300,),

                                labelFormat: '{value}%',

                                labelStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              series: <CartesianSeries>[

                                ColumnSeries<ProjectCompletion, String>(
                                  name: "Budget %",
                                  dataSource: topThree,
                                  width: 0.8,
                                  spacing: 0.15,

                                  color: const Color(0xffF97316),

                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),

                                  xValueMapper: (ProjectCompletion item, _,) {
                                    return BaseUtitiles.formatProjectName(
                                      item.projectName ?? "",
                                    );
                                  },

                                  // Every project gets top-level budgetUsed
                                  yValueMapper: (ProjectCompletion item, _,) {
                                    return budgetPercentage;
                                  },

                                  dataLabelMapper: (ProjectCompletion item, _,) {
                                    return '${budgetPercentage.toStringAsFixed(0)}%';
                                  },

                                  dataLabelSettings:
                                  const DataLabelSettings(
                                    isVisible: true,

                                    labelAlignment:
                                    ChartDataLabelAlignment.outer,

                                    textStyle: TextStyle(
                                      color: Color(0xffF97316),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                ColumnSeries<ProjectCompletion, String>(
                                  name: "Actual %",
                                  dataSource: topThree,

                                  width: 0.8,
                                  spacing: 0.15,

                                  color: const Color(0xff2563EB),

                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),

                                  xValueMapper: (ProjectCompletion item, _,) {
                                    return BaseUtitiles.formatProjectName(
                                      item.projectName ?? "",
                                    );
                                  },

                                  // Project completion
                                  yValueMapper: (ProjectCompletion item, _,) {
                                    return item.completionPercentage ?? 0.0;
                                  },

                                  dataLabelMapper: (ProjectCompletion item, _,) {
                                    return '${(item.completionPercentage ?? 0.0).toStringAsFixed(0)}%';
                                  },

                                  dataLabelSettings:
                                  const DataLabelSettings(
                                    isVisible: true,

                                    labelAlignment:
                                    ChartDataLabelAlignment.outer,

                                    textStyle: TextStyle(
                                      color: Color(0xff2563EB),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(flex: 3,
                              child: Text(
                                "Budget Vs Spent (Project-wise)",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => BudgetVsSpendDialog(),
                                );},
                              child: Obx(()=>
                                  Visibility(
                                    visible: adminDashboardController.filteredBudgetVsSpendList.length>3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.4)),
                                      ),
                                      child: Text(
                                        "View All",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _legend(
                              const Color(0xff2F5BEA),
                              "Budget (₹)",
                            ),
                            const SizedBox(width: 15),
                            _legend(
                              const Color(0xff34C759),
                              "Spent (₹)",
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        Obx(() {
                          final chartData = List<BudgetVsSpend>.from(
                            adminDashboardController.filteredBudgetVsSpendList,
                          )
                            ..sort((a, b) =>
                                parseChartValue(b.budget).compareTo(parseChartValue(a.budget)));

                          final topThree = chartData.take(3).toList();

                          final axisValues = getYAxisValues(topThree);

                          return SizedBox(
                            height: 250,
                            child: SfCartesianChart(
                              plotAreaBorderWidth: 0,
                              legend:  Legend(isVisible: false),
                              margin: const EdgeInsets.only(top: 20, right: 10),

                              primaryXAxis: CategoryAxis(
                                visibleMinimum: 0,
                                visibleMaximum: 2,
                                majorGridLines: const MajorGridLines(width: 0),
                                majorTickLines: const MajorTickLines(size: 0),
                                axisLine: const AxisLine(width: 0),
                                labelStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                              ),

                              primaryYAxis: NumericAxis(
                                minimum: 0,
                                maximum: axisValues["maximum"]!,
                                interval: axisValues["interval"]!,
                                axisLine: const AxisLine(width: 0),
                                majorTickLines: const MajorTickLines(size: 0),
                                majorGridLines: MajorGridLines(
                                  color: Colors.grey.shade300,
                                ),
                                axisLabelFormatter: (AxisLabelRenderDetails details) {
                                  return ChartAxisLabel(
                                    formatAxisLabel(details.value),
                                    const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                              series: <CartesianSeries>[
                                ColumnSeries<BudgetVsSpend, String>(
                                  dataSource: topThree,
                                  width: 0.8,
                                  spacing: 0.15,
                                  color: const Color(0xff2F5BEA),

                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),

                                  xValueMapper: (BudgetVsSpend item, _) =>
                                      BaseUtitiles.formatProjectName(item.projectName ?? ""),

                                  yValueMapper: (item, _) => parseChartValue(item.budget),
                                  dataLabelMapper: (BudgetVsSpend item, _) =>
                                      formatChartLabel(item.budget),
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelAlignment: ChartDataLabelAlignment.outer,
                                    textStyle: TextStyle(
                                      color: Color(0xff2F5BEA),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                ColumnSeries<BudgetVsSpend, String>(
                                  dataSource: topThree,
                                  width: 0.8,
                                  spacing: 0.15,
                                  color: const Color(0xff34C759),

                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),

                                  xValueMapper: (BudgetVsSpend item, _) =>
                                      BaseUtitiles.formatProjectName(item.projectName ?? ""),

                                  yValueMapper: (item, _) => parseChartValue(item.spent),
                                  dataLabelMapper: (BudgetVsSpend item, _) =>
                                      formatChartLabel(item.spent),
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelAlignment: ChartDataLabelAlignment.outer,
                                    textStyle: TextStyle(
                                      color: Color(0xff34C759),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ---------- Project Status --------------
                  Container(
                    height: 350,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// ---------------- HEADER ----------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Text(
                                "Project Status",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Obx(
                                  () => Visibility(
                                visible: adminDashboardController
                                    .filteredProjectStatusList.length >
                                    3,
                                child: InkWell(
                                  onTap: () {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (_) => ProjectStatusDialog(),
                                    // );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.4),
                                      ),
                                    ),
                                    child: Text(
                                      "View All",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// ---------------- LEGEND ----------------
                        Row(
                          children: [
                            _projectLegend(
                              dashed: true,
                              color: const Color(0xff3B82F6),
                              title: "Planned (BOQ)",
                            ),

                            const SizedBox(width: 16),

                            _projectLegend(
                              color: const Color(0xff172B63),
                              title: "Tower A",
                            ),

                            const SizedBox(width: 16),

                            _projectLegend(
                              color: const Color(0xffF04444),
                              title: "Mall B",
                            ),

                            const SizedBox(width: 16),

                            _projectLegend(
                              color: const Color(0xffF97316),
                              title: "Villa C",
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// ---------------- CHART ----------------

                        Expanded(
                          child: SfCartesianChart(
                            plotAreaBorderWidth: 0,

                            margin: const EdgeInsets.only(
                              left: 0,
                              right: 8,
                              top: 5,
                              bottom: 0,
                            ),

                            legend:  Legend(
                              isVisible: false,
                            ),
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              activationMode: ActivationMode.singleTap,
                              color: const Color(0xff101828),
                              borderWidth: 0,
                              canShowMarker: false,
                              duration: 3000,

                              builder: (
                                  dynamic data,
                                  dynamic point,
                                  dynamic series,
                                  int pointIndex,
                                  int seriesIndex,
                                  ) {
                                final item = data as ProjectStatus;

                                String projectName;
                                double value;

                                if (seriesIndex == 0) {
                                  projectName = "Planned (BOQ)";
                                  value = item.planned;
                                } else if (seriesIndex == 1) {
                                  projectName = "Tower A";
                                  value = item.towerA;
                                } else if (seriesIndex == 2) {
                                  projectName = "Mall B";
                                  value = item.mallB;
                                } else {
                                  projectName = "Villa C";
                                  value = item.villaC;
                                }

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff101828),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        projectName,
                                        style: TextStyle(
                                          color: series.color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        item.month,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      Text(
                                        "${value.toStringAsFixed(0)}%",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            primaryXAxis: CategoryAxis(
                              majorGridLines: const MajorGridLines(
                                width: 0,
                              ),

                              majorTickLines: const MajorTickLines(
                                size: 0,
                              ),

                              axisLine: const AxisLine(
                                width: 0,
                              ),

                              labelRotation: -25,
                              // labelIntersectAction: AxisLabelIntersectAction.none,
                              /// ---------- For 12 Months display ----------
                              labelPlacement: LabelPlacement.betweenTicks,

                              interval: 1,

                              labelIntersectAction: AxisLabelIntersectAction.rotate45,

                              labelStyle: const TextStyle(
                                fontSize: 9,
                                color: Color(0xff8B98AB),
                              ),
                            ),

                            primaryYAxis: NumericAxis(
                              minimum: 0,
                              maximum: 110,
                              interval: 20,

                              axisLine: const AxisLine(
                                width: 0,
                              ),

                              majorTickLines: const MajorTickLines(
                                size: 0,
                              ),

                              majorGridLines: MajorGridLines(
                                width: .7,
                                color: Colors.grey.shade200,
                              ),

                              labelFormat: "{value}%",

                              labelStyle: const TextStyle(
                                fontSize: 9,
                                color: Color(0xff9AA5B5),
                              ),
                            ),

                            series: <CartesianSeries>[
                              LineSeries<ProjectStatus, String>(

                                name: "Planned (BOQ)",
                                dataSource: chartData,

                                xValueMapper: (ProjectStatus item, _,) => item.month,

                                yValueMapper: (ProjectStatus item, _,) => item.planned,

                                color: const Color(0xff3B82F6),
                                width: 2,

                                dashArray: const <double>[6, 4,],

                                markerSettings: const MarkerSettings(isVisible: false),
                              ),

                              LineSeries<ProjectStatus, String>(

                                name: "Tower A",
                                dataSource: chartData,

                                xValueMapper: (ProjectStatus item, _,) => item.month,

                                yValueMapper: (ProjectStatus item, _,) => item.towerA,

                                color: const Color(0xff172B63),
                                width: 2.2,

                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  width: 6,
                                  height: 6,
                                  shape: DataMarkerType.circle,
                                  borderWidth: 1.5,
                                  color: Color(0xff172B63),
                                  borderColor: Colors.white,
                                ),
                              ),

                              LineSeries<ProjectStatus, String>(
                                name: "Mall B",
                                dataSource: chartData,

                                xValueMapper: (ProjectStatus item, _,) => item.month,

                                yValueMapper: (ProjectStatus item, _,) => item.mallB,

                                color: const Color(0xffF04444),
                                width: 2.2,

                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  width: 6,
                                  height: 6,
                                  shape: DataMarkerType.circle,
                                  borderWidth: 1.5,
                                  color: Color(0xffF04444),
                                  borderColor: Colors.white,
                                ),
                              ),

                              LineSeries<ProjectStatus, String>(
                                name: "Villa C",
                                dataSource: chartData,

                                xValueMapper: (ProjectStatus item, _,) => item.month,

                                yValueMapper: (ProjectStatus item, _,) => item.villaC,

                                color: const Color(0xffF97316),
                                width: 2.2,

                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  width: 6,
                                  height: 6,
                                  shape: DataMarkerType.circle,
                                  borderWidth: 1.5,
                                  color: Color(0xffF97316) ,
                                  borderColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Expense Category Mix",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Obx(() {
                          final expenseList = expenseChartList;
                          final totalExpenseText = adminDashboardController
                              .dashboardResponse
                              .value
                              ?.expenseCategoryMix
                              ?.totalExpense
                              ?.totalExpenseAmount
                              ?.toString() ??
                              "0";

                          final totalExpense = parseChartValue(totalExpenseText);

                          final isZeroExpense = totalExpense == 0;
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Doughnut
                                  Expanded(
                                    flex: 4,
                                    child: SizedBox(
                                        height: 200,
                                        child: Transform.translate(
                                          offset: const Offset(0, 50),
                                          child: SfCircularChart(
                                            tooltipBehavior: _tooltipBehavior,
                                            onTooltipRender: (TooltipArgs args) {
                                              final item = expenseList[args.pointIndex!.toInt()];

                                              args.header = item.title;

                                              args.text =
                                              "${item.percentage.toStringAsFixed(2)}%  •  ${item.amount}";
                                            },
                                            margin: EdgeInsets.zero,
                                            annotations: [
                                              CircularChartAnnotation(
                                                angle: 90,
                                                radius: "0%",
                                                widget: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "₹ ${BaseUtitiles().formatAmount(
                                                        adminDashboardController
                                                            .dashboardResponse
                                                            .value
                                                            ?.expenseCategoryMix
                                                            ?.totalExpense
                                                            ?.totalExpenseAmount
                                                            .toString() ??
                                                            "0",
                                                      )}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "Total Expense",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                            series: [
                                              if (!isZeroExpense && expenseList.isNotEmpty)
                                                DoughnutSeries<ExpenseChartData,
                                                    String>(
                                                  dataSource: expenseList,
                                                  xValueMapper: (e, _) => e.title,
                                                  yValueMapper: (e, _) =>
                                                  e.percentage,
                                                  pointColorMapper: (e, _) =>
                                                  e.color,
                                                  startAngle: 270,
                                                  endAngle: 90,
                                                  innerRadius: "78%",
                                                  radius: "110%",
                                                  strokeWidth: 0,
                                                  strokeColor: Colors.white,
                                                )else
                                                DoughnutSeries<EmptyExpenseChartData, String>(
                                                  dataSource: const [
                                                    EmptyExpenseChartData(
                                                      title: "No Expense",
                                                      value: 100,
                                                    ),
                                                  ],

                                                  xValueMapper: (e, _) => e.title,

                                                  yValueMapper: (e, _) => e.value,

                                                  pointColorMapper: (_, __) =>
                                                  const Color(0xffE3E1DD),

                                                  startAngle: 270,
                                                  endAngle: 90,

                                                  innerRadius: "78%",
                                                  radius: "110%",

                                                  strokeWidth: 0,
                                                  strokeColor: Colors.white,
                                                ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              ExpenseLegend(
                                data: expenseChartList,
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Top 2 Active Projects",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Obx(
                                  () => Visibility(
                                visible: adminDashboardController.boqProgressTableList.length>2,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const BOQProgressViewAll(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.4)),
                                    ),
                                    child: Text(
                                      "View All",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Obx(() {
                          final itemList = adminDashboardController.boqProgressTableList;
                          if (itemList.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text("No Data Found"),
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemList.length > 2 ? 2 : itemList.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = itemList[index];
                              final statusColor = adminDashboardController.getStatusColor(item.status);
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 44,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              item.projectName!
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.projectName!,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      "Start: ${item.startDate ?? "-"}",
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withOpacity(.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  item.status!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: statusColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Expanded(flex: 1,
                                          child: Text(
                                            "BOQ: ₹${BaseUtitiles().formatAmount(item.boqValue.toString())}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 1,
                                          child: Text(
                                            "Planned % : ${BaseUtitiles().formatAmount(item.plannedPercentage.toString())}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 1,
                                          child: Text(
                                            "Actual % : ${BaseUtitiles().formatAmount(item.actualPercentage.toString())}",
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        segmentedProgress(
                                          progress: item.progress!,
                                          color: adminDashboardController.getStatusColor(item.status).withOpacity(0.8),
                                        ),

                                        const SizedBox(height: 12),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            Text(
                                              item.progress!,
                                              style: TextStyle(
                                                color: adminDashboardController.getStatusColor(item.status),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            Text(
                                              "End : ${item.endDate ?? "-"}",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        })
                      ],
                    ),
                  ),
                  SizedBox(height: 60,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final List<ProjectStatus> chartData = [
    ProjectStatus(
      month: "Apr",
      planned: 0,
      towerA: 2,
      mallB: 0,
      villaC: 0,
    ),
    ProjectStatus(
      month: "May",
      planned: 10,
      towerA: 28,
      mallB: 2,
      villaC: 0,
    ),
    ProjectStatus(
      month: "Jun",
      planned: 20,
      towerA: 22,
      mallB: 43,
      villaC: 2,
    ),
    ProjectStatus(
      month: "Jul",
      planned: 30,
      towerA: 30,
      mallB: 53,
      villaC: 15,
    ),
    ProjectStatus(
      month: "Aug",
      planned: 38,
      towerA: 25,
      mallB: 49,
      villaC: 20,
    ),
    ProjectStatus(
      month: "Sep",
      planned: 46,
      towerA: 35,
      mallB: 58,
      villaC: 25,
    ),
    ProjectStatus(
      month: "Oct",
      planned: 55,
      towerA: 15,
      mallB: 75,
      villaC: 32,
    ),
    ProjectStatus(
      month: "Nov",
      planned: 65,
      towerA: 30,
      mallB: 80,
      villaC: 37,
    ),
    ProjectStatus(
      month: "Dec",
      planned: 73,
      towerA: 15,
      mallB: 82,
      villaC: 42,
    ),
    ProjectStatus(
      month: "Jan",
      planned: 83,
      towerA: 44,
      mallB: 100,
      villaC: 22,
    ),
    ProjectStatus(
      month: "Feb",
      planned: 92,
      towerA: 30,
      mallB: 96,
      villaC: 17,
    ),
    ProjectStatus(
      month: "Mar",
      planned: 100,
      towerA: 70,
      mallB: 92,
      villaC: 36,
    ),
  ];

  double parse_Percentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 0.0;
    }

    return double.tryParse(
      value.replaceAll('%', '').trim(),
    ) ??
        0.0;
  }

  double parseChartValue(String? value) {
    if (value == null || value.trim().isEmpty) return 0;

    String text = value.replaceAll("₹", "").replaceAll(",", "").trim();

    if (text.endsWith("L")) {
      return (double.tryParse(text.replaceAll("L", "").trim()) ?? 0) * 100000;
    }

    if (text.endsWith("Cr")) {
      return (double.tryParse(text.replaceAll("Cr", "").trim()) ?? 0) * 10000000;
    }

    return double.tryParse(text) ?? 0;
  }

  String formatChartLabel(String? value) {
    if (value == null || value.isEmpty) return "0";

    // Don't modify values with units
    if (value.contains("L") || value.contains("Cr")) {
      return value;
    }

    final number = double.tryParse(value.replaceAll("₹", "").trim());

    if (number == null) return value;

    if (number == number.toInt()) {
      return number.toInt().toString(); // 105.00 -> 105
    }

    return number.toString(); // 100.50 -> 100.5
  }

  String formatAxisLabel(num value) {
    if (value >= 10000000) {
      return "${(value / 10000000).toStringAsFixed(2)} Cr";
    }

    if (value >= 100000) {
      return "${(value / 100000).toStringAsFixed(2)} L";
    }

    // Remove trailing .00
    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  Widget _legend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }

  Map<String, double> getYAxisValues(List<BudgetVsSpend> list) {
    double maxValue = 0;

    for (final item in list) {
      maxValue = math.max(
        maxValue,
        math.max(
          parseChartValue(item.budget),
          parseChartValue(item.spent),
        ),
      );
    }

    // Handle all zero values
    if (maxValue <= 0) {
      return {
        "maximum": 5,
        "interval": 1,
      };
    }

    final maximum = (maxValue * 1.1).ceilToDouble();
    final interval = math.max(1.0, maximum / 5);

    return {
      "maximum": maximum,
      "interval": interval,
    };
  }

  List<AdminCardModel> get adminCards {
    final value = adminDashboardController.dashboardResponse.value?.result;
    return [
      AdminCardModel(
        title: "ACTIVE PROJECTS",
        value: "${value?.activeProjects ?? 0}",
        subtitle: "Total Active Projects",
        path: "assets/admin_dashboard_card/adminDash1.png",
      ),
      AdminCardModel(
        title: "OUTSTANDING SUPPLIER",
        value:
            "₹ ${BaseUtitiles().formatAmount(value?.totalOutStandingSupplier)}",
        subtitle: "Supplier Outstanding",
        path: "assets/admin_dashboard_card/adminDash2.png",
      ),
      AdminCardModel(
        title: "OUTSTANDING SUBCONT",
        value:
            "₹ ${BaseUtitiles().formatAmount(value?.totalOutStandingSubcont)}",
        subtitle: "Subcontractor Outstanding",
        path: "assets/admin_dashboard_card/adminDash3.png",
      ),
      AdminCardModel(
        title: "TOTAL EXPENSE",
        value: "₹ ${BaseUtitiles().formatAmount(value?.totalExpense)}",
        subtitle: "Total Expenditure",
        path: "assets/admin_dashboard_card/adminDash4.png",
      ),
      AdminCardModel(
        title: "CASH IN BANK",
        value: "₹ ${BaseUtitiles().formatAmount(value?.totalCashInBank)}",
        subtitle: "Bank Balance",
        path: "assets/admin_dashboard_card/adminDash5.png",
      ),
      AdminCardModel(
        title: "CASH IN HAND",
        value: "₹ ${BaseUtitiles().formatAmount(value?.totalCashInHand)}",
        subtitle: "Cash on Hand",
        path: "assets/admin_dashboard_card/adminDash6.png",
      ),
    ];
  }

  Widget _dashboardDateCard({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required Color accentColor,
    required VoidCallback onTap,
  }) {

    if (controller.text.isNotEmpty) {
      try {
        final date = DateFormat('dd MMM yyyy')
            .parse(controller.text);

      } catch (_) {}
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accentColor.withOpacity(.35),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                color: accentColor,
                size: 18,
              ),
            ),

            const SizedBox(width: 5),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff667085),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    controller.text.isEmpty
                        ? "Select date"
                        : controller.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff101828),
                    ),
                  ),

                  // if (weekday.isNotEmpty) ...[
                  //   const SizedBox(height: 2),
                  //   Text(
                  //     weekday,
                  //     style: const TextStyle(
                  //       fontSize: 10,
                  //       color: Color(0xff98A2B3),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),

            // Icon(
            //   Icons.keyboard_arrow_down_rounded,
            //   color: accentColor,
            // ),
          ],
        ),
      ),
    );
  }



  List<ExpenseChartData> get expenseChartList {
    if (adminDashboardController.expenseCategoryMixList.isEmpty) return [];

    final expense = adminDashboardController.expenseCategoryMixList.first;

    return [
      ExpenseChartData(
        title: "Material",
        amount: expense.material?.amount ?? "0",
        percentage: (expense.material?.percentage ?? 0).toDouble(),
        color: Colors.blue,
      ),
      ExpenseChartData(
        title: "NMR Work",
        amount: expense.nmrWorkAmount?.amount ?? "0",
        percentage: (expense.nmrWorkAmount?.percentage ?? 0).toDouble(),
        color: Colors.green,
      ),
      ExpenseChartData(
        title: "Rate Work",
        amount: expense.rateWorkAmount?.amount ?? "0",
        percentage: (expense.rateWorkAmount?.percentage ?? 0).toDouble(),
        color: Colors.orange,
      ),
      ExpenseChartData(
        title: "MIS",
        amount: expense.mis?.amount ?? "0",
        percentage: (expense.mis?.percentage ?? 0).toDouble(),
        color: Colors.red,
      ),
      ExpenseChartData(
        title: "Site Material",
        amount: expense.siteMaterialExpense?.amount ?? "0",
        percentage: (expense.siteMaterialExpense?.percentage ?? 0).toDouble(),
        color: Colors.purple,
      ),
    ];
  }

  Widget _projectLegend({
    required Color color,
    required String title,
    bool dashed = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dashed)
          SizedBox(
            width: 18,
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 2,
                  color: color,
                ),
                const SizedBox(width: 3),
                Container(
                  width: 7,
                  height: 2,
                  color: color,
                ),
              ],
            ),
          )
        else
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

        const SizedBox(width: 6),

        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xff52647A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}

class AdminHomeScreen extends StatefulWidget {
  final bool isAdmin;
  const AdminHomeScreen({super.key,this.isAdmin = false,});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class ProjectStatus {
  final String month;
  final double planned;
  final double towerA;
  final double mallB;
  final double villaC;

  ProjectStatus({
    required this.month,
    required this.planned,
    required this.towerA,
    required this.mallB,
    required this.villaC,
  });
}

class EmptyExpenseChartData {
  final String title;
  final double value;

  const EmptyExpenseChartData({
    required this.title,
    required this.value,
  });
}

class ExpenseChartData {
  final String title;
  final String amount;
  final double percentage;
  final Color color;

  ExpenseChartData({
    required this.title,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class ExpenseLegend extends StatelessWidget {
  final List<ExpenseChartData> data;

  const ExpenseLegend({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        data.length,
            (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _LegendItem(data: data[index]),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final ExpenseChartData data;

  const _LegendItem({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Color Box
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: data.color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        const SizedBox(width: 8),

        /// Title + Dotted line
        Expanded(
          child: Row(
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        spacing: 2,
                        children: List.generate(
                          (constraints.maxWidth / 4).floor(),
                              (_) => Container(
                            width: 2,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        /// Amount + Percentage
        RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            children: [
              TextSpan(
                text: "${data.amount} ",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              TextSpan(
                text: "(${data.percentage.toStringAsFixed(2)}%)",
                style: TextStyle(
                  color: data.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminCardModel {
  final String title;
  final String value;
  final String subtitle;
  final String path;

  AdminCardModel({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.path,
  });
}

class AdminCard extends StatelessWidget {
  final AdminCardModel item;
  final int index;

  const AdminCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 35,
                child: Image.asset(
                  item.path,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 18,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: parseAnimatedValue(item.value),
                ),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutCubic,
                builder: (
                    BuildContext context,
                    double animatedValue,
                    Widget? child,
                    ) {
                  String displayValue;

                  final originalValue = item.value
                      .replaceAll("₹", "")
                      .trim()
                      .toUpperCase();

                  if (originalValue.endsWith("CR")) {
                    displayValue =
                    "₹ ${animatedValue.toStringAsFixed(2)} CR";
                  } else if (originalValue.endsWith("L")) {
                    displayValue =
                    "₹ ${animatedValue.toStringAsFixed(2)} L";
                  } else {
                    displayValue = animatedValue.toInt().toString();

                    if (item.value.contains("₹")) {
                      displayValue = "₹ $displayValue";
                    }
                  }

                  return Text(
                    displayValue,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
          // SizedBox(
          //   height: 18,
          //   child: FittedBox(
          //     fit: BoxFit.scaleDown,
          //     alignment: Alignment.centerLeft,
          //     child: Text(
          //       item.value,
          //       style: const TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 8),
          Text(
            item.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
  double parseAnimatedValue(String value) {
    String cleanValue = value
        .replaceAll("₹", "")
        .replaceAll(",", "")
        .trim()
        .toUpperCase();

    if (cleanValue.endsWith("CR")) {
      return double.tryParse(
        cleanValue.replaceAll("CR", "").trim(),
      ) ??
          0;
    }

    if (cleanValue.endsWith("L")) {
      return double.tryParse(
        cleanValue.replaceAll("L", "").trim(),
      ) ??
          0;
    }

    return double.tryParse(cleanValue) ?? 0;
  }
}

class SegmentedProgressBar extends StatelessWidget {
  final double progress; // 0 to 1
  final int totalSegments;
  final Color activeColor;
  final Color inactiveColor;
  final double height;
  final double spacing;
  final double radius;

  const SegmentedProgressBar({
    super.key,
    required this.progress,
    this.totalSegments = 34,
    this.activeColor = const Color(0xff7381e8),
    this.inactiveColor = const Color(0xffE8EBFF),
    this.height = 18,
    this.spacing = 4,
    this.radius = 3,
  });

  @override
  Widget build(BuildContext context) {
    final activeSegments = (progress * totalSegments).round();

    return Row(
      children: List.generate(totalSegments * 2 - 1, (index) {
        if (index.isOdd) {
          return SizedBox(width: spacing);
        }

        final segmentIndex = index ~/ 2;

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height,
            decoration: BoxDecoration(
              color:
              segmentIndex < activeSegments ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        );
      }),
    );
  }
}

double getProgressPercentage(String progress) {
  final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(progress);

  if (match != null) {
    return double.parse(match.group(1)!);
  }

  return 0;
}

Widget segmentedProgress({required String progress, required Color color}) {
  const int totalSegments = 14;

  final percentage = getProgressPercentage(progress);

  final filledSegments =
  ((percentage.clamp(0, 100) / 100) * totalSegments).round();

  return Row(
    children: List.generate(totalSegments, (index) {
      final filled = index < filledSegments;

      return Expanded(
        child: Container(
          margin: EdgeInsets.only(right: index == totalSegments - 1 ? 0 : 4),
          height: 8,
          decoration: BoxDecoration(
            color: filled ? color : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }),
  );
}
