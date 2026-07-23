import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:anusamm/controller/labourDashboard_controller.dart';

import '../utilities/baseutitiles.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<AttendanceListScreen> createState() =>
      _AttendanceListScreenState();
}

class _AttendanceListScreenState
    extends State<AttendanceListScreen> {

  LabourDashboardController labourDashboardController = Get.put(LabourDashboardController());

  final TextEditingController searchController =
  TextEditingController();

  String filterValue = "All";

  List<Map<String, dynamic>> attendanceList = List.generate(
    20,
        (index) => {
      "attendanceNo": "LAT/26-27/0144$index",
      "date": "20-07-2026",
      "project": "Sakthi College ",
      "site": "New Mess Block",
      "subcontractor": "Nagarajan",
      "labour": 4 + index,
      "amount": 3500 + index * 150,
      "preparedBy": "Admin",
    },
  );

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: Scaffold(

        backgroundColor: const Color(0xffF5F7FB),

        appBar: AppBar(
          elevation: 0,
          title: const Text("Subcontractor Attendance"),
          backgroundColor: Color(0xFF7C3AED),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              Row(
                children: [

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          "All Records",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Attendance History",
                          style: TextStyle(
                              color: Colors.grey),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10),
                    decoration: BoxDecoration(
                      color:  Color(0xFF7C3AED).withOpacity(.5),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    child: Obx(() => Text(
                      "Total ${labourDashboardController.todayAttendanceList.length}",
                      style: const TextStyle(color: Colors.white),
                    ))
                  )

                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        controller: searchController,

                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Search",
                          prefixIcon:
                          const Icon(Icons.search),
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
                              color: Color(0xFF7C3AED), // Purple when focused
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                          onChanged: (value) {
                            labourDashboardController.filterAttendance(value);
                          }
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Obx(() =>
                     SizedBox(
                      width: 180,
                      height: 42,
                      child: DropdownButtonFormField<String>(
                        value: filterValue,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          filled: true,
                          isDense: true,
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
                              color: Color(0xFF7C3AED), // Purple when focused
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                        items: labourDashboardController.projectList
                            .map(
                              (project) => DropdownMenuItem<String>(
                            value: project,
                            child: SizedBox(
                              width: 120,
                              child: Text(project,      maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            filterValue = value!;
                          });
                          labourDashboardController.filterByProject(filterValue);
                        },

                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(15),
                  ),

                  child: Column(
                    children: [
                      /// Header
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 1035,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Header
                                Table(
                                  border: TableBorder.all(color: Color(0xFF7C3AED)),
                                  columnWidths: const {
                                    0: FixedColumnWidth(135),
                                    1: FixedColumnWidth(90),
                                    2: FixedColumnWidth(200),
                                    3: FixedColumnWidth(180),
                                    4: FixedColumnWidth(150),
                                    5: FixedColumnWidth(70),
                                    6: FixedColumnWidth(90),
                                    7: FixedColumnWidth(120),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF7C3AED).withOpacity(.5),
                                      ),
                                      children: const [
                                        HeaderCell("Attendance\nNo"),
                                        HeaderCell("Date"),
                                        HeaderCell("Project"),
                                        HeaderCell("Site"),
                                        HeaderCell("Subcontractor"),
                                        HeaderCell("Labour"),
                                        HeaderCell("Amount"),
                                        HeaderCell("Prepared By"),
                                      ],
                                    ),
                                  ],
                                ),

                                Expanded(
                                  child: Obx(() =>
                                     ListView.builder(
                                      itemCount: labourDashboardController.todayAttendanceList.length,
                                      itemBuilder: (context, index) {

                                        final item = labourDashboardController.todayAttendanceList[index];

                                        return Table(
                                          border: TableBorder.all(
                                            color: Colors.grey.shade500,
                                          ),
                                          columnWidths: const {
                                            0: FixedColumnWidth(135),
                                            1: FixedColumnWidth(90),
                                            2: FixedColumnWidth(200),
                                            3: FixedColumnWidth(180),
                                            4: FixedColumnWidth(150),
                                            5: FixedColumnWidth(70),
                                            6: FixedColumnWidth(90),
                                            7: FixedColumnWidth(120),
                                          },
                                          children: [

                                            TableRow(
                                              decoration: BoxDecoration(
                                                color: index.isEven
                                                    ? Colors.white
                                                    : Colors.grey.shade50,
                                              ),
                                              children: [

                                                TableCellWidget(item.labourAttendanceNo ?? ""),

                                                TableCellWidget(item.labourAttendanceDate != null
                                                    ? DateFormat('yyyy-MM-dd').format(
                                                  DateTime.parse(item.labourAttendanceDate!),
                                                )
                                                    : "",),

                                                TableCellWidget(item.projectName ?? ""),

                                                TableCellWidget(item.siteName ?? ""),

                                                TableCellWidget(item.subContractorName ?? ""),

                                                TableCellWidget(
                                                  item.totNos?.toStringAsFixed(0) ?? "0",),

                                                TableCellWidget(
                                                  "₹${item.totAmt?.toStringAsFixed(2) ?? "0.00"}",
                                                  color: Colors.green,
                                                  isBold: true,
                                                ),

                                                TableCellWidget(item.employeeName ?? ""),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

class HeaderCell extends StatelessWidget {
  final String text;

  const HeaderCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class TableCellWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isBold;

  const TableCellWidget(
      this.text, {
        super.key,
        this.color,
        this.isBold = false,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        softWrap: true,
        style: TextStyle(
          color: color ?? Colors.black,
          fontWeight:
          isBold ? FontWeight.bold : FontWeight.normal,fontSize: 13
        ),
      ),
    );
  }
}