import 'package:latlong2/latlong.dart';

/// Family Member Location Model
/// Extends family member with real-time location data
class FamilyMemberLocation {
  final String memberId;
  final String memberName;
  final String avatar;
  final LatLng coordinates;
  final double batteryLevel; // 0.0 to 1.0
  final bool isMoving;
  final bool isConnected;
  final DateTime lastUpdate;
  final double? speed; // km/h, null if stationary
  final String? address; // Reverse geocoded address

  const FamilyMemberLocation({
    required this.memberId,
    required this.memberName,
    required this.avatar,
    required this.coordinates,
    required this.batteryLevel,
    required this.isMoving,
    required this.isConnected,
    required this.lastUpdate,
    this.speed,
    this.address,
  });

  FamilyMemberLocation copyWith({
    String? memberId,
    String? memberName,
    String? avatar,
    LatLng? coordinates,
    double? batteryLevel,
    bool? isMoving,
    bool? isConnected,
    DateTime? lastUpdate,
    double? speed,
    String? address,
  }) {
    return FamilyMemberLocation(
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      avatar: avatar ?? this.avatar,
      coordinates: coordinates ?? this.coordinates,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isMoving: isMoving ?? this.isMoving,
      isConnected: isConnected ?? this.isConnected,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      speed: speed ?? this.speed,
      address: address ?? this.address,
    );
  }

  /// Get time since last update in human-readable format
  String get timeSinceUpdate {
    final difference = DateTime.now().difference(lastUpdate);
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Get battery status description
  String get batteryStatus {
    if (batteryLevel >= 0.7) return 'Good';
    if (batteryLevel >= 0.3) return 'Medium';
    if (batteryLevel >= 0.1) return 'Low';
    return 'Critical';
  }

  /// Get movement status description
  String get movementStatus {
    if (!isConnected) return 'Offline';
    if (isMoving) {
      if (speed != null && speed! > 0) {
        return 'Moving (${speed!.toStringAsFixed(0)} km/h)';
      }
      return 'Moving';
    }
    return 'Stationary';
  }
}

/// Safe Zone Model
/// Represents predefined safe locations (Home, School, etc.)
class SafeZone {
  final String id;
  final String name;
  final LatLng center;
  final double radiusMeters;
  final SafeZoneType type;

  const SafeZone({
    required this.id,
    required this.name,
    required this.center,
    required this.radiusMeters,
    required this.type,
  });

  /// Check if a location is within this safe zone
  bool contains(LatLng location) {
    // Simple distance calculation (not perfectly accurate for large distances)
    final double latDiff = (location.latitude - center.latitude).abs();
    final double lngDiff = (location.longitude - center.longitude).abs();
    final double distance = (latDiff * latDiff + lngDiff * lngDiff);
    final double radiusDegrees = radiusMeters / 111000; // Rough conversion
    return distance <= (radiusDegrees * radiusDegrees);
  }
}

enum SafeZoneType {
  home,
  school,
  other,
}
