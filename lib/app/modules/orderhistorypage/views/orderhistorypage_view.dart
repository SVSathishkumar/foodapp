import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/categorypage/views/categorypage_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deleteable_tile/deleteable_tile.dart';
import '../controllers/orderhistorypage_controller.dart';

class OrderhistorypageView extends GetView<OrderhistorypageController> {
  final List<dynamic> orders;

  const OrderhistorypageView({super.key, this.orders = const []});

  /// Format date safely
  String formatDate(dynamic date) {
    if (date == null) return "";

    DateTime? parsedDate;
    if (date is String) {
      parsedDate = DateTime.tryParse(date);
      if (parsedDate == null) return "";
    } else if (date is DateTime) {
      parsedDate = date;
    } else {
      return "";
    }

    return "${parsedDate.day} ${_monthName(parsedDate.month)}, ${parsedDate.year}";
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive values
    final double iconSize = width * 0.05; // back arrow size
    final double titleFont = width * 0.038; // card title
    final double smallFont = width * 0.032; // ID, date, etc.
    final double statusFont = width * 0.034;
    final double priceFont = width * 0.036;
    final double buttonFont = width * 0.034;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Custom AppBar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.015,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back,
                      color: isDark
                          ? const Color.fromARGB(255, 244, 206, 92)
                          : Colors.pink,
                      size: iconSize,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 Orders List
            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                              "assets/images/orderhistorylogo.png",
                              width: width * 0.3,
                              height: width * 0.3,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: width * 0.07),
                          Text(
                            "No orders\nLooks like you haven't placed any orders yet",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.030,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.015,
                      ),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final item = orders[index];
                        final orderId = item['orderId'] ?? "#${index + 1}";

                        Color borderColor;
                        switch (item['status']?.toLowerCase()) {
                          case 'completed':
                            borderColor = Colors.green;
                            break;
                          case 'cancelled':
                            borderColor = Colors.red;
                            break;
                          default:
                            borderColor = Colors.orange;
                        }

                        final deliveryDate = item['deliveryDate'];

                        return DeleteableTile(
                          key: ValueKey(orderId),
                          onDeleted: () {
                            orders.removeAt(index);
                            controller.update();
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: height * 0.022),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color.fromARGB(255, 21, 21, 21)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border(
                                left: BorderSide(color: borderColor, width: 5),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Title
                                  Text(
                                    item['title'] ?? 'Untitled',
                                    style: GoogleFonts.poppins(
                                      fontSize: titleFont,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),

                                  /// Order ID + Date + Status
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "ID: $orderId",
                                        style: GoogleFonts.poppins(
                                          fontSize: smallFont,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Ordered on ${formatDate(item['date'])}",
                                          style: GoogleFonts.poppins(
                                            fontSize: smallFont,
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        item['status'] ?? "Ongoing",
                                        style: GoogleFonts.poppins(
                                          fontSize: statusFont,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? (item['status']
                                                            ?.toLowerCase() ==
                                                        'completed'
                                                    ? Colors.green
                                                    : item['status']
                                                              ?.toLowerCase() ==
                                                          'cancelled'
                                                    ? Colors.red
                                                    : Colors.pink)
                                              : (item['status']
                                                            ?.toLowerCase() ==
                                                        'completed'
                                                    ? Colors.green
                                                    : item['status']
                                                              ?.toLowerCase() ==
                                                          'cancelled'
                                                    ? Colors.red
                                                    : Colors.amber),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.015),

                                  /// Price
                                  Text(
                                    "Price - ${item['unitPrice'] ?? '0'}",
                                    style: GoogleFonts.poppins(
                                      fontSize: priceFont,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.pink,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),

                                  /// Delivery Date
                                  if (deliveryDate != null)
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_shipping,
                                          size: width * 0.045,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: width * 0.015),
                                        Text(
                                          "Delivery by ${formatDate(deliveryDate)}",
                                          style: GoogleFonts.poppins(
                                            fontSize: smallFont,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: height * 0.01),

                                  /// 🔹 Reorder Button
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => CategorypageView());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDark
                                            ? const Color.fromARGB(
                                                255,
                                                239,
                                                201,
                                                88,
                                              )
                                            : Colors.pink,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.05,
                                          vertical: height * 0.012,
                                        ),
                                      ),
                                      child: Text(
                                        "Reorder",
                                        style: GoogleFonts.poppins(
                                          fontSize: buttonFont,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
