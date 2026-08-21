import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../app_theme/app_colors.dart';
import '../../commonpopup/material_dash_view_all.dart';
import '../../constants/storage_constant.dart';
import '../../controller/logincontroller.dart';
import '../../controller/material_dashboard_controller.dart';
import '../../controller/menu_controller.dart';
import '../../home/account_settings/account_setting.dart';
import '../../utilities/baseutitiles.dart';
import '../../utilities/requestconstant.dart';
import '../menus/main_menuslist.dart';
import '../pendinglist.dart';
import '../reports/reports.dart';
import 'dashboard.dart';

class MaterialDashboard extends StatefulWidget {
  const MaterialDashboard({super.key});

  @override
  State<MaterialDashboard> createState() => _MaterialDashboardState();
}

class _MaterialDashboardState extends State<MaterialDashboard> {
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
                            "Material Dashboard",
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
                          child: const MaterialHomeScreen(),
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

class _MaterialHomeScreenState extends State<MaterialHomeScreen> {
  MaterialDashboardController materialDashboardController = Get.put(MaterialDashboardController());
  LoginController loginController = Get.put(LoginController());
  String activeFilterTab = "today";
  String rangeLabel = "";

  final List<String> tabs = [
    "Project Wise",
    "Material Head",
    "Supplier Wise",
  ];

  final List<Map<String, String>> filterTabs = [
    {"key": "today", "label": "Today"},
    {"key": "week", "label": "This Week"},
    {"key": "month", "label": "This Month"},
    {"key": "quarter", "label": "This Qtr"},
    {"key": "fy", "label": "This FY"},
    {"key": "lastfy", "label": "Last FY"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectFilterTab("today");
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
            onRefresh: () async {
              if (materialDashboardController.selectedTab.value == 0) {
                await materialDashboardController.getMatProjWiseDashboardDetails();
              }else if (materialDashboardController.selectedTab.value == 1) {
                await materialDashboardController.getMatHeadDashboardDetails();
              }else{

              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Container(
                      height: 38,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F2F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: List.generate(
                          tabs.length,
                          (index) {
                            final isSelected =
                                materialDashboardController.selectedTab.value ==
                                    index;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                    setState(() {
                                      activeFilterTab = "today";

                                      final today = DateTime.now();

                                      materialDashboardController.entryFromDate.text =
                                          formatDate(today);

                                      materialDashboardController.entryToDate.text =
                                          formatDate(today);

                                      rangeLabel = formatRangeLabel(today, today);
                                    });

                                    materialDashboardController.selectedTab.value = index;

                                    if (index == 0) {
                                      await materialDashboardController
                                          .getMatProjWiseDashboardDetails();
                                    } else if (index == 1) {
                                      await materialDashboardController
                                          .getMatHeadDashboardDetails();
                                    }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    tabs[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF5F6570),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
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
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: durationFilter(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    if (materialDashboardController.selectedTab.value == 0) {
                      return _buildProjectWise();
                    }
                    else if (materialDashboardController.selectedTab.value == 1) {
                      return _buildMaterialHead();
                    }
                    // else if (materialDashboardController.selectedTab.value == 2) {
                    //   return _buildSupplierWise();
                    // }

                    return const SizedBox.shrink();
                  }),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectWise() {
    return  materialDashboardController.projectWiseResponse.value==null?
    const DashboardErrorWidget(): Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          // height: 110,
          width: double.infinity,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${BaseUtitiles().getGreeting()}, ${loginController.UserName()}  👋",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  "Track your project progress.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 25),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GreetingCard(
                          item: greetingCards[0],
                          index: 0,
                        ),
                      ),

                      // Small vertical divider
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 1,
                          height: 30,
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),

                      Expanded(
                        child: GreetingCard(
                          item: greetingCards[1],
                          index: 1,
                        ),
                      ),

                      // Small vertical divider
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 1,
                          height: 30,
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),

                      Expanded(
                        child: GreetingCard(
                          item: greetingCards[2],
                          index: 2,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(
              () => GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridInfoCardsProjWise.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (_, index) {
              return GridInfoCard(
                item: gridInfoCardsProjWise[index],
                index: index,
              );
            },
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
                    "PO Value vs Billed Amount",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                        () => Visibility(
                      visible: materialDashboardController
                          .poVsBillTableList.length >
                          3,
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
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
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
                    materialDashboardController.poVsBillTableList;
                if (itemList.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "No PO data available for the selected period",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                  itemList.length > 3 ? 3 : itemList.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = itemList[index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border:
                        Border.all(color: Colors.grey.shade200),
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
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.red.withOpacity(0.18),
                                      Colors.blueAccent
                                          .withOpacity(0.06),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    item.projectName!
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.black,
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
                                      "PO: ₹${item.poAmountInLakhs!}",
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
                                      "Bill: ₹${item.billAmountInLakhs!}",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SegmentedProgressBar(
                            progress: materialDashboardController
                                .getProgress(
                              item.billAmountInLakhs,
                              item.poAmountInLakhs,
                            ),
                          ),
                          const SizedBox(height: 10),
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
                    "Billing Completion",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                        () => Visibility(
                      visible: materialDashboardController
                          .billingCompletionList.length >
                          3,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BillingCompletionViewAll(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
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
                    materialDashboardController.billingCompletionList;
                if (itemList.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "No billing data available for the selected period",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                  itemList.length > 3 ? 3 : itemList.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = itemList[index];
                    final percentage =
                        item.billingCompletionPercentage ?? 0.0;
                    final progress =
                    (percentage / 100).clamp(0.0, 1.0);
                    final progressColor = materialDashboardController
                        .getProgressColor(percentage);
                    return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                          Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Avatar
                            Container(
                              width: 42,
                              height: 46,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: progressColor,
                                    width: 4,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  item.projectName!
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: progressColor,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Project details
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // Name + Percentage
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.projectName!,
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${item.billingCompletionPercentage ?? 0} %",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: progressColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // Progress bar
                                  AnimatedProgressBar(
                                    progress: progress,
                                    progressColor: progressColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ));
                  },
                );
              })
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
                    "Project PO vs Bill Register",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                        () => Visibility(
                      visible: materialDashboardController
                          .poVsBillRegList.length >
                          2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => POVsBillRegViewAll(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
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
                    materialDashboardController.poVsBillRegList;
                if (itemList.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "No Data Found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                  itemList.length > 2 ? 2 : itemList.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = itemList[index];
                    final statusColor = materialDashboardController
                        .getStatusColor(item.billingStatus);
                    final percentage = item.billingPercentage ?? 0.0;
                    final progressColor = materialDashboardController
                        .getProgressColor(percentage);

                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border:
                        Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [
                          // ───────── HEADER ROW ─────────
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.projectName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.red, size: 15),
                                    const SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                        item.address ?? '',
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // ───────── METRICS TABLE CONTAINER ─────────
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFF7D6E2),
                                width: 1,
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFFFFFFF),
                                  Color(0xFFFEFBFC),
                                  Color(0xFFF9F2F5),
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                // TOP ROW (4 Items)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildItem(
                                        title: "POs",
                                        value: "${item.totalPos}",
                                      ),
                                    ),
                                    _buildDivider(),
                                    Expanded(
                                      child: _buildItem(
                                        title: "PO Value",
                                        value:
                                        "${item.poAmountInLakhs}",
                                        valueColor: Colors.blueAccent,
                                      ),
                                    ),
                                    _buildDivider(),
                                    Expanded(
                                      child: _buildItem(
                                        title: "Billed",
                                        value:
                                        "${item.billAmountInLakhs}",
                                        valueColor:
                                        const Color(0xFF10B981),
                                      ),
                                    ),
                                    _buildDivider(),
                                    Expanded(
                                      child: _buildItem(
                                        title: "Approved",
                                        value:
                                        "${item.billAmountInLakhs}",
                                        valueColor: Colors.lightGreen,
                                      ),
                                    ),
                                  ],
                                ),

                                // Horizontal Divider
                                Container(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                ),

                                // BOTTOM ROW (3 Items)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildItem(
                                        title: "Unbilled",
                                        value:
                                        "${item.unbilledAmountInLakhs}",
                                        valueColor:
                                        Colors.brown.shade400,
                                      ),
                                    ),
                                    _buildDivider(),
                                    Expanded(
                                      child: _buildItem(
                                        title: "Over-Bill",
                                        value:
                                        "${item.overBillAmountInLakhs}",
                                        valueColor: Colors.red,
                                      ),
                                    ),
                                    _buildDivider(),
                                    Expanded(
                                      child: _buildItem(
                                        title: "Billing %",
                                        value:
                                        "${item.billingPercentage} %",
                                        valueColor: progressColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // ───────── BOTTOM PROGRESS & BADGE ROW ─────────
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final bool isNarrow =
                                  constraints.maxWidth < 280;

                              if (isNarrow) {
                                return Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ChevronProgressIndicator(
                                        progress:
                                        materialDashboardController
                                            .getPercentProgress(
                                          item.billingPercentage
                                              .toString(),
                                        ),
                                        activeColor: progressColor,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor
                                            .withOpacity(0.05),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                          color: statusColor
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      child: Text(
                                        item.billingStatus ?? '',
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color: statusColor,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }

                              return Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height:
                                      20, // optional, keeps indicator height consistent
                                      child: ChevronProgressIndicator(
                                        progress:
                                        materialDashboardController
                                            .getPercentProgress(
                                          item.billingPercentage
                                              .toString(),
                                        ),
                                        activeColor: progressColor,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // Fixed width for status
                                  SizedBox(
                                    width: 80,
                                    child: Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor
                                            .withOpacity(0.05),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                          color: statusColor
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      child: Text(
                                        item.billingStatus ?? '',
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialHead() {
    return materialDashboardController.materialHeadResponse.value==null?
    const DashboardErrorWidget(): Column(
      children: [
        Obx(
              () => GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridInfoCardsMatHead.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (_, index) {
              return GridInfoCard(
                item: gridInfoCardsMatHead[index],
                index: index,
              );
            },
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
                    "PO Value vs Billed Amount by Head",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                        () => Visibility(
                      visible: materialDashboardController
                          .poVsBillTableList.length >
                          3,
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
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
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
                    materialDashboardController.poVsBillTableList;
                if (itemList.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "No PO data available for the selected period",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                  itemList.length > 3 ? 3 : itemList.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = itemList[index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border:
                        Border.all(color: Colors.grey.shade200),
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
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.red.withOpacity(0.18),
                                      Colors.blueAccent
                                          .withOpacity(0.06),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    item.projectName!
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.black,
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
                                      "PO: ₹${item.poAmountInLakhs!}",
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
                                      "Bill: ₹${item.billAmountInLakhs!}",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SegmentedProgressBar(
                            progress: materialDashboardController
                                .getProgress(
                              item.billAmountInLakhs,
                              item.poAmountInLakhs,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                );
              })
            ],
          ),
        ),

      ],
    );
  }

  //Others

  DateTimeRange getRangeForTab(String tab) {
    final now = DateTime.now();

    final int y = now.year;
    final int m = now.month;
    final int d = now.day;

    switch (tab) {
      case "today":
        return DateTimeRange(
          start: DateTime(y, m, d),
          end: DateTime(y, m, d),
        );

      case "week":
        // Monday to Sunday
        final day = now.weekday; // Monday = 1, Sunday = 7

        final from = DateTime(
          y,
          m,
          d - (day - 1),
        );

        final to = from.add(const Duration(days: 6));

        return DateTimeRange(
          start: from,
          end: to,
        );

      case "month":
        return DateTimeRange(
          start: DateTime(y, m, 1),
          end: DateTime(y, m + 1, 0),
        );

      case "quarter":
        final quarter = ((m - 1) ~/ 3);

        final startMonth = quarter * 3 + 1;

        return DateTimeRange(
          start: DateTime(y, startMonth, 1),
          end: DateTime(y, startMonth + 3, 0),
        );

      case "fy":
        // April 1 -> March 31
        final startYear = m >= 4 ? y : y - 1;

        return DateTimeRange(
          start: DateTime(startYear, 4, 1),
          end: DateTime(startYear + 1, 3, 31),
        );

      case "lastfy":
        final currentFYStartYear = m >= 4 ? y : y - 1;
        final startYear = currentFYStartYear - 1;

        return DateTimeRange(
          start: DateTime(startYear, 4, 1),
          end: DateTime(startYear + 1, 3, 31),
        );

      default:
        return DateTimeRange(
          start: DateTime(y, m, 1),
          end: DateTime(y, m + 1, 0),
        );
    }
  }

  String formatDate(DateTime date) {
    return DateFormat("dd-MM-yyyy").format(date);
  }

  String formatRangeLabel(DateTime from, DateTime to) {
    return "${DateFormat("d MMM yyyy").format(from)} – "
        "${DateFormat("d MMM yyyy").format(to)}";
  }

  Future<void> selectFilterTab(String tab) async {
    setState(() {
      activeFilterTab = tab;

      final range = getRangeForTab(tab);

      materialDashboardController.entryFromDate.text = formatDate(range.start);

      materialDashboardController.entryToDate.text = formatDate(range.end);

      rangeLabel = formatRangeLabel(
        range.start,
        range.end,
      );
    });
    if (materialDashboardController.selectedTab.value == 0) {
      await materialDashboardController.getMatProjWiseDashboardDetails();
    }else if (materialDashboardController.selectedTab.value == 1) {
      await materialDashboardController.getMatHeadDashboardDetails();
    }else{

    }  }

  void resetDateToToday() {
    final today = DateTime.now();

    materialDashboardController.entryFromDate.text =
        formatDate(today);

    materialDashboardController.entryToDate.text =
        formatDate(today);

    rangeLabel = formatRangeLabel(today, today);

    activeFilterTab = "today";
  }

  Widget durationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "DURATION",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: Color(0xff667085),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filterTabs.map((tab) {
                    final key = tab["key"]!;
                    final label = tab["label"]!;

                    final isSelected = activeFilterTab == key;

                    return GestureDetector(
                      onTap: () {
                        selectFilterTab(key);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xff475467),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        customDateFilter(),
      ],
    );
  }

  Widget customDateFilter() {
    return Row(
      children: [
        const Text(
          "CUSTOM RANGE",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: Color(0xff667085),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _compactDateField(
            controller: materialDashboardController.entryFromDate,
            onTap: () => selectCustomFromDate(),
          ),
        ),
        const SizedBox(width: 6),
        const Icon(
          Icons.arrow_forward,
          size: 15,
          color: Color(0xff98A2B3),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _compactDateField(
            controller: materialDashboardController.entryToDate,
            onTap: () => selectCustomToDate(),
          ),
        ),
      ],
    );
  }

  Widget _compactDateField({required TextEditingController controller, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xffD0D5DD),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                controller.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff344054),
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 13,
              color: Color(0xff98A2B3),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectCustomFromDate() async {
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
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        activeFilterTab = "custom";

        materialDashboardController.entryFromDate.text =
            date.toString().substring(0, 10);

        updateCustomRangeLabel();
      });
    }
  }

  Future<void> selectCustomToDate() async {
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
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        activeFilterTab = "custom";

        materialDashboardController.entryToDate.text =
            date.toString().substring(0, 10);

        updateCustomRangeLabel();
      });
    }
  }

  void updateCustomRangeLabel() {
    try {
      final from = DateFormat("dd-MM-yyyy").parse(
        materialDashboardController.entryFromDate.text,
      );

      final to = DateFormat("dd-MM-yyyy").parse(
        materialDashboardController.entryToDate.text,
      );

      rangeLabel = formatRangeLabel(from, to);
    } catch (_) {
      rangeLabel = "";
    }
  }

  List<GreetingCardModel> get greetingCards {
    final data = materialDashboardController.projectWiseResponse.value?.result;

    return [
      GreetingCardModel(
        title: "ACTIVE PROJECTS",
        value: "${data?.activeprojectCounts ?? 0}",
        icon: Icons.account_tree,
      ),
      GreetingCardModel(
        title: "SUPPLIERS",
        value: "${data?.activeSuppliers ?? 0}",
        icon: Icons.local_shipping,
      ),
      GreetingCardModel(
        title: "MATERIAL HEADS",
        value: "${data?.activeMaterialHeads ?? 0}",
        icon: Icons.layers_outlined,
      ),
    ];
  }

  List<GreetingCardModel> get gridInfoCardsProjWise {
    final data = materialDashboardController.projectWiseResponse.value?.result;

    return [
      GreetingCardModel(
          title: "TOTAL PO VALUE",
          subtitle: "51 Active Projects",
          value: "${data?.poTotalValue ?? 0}",
          icon: Icons.content_copy_rounded,
          color: Colors.blueAccent),
      GreetingCardModel(
          title: "TOTAL BILLED",
          subtitle: "Bills Received",
          value: "${data?.totalBilledAmount ?? 0}",
          icon: Icons.poll_outlined,
          color: Colors.green),
      GreetingCardModel(
          title: "UNBILLED AMOUNT",
          subtitle: "Yet to be Billed",
          value: "${data?.unBilledAmount ?? 0}",
          icon: Icons.description_outlined,
          color: Colors.orange),
      GreetingCardModel(
          title: "OVER-BILLED",
          subtitle: "Bills Exceed PO",
          value: "${data?.overBilledAmount ?? 0}",
          icon: Icons.lock,
          color: Colors.pink),
      GreetingCardModel(
          title: "BILLS APPROVED",
          subtitle: "Ready for Payment",
          value: "${data?.totalBillApproved ?? 0}",
          icon: Icons.check_circle,
          color: Colors.deepPurpleAccent),
      GreetingCardModel(
          title: "BILLS PENDING",
          subtitle: "Under Review",
          value: "${data?.totalBillPending ?? 0}",
          icon: Icons.access_time_filled,
          color: Colors.red)
    ];
  }

  List<GreetingCardModel> get gridInfoCardsMatHead {
    final data = materialDashboardController.materialHeadResponse.value?.result;

    return [
      GreetingCardModel(
          title: "ACTIVE HEADS",
          subtitle: "Material head types",
          value: "${data?.activeMaterialHeadCount ?? 0}",
          icon: Icons.business,
          color: const Color(0xff2563EB)),
      GreetingCardModel(
          title: "HIGHEST NET AMOUNT",
          subtitle:  data?.highestMatHead ?? "",
          value: "₹ ${data?.highestTotalNetAmount ?? 0}",
          icon: Icons.money,
          color: const Color(0xff16A34A)),
      GreetingCardModel(
          title: "OVER-BILLED HEADS",
          subtitle: "Heads exceeding PO",
          value: "${data?.overBilledMaterialHeadCount ?? 0}",
          icon: Icons.warning,
          color: const Color(0xffF43F5E)),
      GreetingCardModel(
          title: "AVG BILLING %",
          subtitle: "Across all heads",
          value: "${data?.avgBillPercent ?? 0}",
          icon: Icons.percent,
          color: const Color(0xff2563EB)),
      GreetingCardModel(
          title: "PENDING BILL",
          subtitle: "Yet to be approved",
          value: "₹ ${data?.pendingBillAmount ?? 0}",
          icon: Icons.request_quote,
          color: const Color(0xff16A34A)),
      GreetingCardModel(
          title: "BEST BILLED HEAD",
          subtitle: data?.mostMatchingHead ?? "",
          value: "${data?.mostMatchingHeadPercentage ?? 0}",
          icon: Icons.star,
          color: const Color(0xffE11D48))
    ];
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 45,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildItem({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: (valueColor ?? Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialHomeScreen extends StatefulWidget {
  final bool isMaterial;
  const MaterialHomeScreen({
    super.key,
    this.isMaterial = false,
  });

  @override
  State<MaterialHomeScreen> createState() => _MaterialHomeScreenState();
}

class GreetingCardModel {
  final String? title;
  final String? value;
  final IconData? icon;
  final String? subtitle;
  final Color? color;

  GreetingCardModel({
    this.title,
    this.value,
    this.icon,
    this.subtitle,
    this.color,
  });
}

class GreetingCard extends StatelessWidget {
  final GreetingCardModel item;
  final int index;

  const GreetingCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Icon Box
        Container(
          height: 40,
          width: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            item.icon,
            color: Colors.white,
            size: 18,
          ),
        ),

        const SizedBox(width: 8),

        /// Text Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.value!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.title!.toUpperCase(),
                maxLines: 2,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white.withOpacity(.9),
                  fontWeight: FontWeight.w700,
                  letterSpacing: .3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GridInfoCard extends StatelessWidget {
  final GreetingCardModel item;
  final int index;

  const GridInfoCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON + TITLE
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: item.color!.withOpacity(.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 21,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title!.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .3,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// VALUE
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              item.value!,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 5),

          /// SUBTITLE
          Text(
            item.subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
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
    this.radius = 4,
  });

  @override
  Widget build(BuildContext context) {
    final activeSegments = (progress * totalSegments).round();

    return Row(
      children: List.generate(
        totalSegments * 2 - 1,
        (index) {
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
        },
      ),
    );
  }
}

class ChevronProgressIndicator extends StatelessWidget {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final int segments;

  const ChevronProgressIndicator({
    super.key,
    required this.progress,
    required this.activeColor,
    this.inactiveColor = const Color(0xFFE5E7EB),
    this.segments = 16,
  });

  @override
  Widget build(BuildContext context) {
    final value = progress.clamp(0.0, 1.0);

    final completedSegments = (value * segments).round();

    return SizedBox(
      height: 28,
      child: Row(
        children: List.generate(
          segments,
          (index) {
            final isActive = index < completedSegments;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: CustomPaint(
                  size: const Size(18, 16),
                  painter: ChevronPainter(
                    color: isActive ? activeColor : inactiveColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChevronPainter extends CustomPainter {
  final Color color;

  ChevronPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);

    path.lineTo(size.width * 0.65, 0);

    path.lineTo(size.width, size.height / 2);

    path.lineTo(size.width * 0.65, size.height);

    path.lineTo(0, size.height);

    path.lineTo(size.width * 0.35, size.height / 2);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ChevronPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
