/// Enum representing the ownership status of the device.
enum DeviceOwnershipStatus { owned, registeredToAnotherOwner, linked }

/// Data model representing a Mobile Auto device in the application.
class MobileAutoDevice {
  final String deviceName;      // e.g. "Mobile Auto"
  final String imeiNumber;      // Full IMEI number as scanned or entered
  final String masterNumber;    // Master contact number, e.g. "+91 98765 43210"
  final DateTime installedDate; // Installation date
  final DeviceOwnershipStatus ownershipStatus; // Ownership state
  final bool isActive;          // Is the device currently active

  const MobileAutoDevice({
    required this.deviceName,
    required this.imeiNumber,
    required this.masterNumber,
    required this.installedDate,
    this.ownershipStatus = DeviceOwnershipStatus.owned,
    this.isActive = true,
  });

  /// Alias getter for 'imei' to match specific coding requests.
  String get imei => imeiNumber;

  /// Returns the readable status string based on isActive flag.
  String get status => isActive ? 'Active' : 'Inactive';

  /// Centrally computes the masked version of the IMEI (e.g. ********123456).
  String get maskedImei {
    if (imeiNumber.length <= 6) return imeiNumber;
    final maskedLength = imeiNumber.length - 6;
    return '${'*' * maskedLength}${imeiNumber.substring(imeiNumber.length - 6)}';
  }

  /// Factory method to create an empty device model instance.
  factory MobileAutoDevice.empty() {
    return MobileAutoDevice(
      deviceName: 'Mobile Auto',
      imeiNumber: '',
      masterNumber: '',
      installedDate: DateTime.now(),
      ownershipStatus: DeviceOwnershipStatus.owned,
      isActive: false,
    );
  }

  /// Creates a copy of this device model with updated parameters.
  MobileAutoDevice copyWith({
    String? deviceName,
    String? imeiNumber,
    String? masterNumber,
    DateTime? installedDate,
    DeviceOwnershipStatus? ownershipStatus,
    bool? isActive,
  }) {
    return MobileAutoDevice(
      deviceName: deviceName ?? this.deviceName,
      imeiNumber: imeiNumber ?? this.imeiNumber,
      masterNumber: masterNumber ?? this.masterNumber,
      installedDate: installedDate ?? this.installedDate,
      ownershipStatus: ownershipStatus ?? this.ownershipStatus,
      isActive: isActive ?? this.isActive,
    );
  }
}
