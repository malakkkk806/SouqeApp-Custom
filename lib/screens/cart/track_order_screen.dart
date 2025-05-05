import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:souqe/constants/colors.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  LatLng? _driverPosition;
  late String orderId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orderId = ModalRoute.of(context)!.settings.arguments as String;
    _startUpdatingLocation();
  }

  void _startUpdatingLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((pos) {
      FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'location': {'lat': pos.latitude, 'lng': pos.longitude}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Track Order',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) return const Center(child: Text('Order not found'));

          final status = data['status'] ?? 'pending';
          final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
          final total = data['total'] ?? 0.0;
          final timestamp = data['timestamp'] as Timestamp?;
          final location = data['location'] as Map<String, dynamic>?;

          if (location != null) {
            _driverPosition = LatLng(location['lat'], location['lng']);
          }

          return _buildTrackingContent(status, items, total, timestamp);
        },
      ),
    );
  }

  Widget _buildTrackingContent(String status, List<Map<String, dynamic>> items, double total, Timestamp? timestamp) {
    const stages = ['placed', 'preparing', 'on_the_way', 'delivered'];
    final currentStageIndex = stages.indexOf(status);
    final baseTime = timestamp?.toDate() ?? DateTime.now();
    final estimated = baseTime.add(const Duration(minutes: 30));
    final timeFormat = DateFormat.jm();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_driverPosition != null)
            SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: _driverPosition!, zoom: 15),
                markers: {
                  Marker(
                    markerId: const MarkerId('driver'),
                    position: _driverPosition!,
                    infoWindow: const InfoWindow(title: 'Driver Location'),
                  ),
                },
              ),
            )
          else
            const SizedBox(
              height: 200,
              child: Center(child: Text('Waiting for location...')),
            ),
          const SizedBox(height: 30),
          const Text('Order Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildStatusTile('Order Placed', Icons.check_circle, currentStageIndex > 0, isCurrent: currentStageIndex == 0),
          _buildStatusTile('Preparing', Icons.local_dining, currentStageIndex > 1, isCurrent: currentStageIndex == 1),
          _buildStatusTile('On the Way', Icons.delivery_dining, currentStageIndex > 2, isCurrent: currentStageIndex == 2),
          _buildStatusTile('Delivered', Icons.home, currentStageIndex > 3, isCurrent: currentStageIndex == 3, isLast: true),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated Delivery', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text(
                '${timeFormat.format(baseTime)} - ${timeFormat.format(estimated)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Order Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...items.map(_buildItemRow).toList(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${item['title'] ?? 'Item'} (x${item['quantity'] ?? 1})', style: const TextStyle(fontSize: 14)),
          Text('\$${item['price']?.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatusTile(String label, IconData icon, bool isDone, {bool isCurrent = false, bool isLast = false}) {
    final color = isDone || isCurrent ? AppColors.primary : AppColors.grey;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(radius: 16, backgroundColor: color, child: Icon(icon, size: 18, color: Colors.white)),
            if (!isLast) Container(width: 2, height: 40, color: color),
          ],
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(label, style: TextStyle(fontSize: 15, fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500, color: color)),
        ),
      ],
    );
  }
}