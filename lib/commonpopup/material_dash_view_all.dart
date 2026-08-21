import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/material_dashboard_controller.dart';
import '../newhome/maindashboard/material_dashboard.dart';

class POVsBillListViewAll extends StatefulWidget {

  const POVsBillListViewAll({Key? key})
      : super(key: key);

  @override
  State<POVsBillListViewAll> createState() => _POVsBillListViewAllState();
}

class _POVsBillListViewAllState extends State<POVsBillListViewAll> {
  MaterialDashboardController materialDashboardController = Get.put(MaterialDashboardController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        materialDashboardController.poVsBillTableList
            .assignAll(materialDashboardController.allPoVsBillTableList);
        searchController.clear();
        materialDashboardController.selectedStatus.value = "All Status";
        return true;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "PO Value vs Billed Amount",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false, // Hide left back button
            actions: [
              TextButton(
                  onPressed: () {
                    materialDashboardController.poVsBillTableList.assignAll(
                        materialDashboardController.allPoVsBillTableList);
                    searchController.clear();
                    materialDashboardController.selectedStatus.value =
                    "All Status";
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ))
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        width: 150,
                        child: TextField(
                            controller: searchController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Search",
                              hintStyle: TextStyle(fontSize: 14),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey, // Purple when focused
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              materialDashboardController
                                  .filterPoVsBillValues(value);
                            }),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Obx(() => SizedBox(
                    //   width: 180,
                    //   height: 42,
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton2<String>(
                    //       isExpanded: true,
                    //       alignment: Alignment.centerLeft,
                    //       hint: const Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Text(
                    //           "All",
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //       ),
                    //       items: materialDashboardController.poVsBillStatusList
                    //           .map((status) => DropdownMenuItem<String>(
                    //         value: status,
                    //         child: Align(
                    //           alignment: Alignment.centerLeft,
                    //           child: Text(
                    //             status,
                    //             maxLines: 2,
                    //             overflow: TextOverflow.ellipsis,
                    //             style:
                    //             const TextStyle(fontSize: 12),
                    //           ),
                    //         ),
                    //       ))
                    //           .toList(),
                    //       value: materialDashboardController.selectedStatus.value,
                    //       onChanged: (value) {
                    //         materialDashboardController.selectedStatus.value =
                    //         value!;
                    //         materialDashboardController.filterProjects();
                    //       },
                    //       buttonStyleData: ButtonStyleData(
                    //         height: 42,
                    //         padding:
                    //         const EdgeInsets.symmetric(horizontal: 12),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(12),
                    //           border: Border.all(
                    //             color: Colors.grey,
                    //             width: 1,
                    //           ),
                    //         ),
                    //       ),
                    //       iconStyleData: const IconStyleData(
                    //         icon: Icon(Icons.arrow_drop_down),
                    //         iconSize: 22,
                    //         iconEnabledColor: Colors.grey,
                    //       ),
                    //       dropdownStyleData: DropdownStyleData(
                    //         maxHeight: 220,
                    //         offset: const Offset(0, 2),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         elevation: 4,
                    //       ),
                    //       menuItemStyleData: const MenuItemStyleData(
                    //         height: 40,
                    //         padding: EdgeInsets.symmetric(horizontal: 12),
                    //       ),
                    //     ),
                    //   ),
                    // ))
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Obx(() => ListView.separated(
                  padding: EdgeInsets.all(12),
                  shrinkWrap: true,
                  itemCount: materialDashboardController.poVsBillTableList.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = materialDashboardController.poVsBillTableList[index];
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
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.red.withOpacity(0.18),
                                      Colors.blueAccent.withOpacity(0.06),
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
                                    child:  Text(
                                      "Bill: ₹${item.billAmountInLakhs!}",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SegmentedProgressBar(
                            progress: materialDashboardController.getProgress(
                              item.billAmountInLakhs,
                              item.poAmountInLakhs,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BillingCompletionViewAll extends StatefulWidget {

  const BillingCompletionViewAll({Key? key})
      : super(key: key);

  @override
  State<BillingCompletionViewAll> createState() => _BillingCompletionViewAllState();
}

class _BillingCompletionViewAllState extends State<BillingCompletionViewAll> {
  MaterialDashboardController materialDashboardController = Get.put(MaterialDashboardController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        materialDashboardController.billingCompletionList
            .assignAll(materialDashboardController.allBillingCompletionList);
        searchController.clear();
        materialDashboardController.selectedStatus.value = "All Status";
        return true;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Billing Completion",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false, // Hide left back button
            actions: [
              TextButton(
                  onPressed: () {
                    materialDashboardController.billingCompletionList.assignAll(
                        materialDashboardController.allBillingCompletionList);
                    searchController.clear();
                    materialDashboardController.selectedStatus.value =
                    "All Status";
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ))
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        width: 150,
                        child: TextField(
                            controller: searchController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Search",
                              hintStyle: TextStyle(fontSize: 14),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey, // Purple when focused
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              materialDashboardController
                                  .filterBillingValues(value);
                            }),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Obx(() => SizedBox(
                    //   width: 180,
                    //   height: 42,
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton2<String>(
                    //       isExpanded: true,
                    //       alignment: Alignment.centerLeft,
                    //       hint: const Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Text(
                    //           "All",
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //       ),
                    //       items: materialDashboardController.poVsBillStatusList
                    //           .map((status) => DropdownMenuItem<String>(
                    //         value: status,
                    //         child: Align(
                    //           alignment: Alignment.centerLeft,
                    //           child: Text(
                    //             status,
                    //             maxLines: 2,
                    //             overflow: TextOverflow.ellipsis,
                    //             style:
                    //             const TextStyle(fontSize: 12),
                    //           ),
                    //         ),
                    //       ))
                    //           .toList(),
                    //       value: materialDashboardController.selectedStatus.value,
                    //       onChanged: (value) {
                    //         materialDashboardController.selectedStatus.value =
                    //         value!;
                    //         materialDashboardController.filterProjects();
                    //       },
                    //       buttonStyleData: ButtonStyleData(
                    //         height: 42,
                    //         padding:
                    //         const EdgeInsets.symmetric(horizontal: 12),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(12),
                    //           border: Border.all(
                    //             color: Colors.grey,
                    //             width: 1,
                    //           ),
                    //         ),
                    //       ),
                    //       iconStyleData: const IconStyleData(
                    //         icon: Icon(Icons.arrow_drop_down),
                    //         iconSize: 22,
                    //         iconEnabledColor: Colors.grey,
                    //       ),
                    //       dropdownStyleData: DropdownStyleData(
                    //         maxHeight: 220,
                    //         offset: const Offset(0, 2),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         elevation: 4,
                    //       ),
                    //       menuItemStyleData: const MenuItemStyleData(
                    //         height: 40,
                    //         padding: EdgeInsets.symmetric(horizontal: 12),
                    //       ),
                    //     ),
                    //   ),
                    // ))
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Obx(() => ListView.separated(
                  padding: EdgeInsets.all(12),
                  shrinkWrap: true,
                  itemCount: materialDashboardController.billingCompletionList.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                   final item = materialDashboardController.billingCompletionList[index];
                    final percentage = item.billingCompletionPercentage ?? 0.0;
                    final progress = (percentage / 100).clamp(0.0, 1.0);
                    final progressColor = materialDashboardController.getProgressColor(percentage);
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
                        child:Row(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name + Percentage
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.projectName!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      Text(
                                        "${item.billingCompletionPercentage ?? 0} %",
                                        style:  TextStyle(
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
                        )
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class POVsBillRegViewAll extends StatefulWidget {

  const POVsBillRegViewAll({Key? key})
      : super(key: key);

  @override
  State<POVsBillRegViewAll> createState() => _POVsBillRegViewAllState();
}

class _POVsBillRegViewAllState extends State<POVsBillRegViewAll> {
  MaterialDashboardController materialDashboardController = Get.put(MaterialDashboardController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        materialDashboardController.billingCompletionList
            .assignAll(materialDashboardController.allBillingCompletionList);
        searchController.clear();
        materialDashboardController.selectedStatus.value = "All Status";
        return true;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Project PO vs Bill Register",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false, // Hide left back button
            actions: [
              TextButton(
                  onPressed: () {
                    materialDashboardController.billingCompletionList.assignAll(
                        materialDashboardController.allBillingCompletionList);
                    searchController.clear();
                    materialDashboardController.selectedStatus.value =
                    "All Status";
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ))
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        width: 150,
                        child: TextField(
                            controller: searchController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Search",
                              hintStyle: TextStyle(fontSize: 14),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey, // Purple when focused
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              materialDashboardController
                                  .filterPOVsBillRegValues(value);
                            }),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Obx(() => SizedBox(
                    //   width: 180,
                    //   height: 42,
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton2<String>(
                    //       isExpanded: true,
                    //       alignment: Alignment.centerLeft,
                    //       hint: const Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Text(
                    //           "All",
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //       ),
                    //       items: materialDashboardController.poVsBillStatusList
                    //           .map((status) => DropdownMenuItem<String>(
                    //         value: status,
                    //         child: Align(
                    //           alignment: Alignment.centerLeft,
                    //           child: Text(
                    //             status,
                    //             maxLines: 2,
                    //             overflow: TextOverflow.ellipsis,
                    //             style:
                    //             const TextStyle(fontSize: 12),
                    //           ),
                    //         ),
                    //       ))
                    //           .toList(),
                    //       value: materialDashboardController.selectedStatus.value,
                    //       onChanged: (value) {
                    //         materialDashboardController.selectedStatus.value =
                    //         value!;
                    //         materialDashboardController.filterProjects();
                    //       },
                    //       buttonStyleData: ButtonStyleData(
                    //         height: 42,
                    //         padding:
                    //         const EdgeInsets.symmetric(horizontal: 12),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(12),
                    //           border: Border.all(
                    //             color: Colors.grey,
                    //             width: 1,
                    //           ),
                    //         ),
                    //       ),
                    //       iconStyleData: const IconStyleData(
                    //         icon: Icon(Icons.arrow_drop_down),
                    //         iconSize: 22,
                    //         iconEnabledColor: Colors.grey,
                    //       ),
                    //       dropdownStyleData: DropdownStyleData(
                    //         maxHeight: 220,
                    //         offset: const Offset(0, 2),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         elevation: 4,
                    //       ),
                    //       menuItemStyleData: const MenuItemStyleData(
                    //         height: 40,
                    //         padding: EdgeInsets.symmetric(horizontal: 12),
                    //       ),
                    //     ),
                    //   ),
                    // ))
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Obx(() => ListView.separated(
                  padding: EdgeInsets.all(12),
                  shrinkWrap: true,
                  itemCount: materialDashboardController.poVsBillRegList.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = materialDashboardController.poVsBillRegList[index];
                    final statusColor = materialDashboardController.getStatusColor(item.billingStatus);
                    final percentage = item.billingPercentage ?? 0.0;
                    final progressColor = materialDashboardController.getProgressColor(percentage);
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ───────── HEADER ROW ─────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    const Icon(Icons.location_on, color: Colors.red, size: 15),
                                    const SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                        item.address ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                        value: "${item.poAmountInLakhs}",
                                        valueColor: Colors.blueAccent,
                                      ),
                                    ),
                                    _buildDivider(),
                                    Expanded(
                                      child: _buildItem(
                                        title: "Billed",
                                        value: "${item.billAmountInLakhs}",
                                        valueColor: const Color(0xFF10B981),
                                      ),
                                    ),
                                    _buildDivider(),
                                    Expanded(
                                      child: _buildItem(
                                        title: "Approved",
                                        value: "${item.billAmountInLakhs}",
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
                                        value: "${item.unbilledAmountInLakhs}",
                                        valueColor: Colors.brown.shade400,
                                      ),
                                    ),
                                    _buildDivider(),
                                    Expanded(
                                      child: _buildItem(
                                        title: "Over-Bill",
                                        value: "${item.overBillAmountInLakhs}",
                                        valueColor: Colors.red,
                                      ),
                                    ),
                                    _buildDivider(),
                                    Expanded(
                                      child: _buildItem(
                                        title: "Billing %",
                                        value: "${item.billingPercentage} %",
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
                )),
              ),
            ],
          ),
        ),
      ),
    );
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
                color:  (valueColor ?? Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedProgressBar extends StatefulWidget {
  final double progress;
  final Color progressColor;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.progressColor,
  });

  @override
  State<AnimatedProgressBar> createState() =>
      _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Delay before animation starts
    Future.delayed(
      const Duration(milliseconds: 300),
          () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          height: 12,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final progressWidth =
                  constraints.maxWidth * _animation.value;

              return Stack(
                alignment: Alignment.centerLeft,
                children: [

                  // Background
                  Container(
                    width: double.infinity,
                    height: 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),

                  // Progress
                  Container(
                    width: progressWidth,
                    height: 9,
                    decoration: BoxDecoration(
                      color: widget.progressColor,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),

                ],
              );
            },
          ),
        );
      },
    );
  }
}