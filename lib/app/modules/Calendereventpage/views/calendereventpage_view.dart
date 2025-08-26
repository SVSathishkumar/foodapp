import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/Calendereventpage/controllers/calendereventpage_controller.dart';
import 'package:foodapp/widgets/AddEventPopup.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendereventpageView extends GetView<CalendereventpageController> {
  final CalendereventpageController controller = Get.put(
    CalendereventpageController(),
  );

  CalendereventpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: isDark
                        ? const Color.fromARGB(255, 245, 206, 87)
                        : Colors.pink,
                    size: screenWidth * 0.06,
                  ),
                ),
              ),

              // Calendar
              Container(
                margin: EdgeInsets.all(screenWidth * 0.03),
                padding: EdgeInsets.all(screenWidth * 0.025),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black45 : Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Obx(
                  () => TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: controller.focusedDay.value,
                    calendarFormat: controller.calendarFormat.value,
                    selectedDayPredicate: (day) =>
                        isSameDay(controller.selectedDay.value, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      controller.selectDay(selectedDay, focusedDay);
                    },
                    eventLoader: (day) => controller.events[day] ?? [],
                    calendarStyle: CalendarStyle(
                      defaultDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        color: isDark
                            ? Colors.grey.shade800
                            : const Color.fromARGB(255, 238, 237, 237),
                      ),
                      selectedDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        color: isDark
                            ? const Color.fromARGB(255, 247, 208, 91)
                            : Colors.pink,
                      ),
                      todayDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        color: Colors.deepOrange,
                      ),
                      markersAlignment: Alignment.bottomCenter,
                      markerDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          screenWidth * 0.015,
                        ),
                        color: Colors.redAccent,
                      ),
                      defaultTextStyle: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.04,
                      ),
                      weekendTextStyle: TextStyle(
                        color: isDark ? Colors.red[200] : Colors.red[700],
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),

                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Event List
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: isDark
                    //       ? Colors.pink
                    //       : const Color.fromARGB(255, 248, 208, 89),
                    // ),
                    color: isDark ? Colors.grey[900] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Obx(() {
                    var selectedEvents =
                        controller.events[controller.selectedDay.value] ?? [];

                    if (selectedEvents.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy_rounded,
                              size: screenWidth * 0.18,
                              color: isDark
                                  ? Colors.grey[500]
                                  : Colors.grey[400],
                            ),
                            SizedBox(height: screenWidth * 0.03),
                            Text(
                              'No Events Scheduled',
                              style: GoogleFonts.poppins(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.01),
                            Text(
                              'Tap the + button to add a new event',
                              style: GoogleFonts.poppins(
                                color: isDark
                                    ? Colors.grey[500]
                                    : Colors.grey[500],
                                fontSize: screenWidth * 0.032,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: selectedEvents.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: screenWidth * 0.03),
                      itemBuilder: (context, index) {
                        var event = selectedEvents[index];

                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.04,
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? const Color.fromARGB(255, 247, 210, 97)
                                  : Colors.pink,
                              width: 1.2,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔹 Header Row (Event Icon + Title + Delete)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isDark
                                          ? const Color.fromARGB(
                                              255,
                                              248,
                                              208,
                                              89,
                                            )
                                          : Colors.pink,
                                      radius: screenWidth * 0.05,
                                      child: Icon(
                                        Icons.event,
                                        color: Colors.white,
                                        size: screenWidth * 0.05,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.03),
                                    Expanded(
                                      child: Text(
                                        event["eventName"] ?? "No Title",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: screenWidth * 0.038,
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_forever_rounded,
                                        color: Colors.redAccent,
                                        size: screenWidth * 0.07,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: Get.context!,
                                          builder: (context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      screenWidth * 0.03,
                                                    ),
                                                side: BorderSide(
                                                  color: Colors.redAccent,
                                                  width: 2,
                                                ),
                                              ),
                                              backgroundColor: isDark
                                                  ? Colors.grey[900]
                                                  : Colors.white,
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  screenWidth * 0.04,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Delete Event",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                screenWidth *
                                                                0.036,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    SizedBox(height: 12),
                                                    Text(
                                                      "Are you sure you want to delete\nthis event?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: isDark
                                                                ? Colors.white70
                                                                : Colors
                                                                      .black87,
                                                            fontSize:
                                                                screenWidth *
                                                                0.032,
                                                            height: 1.4,
                                                          ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                          style: TextButton.styleFrom(
                                                            backgroundColor:
                                                                isDark
                                                                ? Colors.pink
                                                                : const Color.fromARGB(
                                                                    255,
                                                                    248,
                                                                    206,
                                                                    81,
                                                                  ),
                                                          ),
                                                          onPressed: () =>
                                                              Get.back(),
                                                          child: Text(
                                                            "Cancel",
                                                            style: GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  screenWidth *
                                                                  0.031,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            controller
                                                                .events[controller
                                                                    .selectedDay
                                                                    .value]
                                                                ?.removeAt(
                                                                  index,
                                                                );
                                                            controller.events
                                                                .refresh();
                                                            Get.back();
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                isDark
                                                                ? const Color.fromARGB(
                                                                    255,
                                                                    245,
                                                                    204,
                                                                    81,
                                                                  )
                                                                : Colors.pink,
                                                          ),
                                                          child: Text(
                                                            "Delete",
                                                            style: GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  screenWidth *
                                                                  0.032,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height: screenWidth * 0.02),

                                // 🔹 User Info Row
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: screenWidth * 0.05,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.blueGrey,
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        event["name"] ?? "Unknown",
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.033,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.blueGrey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 6),

                                // 🔹 Phone Row
                                GestureDetector(
                                  onTap: () async {
                                    if (event["phone"] != null &&
                                        event["phone"].toString().isNotEmpty) {
                                      final Uri phoneUri = Uri(
                                        scheme: "tel",
                                        path: event["phone"],
                                      );
                                      if (await canLaunchUrl(phoneUri)) {
                                        await launchUrl(phoneUri);
                                      } else {
                                        Get.snackbar(
                                          "Error",
                                          "Cannot launch dialer",
                                        );
                                      }
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: screenWidth * 0.05,
                                        color: isDark
                                            ? Colors.lightGreen
                                            : Colors.green,
                                      ),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          event["phone"] ?? "N/A",
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.033,
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.blueGrey[700],
                                          ),
                                        ),
                                      ),
                                      if (event["phone"] != null &&
                                          event["phone"].toString().isNotEmpty)
                                        Icon(
                                          Icons.call,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.pink,
                                          size: screenWidth * 0.06,
                                        ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 6),

                                // 🔹 Description Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.description,
                                      size: screenWidth * 0.05,
                                      color: isDark
                                          ? Colors.pink
                                          : Colors.orange,
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        event["description"] ??
                                            "No Description",
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.033,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.blueGrey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => AddEventPopup.show(controller),
        backgroundColor: isDark
            ? const Color.fromARGB(255, 247, 207, 87)
            : Colors.pink,
        child: Icon(Icons.add, color: Colors.white, size: screenWidth * 0.07),
      ),
    );
  }
}
