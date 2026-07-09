import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/location_details_provider.dart';
import 'profile_completed_screen.dart';

class LocationDetailsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onSaveAndContinue;

  const LocationDetailsScreen({
    super.key,
    this.onBackPressed,
    this.onSaveAndContinue,
  });

  @override
  State<LocationDetailsScreen> createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  final LocationDetailsProvider _locationProvider = LocationDetailsProvider();
  
  late final TextEditingController _pincodeController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _pincodeController = TextEditingController(text: _locationProvider.pincode);
    _addressController = TextEditingController(text: _locationProvider.address);
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    _addressController.dispose();
    _locationProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF6), // Same background as Login Screen
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double height = constraints.maxHeight;
            final double width = constraints.maxWidth;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height,
                  minWidth: width,
                ),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      // Main Content Layer
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * (24.0 / 393.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * (100.0 / 852.0)), // Offset for back button
                            
                            // Title
                            Text(
                              'Complete Your Profile',
                              style: TextStyle(
                                fontSize: width * (24.0 / 393.0),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                                fontFamily: 'Inter',
                              ),
                            ),
                            
                            SizedBox(height: height * (8.0 / 852.0)),
                            
                            // Subtitle
                            Text(
                              'Add your Location details.',
                              style: TextStyle(
                                fontSize: width * (14.0 / 393.0),
                                color: const Color(0xFF6B7280),
                                fontFamily: 'Inter',
                              ),
                            ),
                            
                            SizedBox(height: height * (24.0 / 852.0)),
                            
                            // Section Title
                            Text(
                              'Location',
                              style: TextStyle(
                                fontSize: width * (14.0 / 393.0),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                                fontFamily: 'Inter',
                              ),
                            ),
                            
                            SizedBox(height: height * (24.0 / 852.0)),
                            
                            // Form Fields
                            ListenableBuilder(
                              listenable: _locationProvider,
                              builder: (context, _) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDropdown(
                                      label: 'Country',
                                      hintText: 'Select Country',
                                      value: _locationProvider.selectedCountry,
                                      items: _locationProvider.countries,
                                      onChanged: _locationProvider.setCountry,
                                      width: width,
                                      height: height,
                                    ),
                                    
                                    SizedBox(height: height * (16.0 / 852.0)),
                                    
                                    _buildDropdown(
                                      label: 'State',
                                      hintText: 'Select State',
                                      value: _locationProvider.selectedState,
                                      items: _locationProvider.states,
                                      onChanged: _locationProvider.setState,
                                      width: width,
                                      height: height,
                                    ),
                                    
                                    SizedBox(height: height * (16.0 / 852.0)),
                                    
                                    // District and Tehsil side-by-side
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildDropdown(
                                            label: 'District',
                                            hintText: 'Select District',
                                            value: _locationProvider.selectedDistrict,
                                            items: _locationProvider.districts,
                                            onChanged: _locationProvider.setDistrict,
                                            width: width,
                                            height: height,
                                          ),
                                        ),
                                        SizedBox(width: width * (16.0 / 393.0)),
                                        Expanded(
                                          child: _buildDropdown(
                                            label: 'Tehsil',
                                            hintText: 'Select Tehsil',
                                            value: _locationProvider.selectedTehsil,
                                            items: _locationProvider.tehsils,
                                            onChanged: _locationProvider.setTehsil,
                                            width: width,
                                            height: height,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: height * (16.0 / 852.0)),
                                    
                                    _buildTextField(
                                      label: 'Pincode',
                                      hintText: 'Pincode',
                                      controller: _pincodeController,
                                      onChanged: _locationProvider.setPincode,
                                      errorText: _locationProvider.pincodeError,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: Icons.location_on_outlined,
                                      maxLength: 6,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      width: width,
                                      height: height,
                                    ),
                                    
                                    SizedBox(height: height * (16.0 / 852.0)),
                                    
                                    _buildTextField(
                                      label: 'Address',
                                      hintText: 'Address',
                                      controller: _addressController,
                                      onChanged: _locationProvider.setAddress,
                                      errorText: _locationProvider.addressError,
                                      keyboardType: TextInputType.streetAddress,
                                      prefixIcon: Icons.home_outlined,
                                      width: width,
                                      height: height,
                                    ),
                                  ],
                                );
                              },
                            ),
                            
                            const Spacer(),
                            
                            // Save & Continue Button
                            ListenableBuilder(
                              listenable: _locationProvider,
                              builder: (context, _) {
                                return Container(
                                  width: double.infinity,
                                  height: height * (52.0 / 852.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: _locationProvider.isValid 
                                      ? const LinearGradient(
                                          colors: [Color(0xFF00A63E), Color(0xFF008236)],
                                          stops: [0.3026, 1.0],
                                        )
                                      : null,
                                    color: !_locationProvider.isValid ? Colors.grey.shade300 : null,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8.0),
                                      onTap: _locationProvider.isValid && !_locationProvider.isLoading
                                          ? () {
                                              _locationProvider.saveAndContinue(onSuccess: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const ProfileCompletedScreen(),
                                                  ),
                                                );
                                                widget.onSaveAndContinue?.call();
                                              });
                                            }
                                          : null,
                                      child: Center(
                                        child: _locationProvider.isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                'Save & Continue',
                                                style: TextStyle(
                                                  color: _locationProvider.isValid ? Colors.white : Colors.grey.shade500,
                                                  fontSize: width * (16.0 / 393.0),
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                            
                            SizedBox(height: height * (40.0 / 852.0)), // Bottom padding
                          ],
                        ),
                      ),
                      
                      // Back Button Layer
                      Positioned(
                        top: height * (24.0 / 852.0),
                        left: width * (24.0 / 393.0),
                        child: _buildBackButton(width),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required double width,
    required double height,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: width * (12.0 / 393.0),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4B5563),
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: height * (8.0 / 852.0)),
        Container(
          height: height * (56.0 / 852.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: width * (16.0 / 393.0)),
          alignment: Alignment.centerLeft,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hintText,
                style: TextStyle(
                  fontSize: width * (14.0 / 393.0),
                  color: const Color(0xFF9CA3AF),
                  fontFamily: 'Inter',
                ),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: const Color(0xFF1F2937),
                size: width * (24.0 / 393.0),
              ),
              style: TextStyle(
                fontSize: width * (14.0 / 393.0),
                color: const Color(0xFF1F2937), // Black when selected
                fontFamily: 'Inter',
              ),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required Function(String) onChanged,
    required String? errorText,
    required TextInputType keyboardType,
    required IconData prefixIcon,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    required double width,
    required double height,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: width * (12.0 / 393.0),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4B5563),
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: height * (8.0 / 852.0)),
        Container(
          height: height * (56.0 / 852.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: width * (16.0 / 393.0)),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                prefixIcon,
                color: const Color(0xFF9CA3AF),
                size: width * (20.0 / 393.0),
              ),
              SizedBox(width: width * (12.0 / 393.0)),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  inputFormatters: inputFormatters,
                  style: TextStyle(
                    fontSize: width * (14.0 / 393.0),
                    color: const Color(0xFF1F2937), // Black when typed
                    fontFamily: 'Inter',
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: width * (14.0 / 393.0),
                      color: const Color(0xFF9CA3AF),
                      fontFamily: 'Inter',
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    counterText: '', // Hide default max length counter
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: height * (8.0 / 852.0)),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: width * (12.0 / 393.0),
                fontFamily: 'Inter',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBackButton(double width) {
    return Container(
      width: width * (48.0 / 393.0),
      height: width * (48.0 / 393.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: widget.onBackPressed,
          child: Center(
            child: Icon(
              Icons.arrow_back,
              color: const Color(0xFF111827),
              size: width * (20.0 / 393.0),
            ),
          ),
        ),
      ),
    );
  }
}
