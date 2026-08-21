import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:anusamm/controller/hrDashboard_controller.dart';
import '../models/hrDashboardCardsRes.dart';

class EmployeeListDialog extends StatefulWidget {
  final String title;
  final List<Employee> employees;
  final IconData icon;
  final Color color;

  const EmployeeListDialog({
    super.key,
    required this.title,
    required this.employees,
    required this.icon,
    required this.color,
  });

  @override
  State<EmployeeListDialog> createState() =>
      _EmployeeListDialogState();
}

class _EmployeeListDialogState extends State<EmployeeListDialog> {
  final TextEditingController searchController = TextEditingController();
  HrDashboardController hrDashboardController = Get.put(HrDashboardController());
  List<Employee> filteredEmployees = [];

  @override
  void initState() {
    super.initState();

    filteredEmployees = List.from(widget.employees);

    searchController.addListener(_searchEmployees);
  }

  void _searchEmployees() {
    final search = searchController.text.trim().toLowerCase();

    setState(() {
      if (search.isEmpty) {
        filteredEmployees = List.from(widget.employees);
      } else {
        filteredEmployees = widget.employees.where((employee) {
          final name = employee.employeeName
              ?.toLowerCase() ??
              "";

          return name.contains(search);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String getInitials(String name) {
    final parts = name.trim().split(" ");

    if (parts.length == 1) {
      return parts.first.isNotEmpty
          ? parts.first[0].toUpperCase()
          : "";
    }

    return (
        parts.first.isNotEmpty ? parts.first[0] : ""
    ) +
        (
            parts.length > 1 && parts.last.isNotEmpty
                ? parts.last[0]
                : ""
        ).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// HEADER
        Container(
          // padding: const EdgeInsets.fromLTRB(
          //   24,
          //   16,
          //   16,
          //   16,
          // ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1F2937),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      "Employee List (${hrDashboardController.entryFromDate.text} - ${hrDashboardController.entryToDate.text})",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey.shade500,
                  size: 22,
                ),
              ),
            ],
          ),
        ),

        /// SEARCH
        Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            8,
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search employee by name...",
              hintStyle: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: Colors.grey.shade500,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  size: 18,
                ),
                onPressed: () {
                  searchController.clear();
                },
              )
                  : null,
              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xff4F46E5),
                ),
              ),
            ),
          ),
        ),

        /// TABLE HEADER
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffF8FAFC),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  "#",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff64748B),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Employee Name",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff64748B),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// EMPLOYEE LIST
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey.shade300,
                ),
                right: BorderSide(
                  color: Colors.grey.shade300,
                ),
                // bottom: BorderSide(
                //   color: Colors.grey.shade300,
                // ),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: filteredEmployees.isEmpty
                ? Center(
              child: Text(
                "No Record Found",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
            )
                : ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee =
                filteredEmployees[index];

                final name =
                    employee.employeeName ?? "";

                return Container(
                  height: 50,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      // bottom: BorderSide(
                      //   color: Colors.grey.shade100,
                      // ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            fontSize: 13,
                            color:
                            Color(0xff94A3B8),
                          ),
                        ),
                      ),

                      Container(
                        height: 32,
                        width: 32,
                        decoration:
                         BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.color.withOpacity(0.10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          getInitials(name),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                            FontWeight.w600,
                            color:
                            widget.color,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                            color:
                            Color(0xff111827),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 5),
      ],
    );
  }
}