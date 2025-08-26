import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/bottomnavgationbar/views/bottomnavgationbar_view.dart';
import 'package:foodapp/app/modules/orderconfrompageview/controllers/orderconfrompageview_controller.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:foodapp/app/modules/orderhistorypage/views/orderhistorypage_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class TrackingpageView extends StatefulWidget {
  final int currentStage;

  const TrackingpageView({super.key, this.currentStage = 0});

  @override
  State<TrackingpageView> createState() => _TrackingpageViewState();
}

class _TrackingpageViewState extends State<TrackingpageView> {
  final orderController = Get.find<OrderconfrompageviewController>();

  LatLng? destinationLatLng;
  final LatLng pickupLatLng = const LatLng(8.1782, 77.4280);
  GoogleMapController? mapController;

  late List cartItems;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    cartItems = args['cartItems'] ?? [];

    _getDeliveryCoordinates();
  }

  Future<void> _getDeliveryCoordinates() async {
    try {
      if (orderController.deliveryAddress.value.isNotEmpty) {
        List<Location> locations =
            await locationFromAddress(orderController.deliveryAddress.value);
        if (locations.isNotEmpty) {
          setState(() {
            destinationLatLng = LatLng(
              locations.first.latitude,
              locations.first.longitude,
            );
          });

          if (mapController != null) {
            mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(destinationLatLng!, 14),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
  }

  Future<void> _makeCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+919876543210');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint("Could not launch call");
    }
  }

  void _openHistory() {
    Get.to(() => OrderhistorypageView(orders: cartItems));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // MediaQuery breakpoints
    final bool isTablet = size.width >= 600 && size.width < 1024;
    final bool isWeb = size.width >= 1024;

    // Dynamic scaling
    double baseFont = isWeb
        ? 20
        : isTablet
            ? 16
            : 12;
    double paddingScale = isWeb
        ? 20
        : isTablet
            ? 14
            : 10;

    final List<String> steps = [
      "Order Placed",
      "Order Received",
      "Processing",
      "On the Way",
      "Delivered",
    ];

    final primaryColor =
        isDark ? const Color.fromARGB(255, 236, 193, 62) : Colors.pink;
    final cardBackground = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: Stack(
        children: [
          /// Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: pickupLatLng,
              zoom: 14,
            ),
            onMapCreated: (controller) => mapController = controller,
            markers: {
              Marker(
                markerId: const MarkerId('pickup'),
                position: pickupLatLng,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              ),
              if (destinationLatLng != null)
                Marker(
                  markerId: const MarkerId('destination'),
                  position: destinationLatLng!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
            },
            polylines: {
              if (destinationLatLng != null)
                Polyline(
                  polylineId: const PolylineId('route'),
                  color: Colors.green,
                  width: 4,
                  points: [pickupLatLng, destinationLatLng!],
                ),
            },
          ),

          /// Back button
          Positioned(
            top: size.height * 0.05,
            left: size.width * 0.04,
            child: CircleAvatar(
              backgroundColor: primaryColor,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Get.to(() => BottomnavigationbarView()),
              ),
            ),
          ),

          /// Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.2,
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(bottom: size.height * 0.01),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: size.height * 0.015),

                      /// Timeline
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: Column(
                          children: List.generate(steps.length, (index) {
                            bool isFirst = index == 0;
                            bool isLast = index == steps.length - 1;
                            bool isCompleted = index < widget.currentStage;
                            bool isCurrent = index == widget.currentStage;

                            Color indicatorColor;
                            if (isCompleted) {
                              indicatorColor = Colors.green;
                            } else if (isCurrent) {
                              indicatorColor = Colors.orange;
                            } else {
                              indicatorColor = Colors.grey;
                            }

                            return SizedBox(
                              height: isTablet ? 90 : isWeb ? 100 : 70,
                              child: TimelineTile(
                                isFirst: isFirst,
                                isLast: isLast,
                                axis: TimelineAxis.vertical,
                                alignment: TimelineAlign.start,
                                indicatorStyle: IndicatorStyle(
                                  width: isTablet ? 30 : 25,
                                  color: indicatorColor,
                                  iconStyle: IconStyle(
                                    iconData: isCompleted
                                        ? Icons.check
                                        : isCurrent
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                    color: Colors.white,
                                  ),
                                ),
                                beforeLineStyle: LineStyle(
                                  color:
                                      isCompleted ? Colors.green : Colors.white,
                                  thickness: 2,
                                ),
                                afterLineStyle: LineStyle(
                                  color: index <= widget.currentStage
                                      ? Colors.green
                                      : Colors.grey,
                                  thickness: 2,
                                ),
                                endChild: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    steps[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: baseFont,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      /// Info Tiles
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoTile(
                                Icons.access_time,
                                "DELIVERY TIME",
                                orderController.deliveryTime.value,
                                Colors.white,
                                baseFont,
                              ),
                              _buildInfoTile(
                                Icons.location_on,
                                "DELIVERY ADDRESS",
                                orderController.deliveryAddress.value,
                                Colors.white,
                                baseFont,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      /// Cart Items
                      Container(
                        width: size.width,
                        padding: EdgeInsets.all(paddingScale.toDouble()),
                        color: cardBackground,
                        child: cartItems.isEmpty
                            ? Text(
                                "No items in cart",
                                style: GoogleFonts.poppins(
                                  fontSize: baseFont,
                                  color: textColor.withOpacity(0.7),
                                ),
                              )
                            : Column(
                                children: List.generate(
                                  cartItems.length,
                                  (index) {
                                    final item = cartItems[index];
                                    return Container(
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isDark
                                              ? const Color.fromARGB(
                                                  255, 242, 199, 70)
                                              : const Color.fromARGB(
                                                  255, 237, 89, 138),
                                        ),
                                        color: isDark
                                            ? Colors.grey[900]
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            paddingScale.toDouble()),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                item['image'] ?? '',
                                                height: isWeb
                                                    ? 120
                                                    : isTablet
                                                        ? 90
                                                        : 70,
                                                width: isWeb
                                                    ? 120
                                                    : isTablet
                                                        ? 90
                                                        : 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['title'] ?? '',
                                                    style: GoogleFonts.poppins(
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: baseFont,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    'Price: ${item['unitPrice']}',
                                                    style: GoogleFonts.poppins(
                                                      color: textColor
                                                          .withOpacity(0.7),
                                                      fontSize: baseFont - 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),

                      /// Courier Info
                      Container(
                        width: size.width,
                        padding: EdgeInsets.all(paddingScale.toDouble()),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: isWeb
                                  ? 40
                                  : isTablet
                                      ? 35
                                      : 28,
                              backgroundImage:
                                  const AssetImage("assets/courier.png"),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "YOUR COURIER",
                                    style: GoogleFonts.poppins(
                                      color: textColor.withOpacity(0.7),
                                      fontSize: baseFont - 4,
                                    ),
                                  ),
                                  Text(
                                    "Patrick Watson",
                                    style: GoogleFonts.poppins(
                                      color: textColor,
                                      fontSize: baseFont + 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        "4.8",
                                        style: GoogleFonts.poppins(
                                          color: textColor,
                                          fontSize: baseFont - 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SpeedDial(
                              backgroundColor: isDark
                                  ? const Color.fromARGB(255, 242, 201, 79)
                                  : Colors.pink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: isDark ? 0 : 4,
                              icon: Icons.more_vert,
                              iconTheme:
                                  const IconThemeData(color: Colors.white),
                              activeIcon: Icons.close,
                              children: [
                                SpeedDialChild(
                                  child: Icon(Icons.call,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.pink),
                                  label: "Phone",
                                  onTap: _makeCall,
                                ),
                                SpeedDialChild(
                                  child: Icon(Icons.history,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.blue),
                                  label: "Order History",
                                  onTap: _openHistory,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    Color textColor,
    double fontSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: textColor, size: fontSize + 4),
            SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: fontSize - 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: fontSize - 2,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
