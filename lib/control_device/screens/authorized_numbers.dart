import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../home_dashboard/widgets/mobile_auto/primary_gradient_button.dart';

// Styling Palette matching the device Settings screen
const Color primaryGreen = Color(0xFF00A859);
const Color bgMint = Color(0xFFF0F9F4);
const Color textDark = Color(0xFF1A1A1A);
const Color textGrey = Color(0xFF666666);
const Color borderGrey = Color(0xFFE0E0E0);
const Color blueColor = Color(0xFF2F66F6);
const Color blueBg = Color(0xFFEEF3FF);

/// 8. State Model
class AuthorizedNumberModel {
  final String contactName;
  final String phoneNumber;
  final DateTime addedDate;
  final bool isOwner;

  const AuthorizedNumberModel({
    required this.contactName,
    required this.phoneNumber,
    required this.addedDate,
    required this.isOwner,
  });
}

/// 8. State Notifier for Managing Authorized Numbers (In-Memory Only)
class AuthorizedNumbersNotifier extends StateNotifier<List<AuthorizedNumberModel>> {
  AuthorizedNumbersNotifier()
      : super([
          AuthorizedNumberModel(
            contactName: 'Mobile Auto',
            phoneNumber: '+91 98765 43210',
            addedDate: DateTime(2026, 6, 1),
            isOwner: true,
          ),
          AuthorizedNumberModel(
            contactName: 'Assistant Manager',
            phoneNumber: '+91 98765 43211',
            addedDate: DateTime(2026, 6, 15),
            isOwner: false,
          ),
          AuthorizedNumberModel(
            contactName: 'Farm Supervisor',
            phoneNumber: '+91 98765 43212',
            addedDate: DateTime(2026, 6, 20),
            isOwner: false,
          ),
        ]);

  void addNumber(String contactName, String phoneNumber) {
    state = [
      ...state,
      AuthorizedNumberModel(
        contactName: contactName,
        phoneNumber: phoneNumber,
        addedDate: DateTime.now(),
        isOwner: false,
      ),
    ];
  }

  void removeNumber(String phoneNumber) {
    state = state.where((item) => item.phoneNumber != phoneNumber).toList();
  }
}

final authorizedNumbersProvider =
    StateNotifierProvider<AuthorizedNumbersNotifier, List<AuthorizedNumberModel>>((ref) {
  return AuthorizedNumbersNotifier();
});

/// 7. Simulated Command Sending
Future<bool> _sendDeviceCommand({required String action}) async {
  await Future.delayed(const Duration(seconds: 4));
  // TODO: replace with real SMS/backend command dispatch later.
  // For now, return true to simulate success. You can temporarily
  // return false here (or randomize it) to test the failure dialog.
  return true;
}

/// 3. Main Screen - Authorized Numbers List
class AuthorizedNumbersScreen extends ConsumerWidget {
  const AuthorizedNumbersScreen({super.key});

  // Action flow for adding a number
  void _triggerAddFlow(BuildContext context, WidgetRef ref, String name, String phone) async {
    bool commandCancelled = false;

    // Show sending dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SendingCommandDialog(
        actionText: 'Adding $name...',
        onCancel: () {
          commandCancelled = true;
          Navigator.of(context).pop();
        },
      ),
    );

    final success = await _sendDeviceCommand(action: 'Add number $phone');
    if (commandCancelled) return;
    if (!context.mounted) return;

    // Close sending dialog
    Navigator.of(context).pop();

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _CommandSuccessDialog(
          contextLabel: 'Add user',
          title: 'Command Sent Successfully',
          body: 'command has been sent to the device.\nYou will receive confirmation via SMS on your phone.',
          onOk: () {
            ref.read(authorizedNumbersProvider.notifier).addNumber(name, phone);
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _CommandFailedDialog(
          onTryAgain: () {
            Navigator.of(context).pop();
            _triggerAddFlow(context, ref, name, phone);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  // Action flow for removing a number
  void _triggerRemoveFlow(BuildContext context, WidgetRef ref, AuthorizedNumberModel item) async {
    bool commandCancelled = false;

    // Show sending dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SendingCommandDialog(
        actionText: 'Removing ${item.contactName}...',
        onCancel: () {
          commandCancelled = true;
          Navigator.of(context).pop();
        },
      ),
    );

    final success = await _sendDeviceCommand(action: 'Remove number ${item.phoneNumber}');
    if (commandCancelled) return;
    if (!context.mounted) return;

    // Close sending dialog
    Navigator.of(context).pop();

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _CommandSuccessDialog(
          contextLabel: 'Delete user',
          title: 'Command Sent Successfully',
          body: 'command has been sent to the device.\nYou will receive confirmation via SMS on your phone.',
          onOk: () {
            ref.read(authorizedNumbersProvider.notifier).removeNumber(item.phoneNumber);
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _CommandFailedDialog(
          onTryAgain: () {
            Navigator.of(context).pop();
            _triggerRemoveFlow(context, ref, item);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numbers = ref.watch(authorizedNumbersProvider);

    return Scaffold(
      backgroundColor: bgMint,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Authorized Numbers',
              style: TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Manage device access control',
              style: TextStyle(
                color: textGrey,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  if (numbers.length >= 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Maximum limit of 10 authorized numbers reached.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (context) => _AddNumberDialog(
                      onAdd: (name, phone) async {
                        _triggerAddFlow(context, ref, name, phone);
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7ED),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryGreen),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 14, color: primaryGreen),
                      SizedBox(width: 4),
                      Text(
                        '+ Add',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                'Authorized (${numbers.length}/10)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textGrey,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: numbers.length,
                itemBuilder: (context, index) {
                  final item = numbers[index];
                  final formattedDate = DateFormat('dd/MM/yyyy').format(item.addedDate);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderGrey),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE6F7ED),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.phone_outlined,
                            color: primaryGreen,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.contactName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: textDark,
                                    ),
                                  ),
                                  if (item.isOwner) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6F7ED),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: primaryGreen),
                                      ),
                                      child: const Text(
                                        'Owner',
                                        style: TextStyle(
                                          color: primaryGreen,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.phoneNumber,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: textGrey,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Added $formattedDate',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!item.isOwner)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => _RemoveConfirmationDialog(
                                  contactName: item.contactName,
                                  onRemove: () {
                                    _triggerRemoveFlow(context, ref, item);
                                  },
                                ),
                              );
                            },
                          ),
                      ],
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

/// 4. Dialog - Add Number
class _AddNumberDialog extends StatefulWidget {
  final void Function(String name, String phone) onAdd;

  const _AddNumberDialog({required this.onAdd});

  @override
  State<_AddNumberDialog> createState() => _AddNumberDialogState();
}

class _AddNumberDialogState extends State<_AddNumberDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateInputs);
    _phoneController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    setState(() {
      _isButtonEnabled = name.isNotEmpty && phone.length == 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Number',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Authorize another phone number',
                style: TextStyle(
                  fontSize: 13,
                  color: textGrey,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Contact Name',
                  hintText: 'e.g., Farm Manager',
                  labelStyle: const TextStyle(color: textGrey),
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryGreen, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+91 ',
                  prefixStyle: const TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: '98765 43210',
                  counterText: '',
                  labelStyle: const TextStyle(color: textGrey),
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryGreen, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Amber/warning info banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This number will be able to start/stop the motor and receive alerts.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB45309),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              PrimaryGradientButton(
                label: 'Add Number',
                isEnabled: _isButtonEnabled,
                onPressed: () {
                  final name = _nameController.text.trim();
                  final phone = '+91 ${_phoneController.text.trim()}';
                  Navigator.of(context).pop();
                  widget.onAdd(name, phone);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 5. Dialog - Remove Authorized User Confirmation
class _RemoveConfirmationDialog extends StatelessWidget {
  final String contactName;
  final VoidCallback onRemove;

  const _RemoveConfirmationDialog({
    required this.contactName,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    const errorBg = Color(0xFFFEE2E2);
    const errorRed = Color(0xFFEF4444);
    const textSlate = Color(0xFF0F172A);
    const textSlateGrey = Color(0xFF64748B);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: errorBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: errorRed,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Remove Authorized User?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textSlate,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$contactName will no longer be able to control the device.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: textSlateGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            PrimaryGradientButton(
              label: 'Yes, Remove User',
              backgroundColor: errorRed,
              onPressed: onRemove,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: textSlateGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 6. Shared Dialogs - Sending Command
class _SendingCommandDialog extends StatelessWidget {
  final String actionText;
  final VoidCallback onCancel;

  const _SendingCommandDialog({
    required this.actionText,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    const loaderBg = Color(0xFFE8F0FE);
    const loaderColor = Color(0xFF2F66F6);
    const textSlate = Color(0xFF0F172A);
    const textSlateGrey = Color(0xFF64748B);
    const borderSlateGrey = Color(0xFFCBD5E1);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: loaderBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5,
                    valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sending Command',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textSlate,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              actionText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: textSlateGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: textSlate,
                  side: const BorderSide(color: borderSlateGrey, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 6. Shared Dialogs - Command Failed
class _CommandFailedDialog extends StatelessWidget {
  final VoidCallback onTryAgain;
  final VoidCallback onCancel;

  const _CommandFailedDialog({
    required this.onTryAgain,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    const errorBg = Color(0xFFFFF4EC);
    const errorOrange = Color(0xFFE27F00);
    const textSlate = Color(0xFF0F172A);
    const textSlateGrey = Color(0xFF64748B);
    const borderSlateGrey = Color(0xFFCBD5E1);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: errorBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.report_problem_outlined,
                  color: errorOrange,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Command Failed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textSlate,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Could not send SMS command to device. Please check your network and try again. Please check your network or SIM settings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textSlateGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            PrimaryGradientButton(
              label: 'Try Again',
              onPressed: onTryAgain,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: textSlate,
                  side: const BorderSide(color: borderSlateGrey, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 6. Shared Dialogs - Command Success
class _CommandSuccessDialog extends StatelessWidget {
  final String? contextLabel;
  final String title;
  final String body;
  final VoidCallback onOk;

  const _CommandSuccessDialog({
    this.contextLabel,
    required this.title,
    required this.body,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    const successBg = Color(0xFFE6F7ED);
    const successGreen = Color(0xFF00A859);
    const textSlate = Color(0xFF0F172A);
    const textSlateGrey = Color(0xFF64748B);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: successBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle_outline,
                  color: successGreen,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (contextLabel != null) ...[
              Text(
                contextLabel!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textSlate,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: textSlateGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            PrimaryGradientButton(
              label: 'OK',
              onPressed: onOk,
            ),
          ],
        ),
      ),
    );
  }
}
