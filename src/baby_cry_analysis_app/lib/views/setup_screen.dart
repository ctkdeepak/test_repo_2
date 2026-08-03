import 'package:baby_cry_analysis_app/controllers/analysis_controller.dart';
import 'package:baby_cry_analysis_app/utils/constants.dart';
import 'package:baby_cry_analysis_app/views/analysis_report.dart';
import 'package:baby_cry_analysis_app/views/upload_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class BabyCrySetupScreen extends StatefulWidget {
  const BabyCrySetupScreen({super.key});

  @override
  State<BabyCrySetupScreen> createState() => _BabyCrySetupScreenState();
}

class _BabyCrySetupScreenState extends State<BabyCrySetupScreen> {

  BabyCryAnalysisController babyCryAnalysisController = Get.put(BabyCryAnalysisController());

  final _formKey = GlobalKey<FormState>();
  final _pidController = TextEditingController();
  final _nameController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedGender;
  String? _selectedActualReason;
  String? _uploadedFileName;

  // Color Palette
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color secondaryColor = Color(0xFF7C3AED);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color dangerColor = Color(0xFFEF4444);
  static const Color darkColor = Color(0xFF1E293B);
  static const Color greyColor = Color(0xFF64748B);
  static const Color lightGreyColor = Color(0xFFF1F5F9);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  void dispose() {
    _pidController.dispose();
    _nameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Baby Cry Analysis',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: 22,
            tooltip: 'Back to Dashboard',
            splashRadius: 24,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            onPressed: () {
              Get.to(() => const UploadHistoryScreen());
            },
          ),

          IconButton(
            icon: const Icon(Icons.restart_alt_rounded, color: Colors.white),
            onPressed: _resetForm,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.white,
              const Color(0xFFF8FAFC),
            ],
          ),
        ),
        child: GetBuilder<BabyCryAnalysisController>(
          builder: (controller) {
            final bool isFormValid = controller.isFormValid;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPatientInfoCard(controller),
                    const SizedBox(height: 12),

                    _buildAudioRecordingCard(controller, isFormValid),
                    const SizedBox(height: 12),

                    _buildActionButtons(controller),
                    const SizedBox(height: 12),

                    // _buildUploadAudioCard(controller, isFormValid),
                    // const SizedBox(height: 12),

                    if (controller.errorMessage != null && controller.errorMessage!.isNotEmpty)
                      _buildErrorMessage(controller.errorMessage!),

                    if (controller.isLoading || controller.isUploading)
                      _buildLoadingIndicator(controller.isUploading ? 'Uploading data...' : 'Analyzing baby cry...'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard(BabyCryAnalysisController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person_outline, color: primaryColor, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'Patient Information',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkColor,
                  ),
                ),
                const Spacer(),
                if (controller.isFormValid)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: successColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Ready',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _pidController,
                    decoration: InputDecoration(
                      labelText: 'Patient ID *',
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: greyColor,
                      ),
                      hintText: 'Enter patient ID',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: greyColor.withOpacity(0.6),
                      ),
                      prefixIcon: const Icon(Icons.badge, color: primaryColor, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: lightGreyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: lightGreyColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: darkColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Patient ID is required';
                      if (value.startsWith('0')) return 'ID should not start with zero';
                      if (value.length < 1) return 'ID must be at least 1 character';
                      if (value.length > 7) return 'ID must not exceed 7 characters';
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'ID must contain only numbers';
                      return null;
                    },
                    onChanged: (value) {
                      controller.updatePatientInfo(pid: value);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(7),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Patient Name *',
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: greyColor,
                      ),
                      hintText: 'Enter patient name',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: greyColor.withOpacity(0.6),
                      ),
                      prefixIcon: const Icon(Icons.person, color: primaryColor, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: lightGreyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: lightGreyColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: darkColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Patient name is required';
                      return null;
                    },
                    onChanged: (value) {
                      controller.updatePatientInfo(name: value);
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(39),
                      FilteringTextInputFormatter.allow(RegExp("[A-Za-z\' '.]")),
                    ],
                  ),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender *',
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: greyColor,
                      ),
                      prefixIcon: const Icon(Icons.people, color: primaryColor, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: lightGreyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _selectedGender != null ? successColor : lightGreyColor,
                          width: _selectedGender != null ? 1.5 : 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: darkColor,
                    ),
                    hint: Text(
                      'Select gender',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: greyColor.withOpacity(0.6),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: _selectedGender != null ? successColor : greyColor,
                    ),
                    items: AppConstants.genderOptions.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: darkColor,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                        controller.updatePatientInfo(gender: value);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please select gender';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Age (Day / Month / Year) *',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: greyColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dayController,
                              decoration: InputDecoration(
                                labelText: 'Days',
                                labelStyle: GoogleFonts.inter(fontSize: 11, color: greyColor),
                                hintText: '0-31',
                                hintStyle: GoogleFonts.inter(fontSize: 11, color: greyColor.withOpacity(0.5)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: lightGreyColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: lightGreyColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: primaryColor, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: GoogleFonts.inter(fontSize: 14, color: darkColor),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Required';
                                final int? days = int.tryParse(value);
                                if (days == null || days < 0 || days > 31) return 'Invalid';
                                return null;
                              },
                              onChanged: (value) {
                                final day = int.tryParse(value) ?? 0;
                                babyCryAnalysisController.updatePatientInfo(day: day);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _monthController,
                              decoration: InputDecoration(
                                labelText: 'Months',
                                labelStyle: GoogleFonts.inter(fontSize: 11, color: greyColor),
                                hintText: '0-12',
                                hintStyle: GoogleFonts.inter(fontSize: 11, color: greyColor.withOpacity(0.5)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: lightGreyColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: lightGreyColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: primaryColor, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: GoogleFonts.inter(fontSize: 14, color: darkColor),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Required';
                                final int? months = int.tryParse(value);
                                if (months == null || months < 0 || months > 12) return 'Invalid';
                                return null;
                              },
                              onChanged: (value) {
                                final month = int.tryParse(value) ?? 0;
                                babyCryAnalysisController.updatePatientInfo(month: month);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _yearController,
                              decoration: InputDecoration(
                                labelText: 'Years',
                                labelStyle: GoogleFonts.inter(fontSize: 11, color: greyColor),
                                hintText: '0-18',
                                hintStyle: GoogleFonts.inter(fontSize: 11, color: greyColor.withOpacity(0.5)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: lightGreyColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: lightGreyColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: primaryColor, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: GoogleFonts.inter(fontSize: 14, color: darkColor),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Required';
                                final int? years = int.tryParse(value);
                                if (years == null || years < 0 || years > 18) return 'Invalid';
                                return null;
                              },
                              onChanged: (value) {
                                final year = int.tryParse(value) ?? 0;
                                babyCryAnalysisController.updatePatientInfo(year: year);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: _selectedActualReason,
                    decoration: InputDecoration(
                      labelText: 'Actual Reason',
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: greyColor,
                      ),
                      prefixIcon: const Icon(Icons.medical_information, color: primaryColor, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: lightGreyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _selectedActualReason != null && _selectedActualReason!.isNotEmpty
                              ? successColor
                              : lightGreyColor,
                          width: _selectedActualReason != null && _selectedActualReason!.isNotEmpty ? 1.5 : 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: darkColor,
                    ),
                    hint: Text(
                      'Select reason (optional)',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: greyColor.withOpacity(0.6),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: _selectedActualReason != null && _selectedActualReason!.isNotEmpty
                          ? successColor
                          : greyColor,
                    ),
                    items: AppConstants.actualReasonOptions.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: darkColor,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedActualReason = value;
                        controller.updatePatientInfo(actualReason: value);
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          labelStyle: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: greyColor,
                          ),
                          hintText: 'Enter additional notes (optional)',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: greyColor.withOpacity(0.6),
                          ),
                          prefixIcon: const Icon(Icons.note, color: primaryColor, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: lightGreyColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: lightGreyColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: primaryColor, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: darkColor,
                        ),
                        maxLines: 4,
                        onChanged: (value) {
                          controller.updatePatientInfo(notes: value);
                          setState(() {});
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(200),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_notesController.text.length}/200',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: _notesController.text.length >= 180
                                ? dangerColor
                                : _notesController.text.length >= 150
                                ? warningColor
                                : greyColor,
                          ),
                        ),
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
  }

  Widget _buildAudioRecordingCard(BabyCryAnalysisController controller, bool isFormValid) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isFormValid ? successColor.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.mic,
                    color: isFormValid ? successColor : Colors.grey[400],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Audio Recording',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isFormValid ? darkColor : Colors.grey[400],
                  ),
                ),
                if (!isFormValid) ...[
                ],
                const Spacer(),
                if (isFormValid && controller.audioSourceType == 'recorded')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Active',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: successColor,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            if (!isFormValid)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: warningColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: warningColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: warningColor, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Complete all mandatory fields to unlock recording',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: warningColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (isFormValid) ...[
              if (controller.audioSourceType == 'uploaded')
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: warningColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: warningColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: warningColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Uploaded audio is active.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: warningColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 2),
              _buildRecordingControls(controller),
              const SizedBox(height: 8),
              if (!controller.isRecording &&
                  controller.recordingPath != null &&
                  controller.audioSourceType == 'recorded')
                _buildRecordedAudioPlayback(controller),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingControls(BabyCryAnalysisController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (!controller.isRecording)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await controller.startRecording();
                      setState(() {});
                    } catch (e) {
                      Get.snackbar('Error', e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: dangerColor, colorText: Colors.white,
                          duration: const Duration(seconds: 3));
                    }
                  },
                  icon: const Icon(Icons.mic, size: 18),
                  label: Text(
                    'Start Recording',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.audioSourceType == 'uploaded'
                        ? Colors.grey[400]
                        : successColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            if (controller.isRecording) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      if (controller.isRecordingPaused) {
                        await controller.resumeRecording();
                      } else {
                        await controller.pauseRecording();
                      }
                    } catch (e) {
                      Get.snackbar('Error', e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: dangerColor, colorText: Colors.white,
                          duration: const Duration(seconds: 3));
                    }
                  },
                  icon: Icon(controller.isRecordingPaused ? Icons.play_arrow : Icons.pause, size: 18),
                  label: Text(
                    controller.isRecordingPaused ? 'Resume' : 'Pause',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: warningColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await controller.stopRecording();
                      setState(() {});
                      final fileName = controller.recordingPath?.split('/').last;
                      Get.snackbar('Success', 'Recording saved: $fileName',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: successColor, colorText: Colors.white,
                          duration: const Duration(seconds: 3));
                    } catch (e) {
                      Get.snackbar('Error', e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: dangerColor, colorText: Colors.white,
                          duration: const Duration(seconds: 3));
                    }
                  },
                  icon: const Icon(Icons.stop, size: 18),
                  label: Text(
                    'Stop',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dangerColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (controller.isRecording) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: dangerColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: dangerColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.fiber_manual_record, color: dangerColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Recording...',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: dangerColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: controller.isRecordingPaused
                        ? warningColor.withOpacity(0.1)
                        : successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.isRecordingPaused ? '⏸ Paused' : '● Active',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: controller.isRecordingPaused ? warningColor : successColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.timer, color: controller.isRecordingPaused ? warningColor : dangerColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(controller.recordingDuration),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: controller.isRecordingPaused ? warningColor : dangerColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRecordedAudioPlayback(BabyCryAnalysisController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: successColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: successColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.mic, color: successColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.recordingPath?.split('/').last ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: successColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: controller.isPlaying ? warningColor : successColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 22,
                  onPressed: () async {
                    try {
                      if (controller.isPlaying) {
                        await controller.pauseAudio();
                      } else {
                        await controller.playAudio();
                      }
                    } catch (e) {
                      Get.snackbar('Error', e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: dangerColor, colorText: Colors.white,
                          duration: const Duration(seconds: 3));
                    }
                  },
                  icon: Icon(
                    controller.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 22,
                onPressed: () async {
                  try {
                    await controller.discardRecording();
                    Get.snackbar('Info', 'Audio discarded',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.grey, colorText: Colors.white,
                        duration: const Duration(seconds: 2));
                  } catch (e) {
                    Get.snackbar('Error', e.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: dangerColor, colorText: Colors.white,
                        duration: const Duration(seconds: 3));
                  }
                },
                icon: const Icon(Icons.delete, size: 22),
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                _formatDuration(controller.audioPosition),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: successColor,
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: successColor,
                    overlayColor: successColor.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: controller.audioDuration.inSeconds > 0
                        ? controller.audioPosition.inSeconds.clamp(0, controller.audioDuration.inSeconds).toDouble()
                        : 0,
                    min: 0,
                    max: controller.audioDuration.inSeconds > 0
                        ? controller.audioDuration.inSeconds.toDouble()
                        : 1,
                    onChanged: (value) {
                      controller.seekAudio(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(controller.audioDuration),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadAudioCard(BabyCryAnalysisController controller, bool isFormValid) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: borderColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isFormValid ? secondaryColor.withOpacity(0.08) : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.folder_open,
                    color: isFormValid ? secondaryColor : Colors.grey[400],
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Upload Existing Audio',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isFormValid ? darkColor : Colors.grey[400],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Alternative',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                if (isFormValid && controller.audioSourceType == 'uploaded')
                  Container(
                    margin: const EdgeInsets.only(left: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Active',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: secondaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: isFormValid ? greyColor : Colors.grey[400],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Skip recording and use an existing .wav audio file from your device',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: isFormValid ? greyColor : Colors.grey[400],
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            if (!isFormValid)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: warningColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: warningColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: warningColor, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Complete patient info to upload audio',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: warningColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (isFormValid) ...[
              if (controller.audioSourceType == 'recorded')
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: warningColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: warningColor.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: warningColor, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'This will replace your recorded audio',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: warningColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              _buildUploadButton(controller),
              const SizedBox(height: 6),
              if (controller.audioSourceType == 'uploaded' && controller.uploadedFileName != null)
                _buildUploadedAudioPlayback(controller),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(BabyCryAnalysisController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              try {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['wav'],
                );

                if (result != null && result.files.single.path != null) {
                  final filePath = result.files.single.path!;
                  final fileName = result.files.single.name;

                  if (controller.recordingPath != null) {
                    await controller.discardRecording();
                  }

                  controller.setAudioFile(filePath, fileName);

                  setState(() {});

                  Get.snackbar('Success', 'Audio selected: $fileName',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: successColor, colorText: Colors.white,
                      duration: const Duration(seconds: 2));
                }
              } catch (e) {
                Get.snackbar('Error', e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: dangerColor, colorText: Colors.white,
                    duration: const Duration(seconds: 3));
              }
            },
            icon: Icon(
              Icons.folder_open,
              size: 18,
              color: controller.audioSourceType == 'recorded'
                  ? warningColor
                  : secondaryColor,
            ),
            label: Text(
              'Browse & Select WAV File',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: controller.audioSourceType == 'recorded'
                    ? warningColor
                    : secondaryColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: controller.audioSourceType == 'recorded'
                  ? warningColor
                  : secondaryColor,
              side: BorderSide(
                color: controller.audioSourceType == 'recorded'
                    ? warningColor
                    : secondaryColor,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Text(
            'Supported: .wav format only',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadedAudioPlayback(BabyCryAnalysisController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: secondaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_file, color: secondaryColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.uploadedFileName ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: secondaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: controller.isPlaying ? warningColor : secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 22,
                  onPressed: () async {
                    try {
                      if (controller.isPlaying) {
                        await controller.pauseAudio();
                      } else {
                        await controller.playAudio();
                      }
                    } catch (e) {
                      Get.snackbar('Error', e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: dangerColor, colorText: Colors.white,
                          duration: const Duration(seconds: 3));
                    }
                  },
                  icon: Icon(
                    controller.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 22,
                onPressed: () async {
                  try {
                    await controller.discardRecording();
                    setState(() {
                      _uploadedFileName = null;
                    });
                    Get.snackbar('Info', 'Audio discarded',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.grey, colorText: Colors.white,
                        duration: const Duration(seconds: 2));
                  } catch (e) {
                    Get.snackbar('Error', e.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: dangerColor, colorText: Colors.white,
                        duration: const Duration(seconds: 3));
                  }
                },
                icon: const Icon(Icons.delete, size: 22),
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                _formatDuration(controller.audioPosition),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: secondaryColor,
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: secondaryColor,
                    overlayColor: secondaryColor.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: controller.audioDuration.inSeconds > 0
                        ? controller.audioPosition.inSeconds.clamp(0, controller.audioDuration.inSeconds).toDouble()
                        : 0,
                    min: 0,
                    max: controller.audioDuration.inSeconds > 0
                        ? controller.audioDuration.inSeconds.toDouble()
                        : 1,
                    onChanged: (value) {
                      controller.seekAudio(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(controller.audioDuration),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BabyCryAnalysisController controller) {
    final bool isFormValid = controller.isFormValid;
    final bool isAudioReady = controller.isAudioAvailable;
    final bool isReady = isFormValid && isAudioReady && !controller.isLoading && !controller.isUploading;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: borderColor,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'CHOOSE OPERATION',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: greyColor,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: borderColor,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Container(
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: secondaryColor.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 18,
                      color: isReady ? secondaryColor : Colors.grey[400],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Upload Data',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isReady ? darkColor : Colors.grey[400],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Data Collection',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload patient info and audio to backend server for dataset collection',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: isReady ? greyColor : Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isReady
                        ? () async {
                      final success = await controller.uploadData();
                      if (success && mounted) {
                        Get.snackbar(
                          'Success',
                          'Data uploaded successfully!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: successColor,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                        _resetForm();
                      } else if (controller.errorMessage != null && mounted) {
                        Get.snackbar(
                          'Upload Failed',
                          controller.errorMessage!,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: dangerColor,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    }
                        : null,
                    icon: controller.isUploading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.cloud_upload, size: 20),
                    label: Text(
                      controller.isUploading ? 'Uploading...' : 'Upload Data',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isReady ? secondaryColor : Colors.grey[400],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: borderColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  'OR',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: greyColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: borderColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primaryColor.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_outlined,
                      size: 18,
                      color: isReady ? primaryColor : Colors.grey[400],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Predict Now',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isReady ? darkColor : Colors.grey[400],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'AI Analysis',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: successColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Send audio to AI server for baby cry analysis and get prediction results',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: isReady ? greyColor : Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isReady
                        ? () async {
                      final result = await controller.predictCry();
                      if (result != null && mounted) {
                        setState(() => _uploadedFileName = null);

                        final predictionLabel = controller.predictionLabel ?? 'Unknown';
                        final confidenceScore = controller.confidenceScore ?? '0%';

                        Get.to(
                              () => BabyCryAnalysisReport(
                            predictionLabel: predictionLabel,
                            confidenceScore: confidenceScore,
                          ),
                        )?.then((_) {
                          controller.reset();
                          _resetForm();
                        });
                      } else if (controller.errorMessage != null && mounted) {
                        Get.snackbar(
                          'Prediction Failed',
                          controller.errorMessage!,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: dangerColor,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    }
                        : null,
                    icon: controller.isLoading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.auto_awesome, size: 20),
                    label: Text(
                      controller.isLoading ? 'Analyzing...' : 'Predict Now',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isReady ? primaryColor : Colors.grey[400],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dangerColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dangerColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: dangerColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: dangerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: darkColor,
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _pidController.clear();
    _nameController.clear();
    _dayController.clear();
    _monthController.clear();
    _yearController.clear();
    _notesController.clear();
    setState(() {
      _selectedGender = null;
      _selectedActualReason = null;
      _uploadedFileName = null;
    });
    babyCryAnalysisController.reset();
    Get.snackbar('Info', 'Form reset successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey, colorText: Colors.white,
        duration: const Duration(seconds: 2));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

}
