import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../domain/family_member_location.dart';
import 'widgets/child_marker_widget.dart';
import 'widgets/location_status_card.dart';

/// Family Map Screen
/// ROADMAP: Task 1.16 - Family Live Map (Parent View)
/// Real-time map showing children's locations with safe zones
/// Uses OpenStreetMap via flutter_map to avoid Google Maps API costs
class FamilyMapScreen extends StatefulWidget {
  const FamilyMapScreen({super.key});

  @override
  State<FamilyMapScreen> createState() => _FamilyMapScreenState();
}

class _FamilyMapScreenState extends State<FamilyMapScreen> {
  final MapController _mapController = MapController();
  FamilyMemberLocation? _selectedChild;

  // Initial position: Johannesburg, South Africa
  static const LatLng _initialCenter = LatLng(-26.2041, 28.0473);
  static const double _initialZoom = 12.0;

  // Mock children locations
  final List<FamilyMemberLocation> _childrenLocations = [
    // Lesedi - Near Sandton (teenager, moving)
    FamilyMemberLocation(
      memberId: 'child-001',
      memberName: 'Lesedi Molefe',
      avatar: 'LM',
      coordinates: const LatLng(-26.1076, 28.0567), // Sandton
      batteryLevel: 0.75,
      isMoving: true,
      isConnected: true,
      lastUpdate: DateTime.now().subtract(const Duration(seconds: 5)),
      speed: 25.0,
      address: 'Sandton City Shopping Centre',
    ),
    // Amogelang - At home (younger child, stationary)
    FamilyMemberLocation(
      memberId: 'child-002',
      memberName: 'Amogelang Molefe',
      avatar: 'AM',
      coordinates: const LatLng(-26.2041, 28.0473), // Home
      batteryLevel: 0.45,
      isMoving: false,
      isConnected: true,
      lastUpdate: DateTime.now().subtract(const Duration(minutes: 2)),
      speed: 0,
      address: 'Home',
    ),
  ];

  // Safe zones
  final List<SafeZone> _safeZones = [
    const SafeZone(
      id: 'home',
      name: 'Home',
      center: LatLng(-26.2041, 28.0473),
      radiusMeters: 200,
      type: SafeZoneType.home,
    ),
    const SafeZone(
      id: 'school',
      name: 'Sandton High School',
      center: LatLng(-26.0975, 28.0605),
      radiusMeters: 150,
      type: SafeZoneType.school,
    ),
  ];

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Center map on child's location
  void _centerOnChild(FamilyMemberLocation child) {
    HapticService.lightImpact();
    _mapController.move(child.coordinates, 14);
    setState(() => _selectedChild = child);
  }

  /// Handle child selection from status card
  void _onChildSelected(FamilyMemberLocation child) {
    _centerOnChild(child);
  }

  /// Handle navigate action
  void _onNavigate(FamilyMemberLocation child) {
    HapticService.mediumImpact();
    // TODO: Open external navigation app
    debugPrint('Navigate to ${child.memberName}');
  }

  /// Handle call action
  void _onCall(FamilyMemberLocation child) {
    HapticService.mediumImpact();
    // TODO: Open phone dialer
    debugPrint('Call ${child.memberName}');
  }

  /// Handle signal alert action
  void _onSignalAlert(FamilyMemberLocation child) {
    HapticService.heavyImpact();
    // TODO: Send emergency alert
    debugPrint('Signal alert to ${child.memberName}');
  }

  /// Build markers for children locations
  List<Marker> _buildMarkers() {
    return _childrenLocations.map((location) {
      return Marker(
        point: location.coordinates,
        width: 80,
        height: 80,
        child: ChildMarkerWidget(
          location: location,
          onTap: () => _onChildSelected(location),
        ),
      );
    }).toList();
  }

  /// Build circles for safe zones
  List<CircleMarker> _buildSafeZones() {
    return _safeZones.map((zone) {
      return CircleMarker(
        point: zone.center,
        radius: zone.radiusMeters,
        useRadiusInMeter: true,
        color: AppColors.primary.withValues(alpha: 0.1),
        borderColor: AppColors.primary.withValues(alpha: 0.5),
        borderStrokeWidth: 2,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Family Map'),
        actions: [
          // Center on first child action
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (_childrenLocations.isNotEmpty) {
                _centerOnChild(_childrenLocations.first);
              }
            },
            tooltip: 'Center on children',
          ),
        ],
      ),
      body: Stack(
        children: [
          // OpenStreetMap via flutter_map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: _initialZoom,
              minZoom: 5,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(
                enableMultiFingerGestureRace: true,
              ),
            ),
            children: [
              // Tile Layer (OpenStreetMap)
              TileLayer(
                urlTemplate: isDark
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                    : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.shield.banking',
                maxZoom: 19,
                tileProvider: NetworkTileProvider(),
              ),

              // Safe zones circles
              CircleLayer(
                circles: _buildSafeZones(),
              ),

              // Children markers
              MarkerLayer(
                markers: _buildMarkers(),
              ),
            ],
          ),

          // Bottom status card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LocationStatusCard(
              children: _childrenLocations,
              selectedChild: _selectedChild,
              onChildSelected: _onChildSelected,
              onNavigate: _onNavigate,
              onCall: _onCall,
              onSignalAlert: _onSignalAlert,
            ),
          ),
        ],
      ),
    );
  }
}
