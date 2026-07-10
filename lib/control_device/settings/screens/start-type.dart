// ignore_for_file: file_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home_dashboard/widgets/mobile_auto/primary_gradient_button.dart';

// Styling Palette matching the device Settings screen
const Color primaryGreen = Color(0xFF00A859);
const Color bgMint = Color(0xFFF0F9F4);
const Color textDark = Color(0xFF1A1A1A);
const Color textGrey = Color(0xFF666666);
const Color borderGrey = Color(0xFFE0E0E0);
const Color blueColor = Color(0xFF2F66F6);
const Color blueBg = Color(0xFFEEF3FF);

/// 3. Option Model
class StarterOption {
  final String label;
  final String? subtitle;
  final String imageAssetPath;
  final IconData fallbackIcon;
  final Color themeColor;

  const StarterOption({
    required this.label,
    this.subtitle,
    required this.imageAssetPath,
    required this.fallbackIcon,
    required this.themeColor,
  });
}

enum StarterPhaseType { single, three }

class StarterTypeSelection {
  final StarterPhaseType phaseType;
  final String variantLabel;

  const StarterTypeSelection({
    required this.phaseType,
    required this.variantLabel,
  });
}

/// 5. Riverpod Provider (In-Memory Only)
final starterTypeProvider = StateProvider<StarterTypeSelection?>((ref) => null);

/// Helper widget to render standard premium placeholder image wrapper
Widget _buildStarterImage(String assetPath, IconData fallbackIcon, Color color) {
  // TODO: replace with generated illustration png asset later if registered.
  // For now, we render a highly polished modern vector illustration fallback using Material icons.
  return Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1020),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.2000)),
    ),
    child: Center(
      child: Icon(
        fallbackIcon,
        color: color,
        size: 24,
      ),
    ),
  );
}

/// Step 1 — StarterTypeScreen
class StarterTypeScreen extends ConsumerStatefulWidget {
  const StarterTypeScreen({super.key});

  @override
  ConsumerState<StarterTypeScreen> createState() => _StarterTypeScreenState();
}

class _StarterTypeScreenState extends ConsumerState<StarterTypeScreen> {
  StarterPhaseType _selectedPhase = StarterPhaseType.single;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgMint,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back, color: textDark, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Starter Type',
              style: TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Select the motor starter connected to this device',
              style: TextStyle(
                color: textGrey,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Option 1: Single Phase Starter
                  _buildPhaseCard(
                    phase: StarterPhaseType.single,
                    title: 'Single Phase Starter (Contactor)',
                    subtitle: 'Motor is controlled using a contactor starter.',
                    fallbackIcon: Icons.electrical_services_outlined,
                    color: primaryGreen,
                    imagePath: 'assets/images/starter_types/single_phase_contactor.png',
                  ),
                  const SizedBox(height: 16),
                  // Option 2: Three Phase Motor
                  _buildPhaseCard(
                    phase: StarterPhaseType.three,
                    title: 'Three Phase Motor',
                    subtitle: 'Used for three-phase pump motors.',
                    fallbackIcon: Icons.settings_input_component_outlined,
                    color: blueColor,
                    imagePath: 'assets/images/starter_types/three_phase_motor.png',
                  ),
                  const SizedBox(height: 24),
                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2F6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: blueColor,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Why Starter Type Matters',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Selecting the correct starter type ensures proper motor control and protection.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textGrey,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Action Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryGradientButton(
                    label: 'Save Settings',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => _StarterVariantScreen(phaseType: _selectedPhase),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Device configuration will be updated after saving.',
                    style: TextStyle(
                      fontSize: 12,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseCard({
    required StarterPhaseType phase,
    required String title,
    required String subtitle,
    required IconData fallbackIcon,
    required Color color,
    required String imagePath,
  }) {
    final isSelected = _selectedPhase == phase;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPhase = phase;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9F4) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryGreen : borderGrey,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            _buildStarterImage(imagePath, fallbackIcon, color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Radio<StarterPhaseType>(
              value: phase,
              groupValue: _selectedPhase,
              activeColor: primaryGreen,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPhase = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Step 2 — _StarterVariantScreen
class _StarterVariantScreen extends ConsumerStatefulWidget {
  final StarterPhaseType phaseType;

  const _StarterVariantScreen({required this.phaseType});

  @override
  ConsumerState<_StarterVariantScreen> createState() => _StarterVariantScreenState();
}

class _StarterVariantScreenState extends ConsumerState<_StarterVariantScreen> {
  late List<StarterOption> _options;
  String _selectedVariant = '';

  @override
  void initState() {
    super.initState();
    if (widget.phaseType == StarterPhaseType.single) {
      _options = [
        const StarterOption(
          label: 'Single Phase Starter (Relay)',
          imageAssetPath: 'assets/images/starter_types/single_phase_relay.png',
          fallbackIcon: Icons.developer_board_outlined,
          themeColor: primaryGreen,
        ),
        const StarterOption(
          label: 'Single Phase Capacitor Starter (DOL LT)',
          imageAssetPath: 'assets/images/starter_types/single_phase_capacitor_dol_lt.png',
          fallbackIcon: Icons.tungsten_outlined,
          themeColor: blueColor,
        ),
        const StarterOption(
          label: 'Single Phase Capacitor Starter',
          imageAssetPath: 'assets/images/starter_types/single_phase_capacitor.png',
          fallbackIcon: Icons.center_focus_strong_outlined,
          themeColor: Colors.purple,
        ),
        const StarterOption(
          label: 'Single Phase Motor',
          imageAssetPath: 'assets/images/starter_types/single_phase_motor.png',
          fallbackIcon: Icons.flash_on_outlined,
          themeColor: Colors.orange,
        ),
      ];
    } else {
      _options = [
        const StarterOption(
          label: 'Three Phase Direct Online Starter (DOL)',
          imageAssetPath: 'assets/images/starter_types/three_phase_dol.png',
          fallbackIcon: Icons.grid_view_outlined,
          themeColor: blueColor,
        ),
        const StarterOption(
          label: 'Three Phase Star Delta DOL Starter',
          imageAssetPath: 'assets/images/starter_types/three_phase_star_delta_dol.png',
          fallbackIcon: Icons.sync_alt_outlined,
          themeColor: Colors.deepOrange,
        ),
        const StarterOption(
          label: 'Three Phase Star Delta Starter (Fully Automatic)',
          imageAssetPath: 'assets/images/starter_types/three_phase_star_delta_auto.png',
          fallbackIcon: Icons.auto_awesome_outlined,
          themeColor: primaryGreen,
        ),
        const StarterOption(
          label: 'Oil Starter Semi-Automatic (Start-Run-Stop Type)',
          imageAssetPath: 'assets/images/starter_types/oil_starter_semi_auto.png',
          fallbackIcon: Icons.opacity_outlined,
          themeColor: Colors.teal,
        ),
      ];
    }
    _selectedVariant = _options.first.label;
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.phaseType == StarterPhaseType.single ? 'Single Phase Starter' : 'Three Phase Starter';

    return Scaffold(
      backgroundColor: bgMint,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back, color: textDark, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Select the starter variant connected to this device',
              style: TextStyle(
                color: textGrey,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final option = _options[index];
                  final isSelected = _selectedVariant == option.label;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedVariant = option.label;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF0F9F4) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? primaryGreen : borderGrey,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildStarterImage(option.imageAssetPath, option.fallbackIcon, option.themeColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option.label,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Radio<String>(
                            value: option.label,
                            groupValue: _selectedVariant,
                            activeColor: primaryGreen,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedVariant = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom Action Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryGradientButton(
                    label: 'Save Settings',
                    onPressed: () {
                      ref.read(starterTypeProvider.notifier).state = StarterTypeSelection(
                        phaseType: widget.phaseType,
                        variantLabel: _selectedVariant,
                      );
                      // Pop back twice to get to settings
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Device configuration will be updated after saving.',
                    style: TextStyle(
                      fontSize: 12,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
