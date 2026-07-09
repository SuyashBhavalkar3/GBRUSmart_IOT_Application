import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Timeline entry model for tracking complaint progress.
class ComplaintTimelineEntry {
  final String label; // e.g. "Complaint Registered", "Assigned to Support", "Resolved"
  final DateTime timestamp;

  const ComplaintTimelineEntry({
    required this.label,
    required this.timestamp,
  });
}

/// Service Complaint details model.
class ComplaintModel {
  final String id;
  final String ticketNumber;
  final String title;
  final String description;
  final String category;
  final String priority; // Low, Medium, High
  final String? relatedDeviceImei;
  final String status; // In Progress, Escalated, Resolved
  final DateTime submittedDate;
  final DateTime? resolvedDate;
  final List<ComplaintTimelineEntry> timeline;

  const ComplaintModel({
    required this.id,
    required this.ticketNumber,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.relatedDeviceImei,
    required this.status,
    required this.submittedDate,
    this.resolvedDate,
    required this.timeline,
  });

  /// Copy helper to update complaint fields or timeline state.
  ComplaintModel copyWith({
    String? id,
    String? ticketNumber,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? relatedDeviceImei,
    String? status,
    DateTime? submittedDate,
    DateTime? resolvedDate,
    List<ComplaintTimelineEntry>? timeline,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      relatedDeviceImei: relatedDeviceImei ?? this.relatedDeviceImei,
      status: status ?? this.status,
      submittedDate: submittedDate ?? this.submittedDate,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      timeline: timeline ?? this.timeline,
    );
  }
}

/// Combined Profile and Complaint State Object.
class ProfileState {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String country;
  final String stateName; // renamed to stateName to prevent conflicts with flutter State class
  final String district;
  final String pincode;
  final String address;
  final String selectedLanguage;
  final Map<String, bool> notificationPreferences;
  final List<ComplaintModel> activeComplaints;
  final List<ComplaintModel> resolvedComplaints;

  const ProfileState({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.country,
    required this.stateName,
    required this.district,
    required this.pincode,
    required this.address,
    required this.selectedLanguage,
    required this.notificationPreferences,
    required this.activeComplaints,
    required this.resolvedComplaints,
  });

  /// Copy helper to return new immutable states.
  ProfileState copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? country,
    String? stateName,
    String? district,
    String? pincode,
    String? address,
    String? selectedLanguage,
    Map<String, bool>? notificationPreferences,
    List<ComplaintModel>? activeComplaints,
    List<ComplaintModel>? resolvedComplaints,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      country: country ?? this.country,
      stateName: stateName ?? this.stateName,
      district: district ?? this.district,
      pincode: pincode ?? this.pincode,
      address: address ?? this.address,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      activeComplaints: activeComplaints ?? this.activeComplaints,
      resolvedComplaints: resolvedComplaints ?? this.resolvedComplaints,
    );
  }
}

/// Profile notifier managing in-memory mutations.
class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return ProfileState(
      fullName: 'Ankita Bhogade',
      phoneNumber: '+91 98765 43210',
      email: 'ankita.bhogade@example.com',
      country: 'India',
      stateName: 'Maharashtra',
      district: 'Pune',
      pincode: '411001',
      address: 'Flat 102, Green Meadows, Shivajinagar',
      selectedLanguage: 'English',
      notificationPreferences: {
        'Push Notifications': true,
        'Dry Run Protection Activated': true,
        'Motor Started Successfully': true,
        'Geofence Completed': true,
        'High Current Detected': true,
        'Device Connected': true,
        'Cycle Mode Running': true,
        'Power Supply Interrupted': true,
        'Weekly Report Available': true,
      },
      activeComplaints: [
        ComplaintModel(
          id: 'MM-TKT-1002',
          ticketNumber: 'MM-TKT-1002',
          title: 'Motor Auto connectivity failure',
          description: 'Device loses signal frequently and stops showing logs in app.',
          category: 'Device Issue',
          priority: 'High',
          status: 'In Progress',
          submittedDate: DateTime.now().subtract(const Duration(days: 2)),
          timeline: [
            ComplaintTimelineEntry(
              label: 'Complaint Registered',
              timestamp: DateTime.now().subtract(const Duration(days: 2)),
            ),
            ComplaintTimelineEntry(
              label: 'Assigned to Support Specialist',
              timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
            ),
          ],
        ),
        ComplaintModel(
          id: 'MM-TKT-1004',
          ticketNumber: 'MM-TKT-1004',
          title: 'Billing issue with monthly package',
          description: 'Charged twice for the premium package this month.',
          category: 'Billing',
          priority: 'Medium',
          status: 'Escalated',
          submittedDate: DateTime.now().subtract(const Duration(days: 4)),
          timeline: [
            ComplaintTimelineEntry(
              label: 'Complaint Registered',
              timestamp: DateTime.now().subtract(const Duration(days: 4)),
            ),
          ],
        ),
      ],
      resolvedComplaints: [
        ComplaintModel(
          id: 'MM-TKT-0980',
          ticketNumber: 'MM-TKT-0980',
          title: 'SIM registration error',
          description: 'Device could not connect to local carrier SIM.',
          category: 'Device Issue',
          priority: 'Low',
          status: 'Resolved',
          submittedDate: DateTime.now().subtract(const Duration(days: 10)),
          resolvedDate: DateTime.now().subtract(const Duration(days: 8)),
          timeline: [
            ComplaintTimelineEntry(
              label: 'Complaint Registered',
              timestamp: DateTime.now().subtract(const Duration(days: 10)),
            ),
            ComplaintTimelineEntry(
              label: 'Carrier SIM Activated',
              timestamp: DateTime.now().subtract(const Duration(days: 9)),
            ),
            ComplaintTimelineEntry(
              label: 'Issue Resolved',
              timestamp: DateTime.now().subtract(const Duration(days: 8)),
            ),
          ],
        ),
        ComplaintModel(
          id: 'MM-TKT-0955',
          ticketNumber: 'MM-TKT-0955',
          title: 'Wrong location boundary',
          description: 'Incorrect geofencing triggered during farm test.',
          category: 'Other',
          priority: 'Medium',
          status: 'Resolved',
          submittedDate: DateTime.now().subtract(const Duration(days: 15)),
          resolvedDate: DateTime.now().subtract(const Duration(days: 14)),
          timeline: [
            ComplaintTimelineEntry(
              label: 'Complaint Registered',
              timestamp: DateTime.now().subtract(const Duration(days: 15)),
            ),
            ComplaintTimelineEntry(
              label: 'Issue Resolved',
              timestamp: DateTime.now().subtract(const Duration(days: 14)),
            ),
          ],
        ),
      ],
    );
  }

  /// Update general profile details
  void updateProfile({
    required String fullName,
    required String email,
    required String country,
    required String stateName,
    required String district,
    required String pincode,
    required String address,
    String? phoneNumber,
  }) {
    state = state.copyWith(
      fullName: fullName,
      email: email,
      country: country,
      stateName: stateName,
      district: district,
      pincode: pincode,
      address: address,
      phoneNumber: phoneNumber,
    );
  }

  /// Change active language selection
  void setLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }

  /// Toggle notification options on/off
  void toggleNotification(String key, bool value) {
    final updatedPrefs = Map<String, bool>.from(state.notificationPreferences);
    updatedPrefs[key] = value;
    state = state.copyWith(notificationPreferences: updatedPrefs);
  }

  /// Add a newly created complaint ticket to activeComplaints
  void addComplaint(ComplaintModel complaint) {
    final updatedActiveList = List<ComplaintModel>.from(state.activeComplaints)..insert(0, complaint);
    state = state.copyWith(activeComplaints: updatedActiveList);
  }

  /// Update active status, moving to resolved list if status becomes 'Resolved'
  void updateComplaintStatus(String ticketNumber, String newStatus) {
    if (newStatus == 'Resolved') {
      final activeIndex = state.activeComplaints.indexWhere((c) => c.ticketNumber == ticketNumber);
      if (activeIndex >= 0) {
        final complaint = state.activeComplaints[activeIndex];
        final resolvedComplaint = complaint.copyWith(
          status: 'Resolved',
          resolvedDate: DateTime.now(),
          timeline: List<ComplaintTimelineEntry>.from(complaint.timeline)
            ..add(ComplaintTimelineEntry(label: 'Issue Resolved', timestamp: DateTime.now())),
        );

        final updatedActive = List<ComplaintModel>.from(state.activeComplaints)..removeAt(activeIndex);
        final updatedResolved = List<ComplaintModel>.from(state.resolvedComplaints)..insert(0, resolvedComplaint);

        state = state.copyWith(
          activeComplaints: updatedActive,
          resolvedComplaints: updatedResolved,
        );
      }
    } else {
      final updatedActive = state.activeComplaints.map((c) {
        if (c.ticketNumber == ticketNumber) {
          return c.copyWith(
            status: newStatus,
            timeline: List<ComplaintTimelineEntry>.from(c.timeline)
              ..add(ComplaintTimelineEntry(label: 'Status changed to $newStatus', timestamp: DateTime.now())),
          );
        }
        return c;
      }).toList();
      state = state.copyWith(activeComplaints: updatedActive);
    }
  }
}

/// Profile provider wrapper.
final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
