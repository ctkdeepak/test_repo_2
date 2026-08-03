import 'package:baby_cry_analysis_app/controllers/analysis_controller.dart';
import 'package:baby_cry_analysis_app/services/storage_services.dart';
import 'package:baby_cry_analysis_app/views/app_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:baby_cry_analysis_app/models/patient_info.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BabyCryAnalysisReport extends StatefulWidget {
  final String predictionLabel;
  final String confidenceScore;

  const BabyCryAnalysisReport({
    super.key,
    required this.predictionLabel,
    required this.confidenceScore,
  });

  @override
  State<BabyCryAnalysisReport> createState() => _BabyCryAnalysisReportState();
}

class _BabyCryAnalysisReportState extends State<BabyCryAnalysisReport> {

  final BabyCryAnalysisController controller = Get.find<BabyCryAnalysisController>();

  final GlobalKey _formKey = GlobalKey();
  bool _isLoading = true;

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color secondaryPurple = Color(0xFF7C3AED);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color textLightGrey = Color(0xFF94A3B8);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();
    _setPortraitOrientation();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });

    print('=== Report Data from Controller ===');
    print('PID: ${controller.patientInfo.pid}');
    print('Name: ${controller.patientInfo.name}');
    print('Gender: ${controller.patientInfo.gender}');
    print('Age: ${controller.patientInfo.ageDisplay}');
    print('Actual Reason: ${controller.patientInfo.actualReason}');
    print('Notes: ${controller.patientInfo.notes}');
    print('Prediction Label: ${widget.predictionLabel}');
    print('Confidence Score: ${widget.confidenceScore}');
    print('====================================');
  }

  Future<void> _setPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  back() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      Get.offAll(() => const AppDashboard());
    } catch (e) {
      print("Error in back navigation: $e");
      Get.offAll(() => const AppDashboard());
    }
  }

  String _getFormattedAge() {
    final patientInfo = controller.patientInfo;
    final years = patientInfo.year ?? 0;
    final months = patientInfo.month ?? 0;
    final days = patientInfo.day ?? 0;

    List<String> parts = [];

    if (years > 0) {
      parts.add('$years ${years == 1 ? 'Year' : 'Years'}');
    }
    if (months > 0) {
      parts.add('$months ${months == 1 ? 'Month' : 'Months'}');
    }
    if (days > 0) {
      parts.add('$days ${days == 1 ? 'Day' : 'Days'}');
    }

    if (parts.isEmpty) {
      return '0 Days';
    }

    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return loadingAPI();
    }

    final patientInfo = controller.patientInfo;
    final reportTime = controller.reportGenerationTime;
    final formattedAge = _getFormattedAge();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analysis Report',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: 22,
            tooltip: 'Back to Dashboard',
            splashRadius: 24,
            onPressed: () async {
              await back();
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: IconButton(
              icon: const Icon(
                Icons.picture_as_pdf_outlined,
                size: 22,
              ),
              tooltip: 'Export as PDF',
              splashRadius: 24,
              onPressed: savePdf,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: IconButton(
              icon: const Icon(
                Icons.share_outlined,
                size: 22,
              ),
              tooltip: 'Share Report',
              splashRadius: 24,
              onPressed: () => sharePdf(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RepaintBoundary(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildReportHeader(reportTime),
                      const SizedBox(height: 12),

                      _buildPatientInfoCard(patientInfo, formattedAge),
                      const SizedBox(height: 12),

                      _buildAIResultsCard(),

                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportHeader(DateTime reportTime) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue,
            secondaryPurple,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.assessment_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "BABY CRY ANALYSIS REPORT",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat("dd MMMM yyyy, hh:mm a").format(reportTime),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfoCard(PatientInfo patientInfo, String formattedAge) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryBlue.withOpacity(0.12),
                        secondaryPurple.withOpacity(0.12),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Patient Information',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoRowCompact(
                            icon: Icons.badge_outlined,
                            label: 'Patient ID',
                            value: patientInfo.pid ?? 'N/A',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoRowCompact(
                            icon: Icons.person_outline,
                            label: 'Patient Name',
                            value: patientInfo.name ?? 'N/A',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoRowCompact(
                            icon: Icons.people_outline,
                            label: 'Gender',
                            value: patientInfo.gender ?? 'N/A',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoRowCompact(
                            icon: Icons.calendar_month_outlined,
                            label: 'Age',
                            value: formattedAge,
                          ),
                        ),
                      ],
                    ),

                    if (patientInfo.actualReason != null && patientInfo.actualReason!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _buildInfoRowFull(
                        icon: Icons.medical_information_outlined,
                        label: 'Actual Reason',
                        value: patientInfo.actualReason!,
                      ),
                    ],

                    if (patientInfo.notes != null && patientInfo.notes!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _buildInfoRowFull(
                        icon: Icons.note_outlined,
                        label: 'Notes',
                        value: patientInfo.notes!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRowCompact({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: textGrey,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textGrey,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowFull({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: textGrey,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textGrey,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildAIResultsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        successGreen.withOpacity(0.12),
                        successGreen.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: successGreen,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Analysis Results',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildResultCard(
                    label: 'Prediction',
                    value: widget.predictionLabel.toUpperCase(),
                    color: primaryBlue,
                    backgroundColor: primaryBlue.withOpacity(0.06),
                    icon: Icons.analytics_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildResultCard(
                    label: 'Accuracy',
                    value: widget.confidenceScore,
                    color: _getConfidenceColor(widget.confidenceScore),
                    backgroundColor: _getConfidenceColor(widget.confidenceScore).withOpacity(0.06),
                    icon: _getConfidenceIcon(widget.confidenceScore),
                    iconColor: _getConfidenceColor(widget.confidenceScore),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String label,
    required String value,
    required Color color,
    required Color backgroundColor,
    required IconData icon,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: iconColor ?? color,
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Divider(color: borderColor, thickness: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.security_rounded,
                size: 14,
                color: textLightGrey,
              ),
              const SizedBox(width: 6),
              Text(
                'Generated by Baby Cry Analysis System v1.0.2',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getConfidenceIcon(String confidence) {
    final value = double.tryParse(confidence.replaceAll('%', '')) ?? 0;
    if (value >= 60) return Icons.thumb_up_alt_rounded;
    if (value >= 40) return Icons.thumbs_up_down_rounded;
    return Icons.thumb_down_alt_rounded;
  }

  Color _getConfidenceColor(String confidence) {
    final value = double.tryParse(confidence.replaceAll('%', '')) ?? 0;
    if (value >= 60) return successGreen;
    if (value >= 40) return warningOrange;
    return dangerRed;
  }

  Future<File?> _savePdfWithAllFilesAccess(List<int> pdfBytes, String fileName) async {
    try {
      final String reportsPath = await StorageService.getReportsPath();
      final String filePath = '$reportsPath/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(pdfBytes, flush: true);

      if (await file.exists()) {
        print('PDF saved to: ${file.path}');
        return file;
      }
      return null;
    } catch (e) {
      print('Save error: $e');
      return null;
    }
  }

  Future<void> savePdf() async {
    try {
      print('=== Starting PDF Save Process ===');

      final permissionStatus = await Permission.storage.request();

      if (!permissionStatus.isGranted) {
        final manageStorageStatus = await Permission.manageExternalStorage.request();

        if (!manageStorageStatus.isGranted) {
          bool shouldOpenSettings = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Permission Required'),
                content: const Text('Storage permission is required to save PDF files.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Open Settings'),
                  ),
                ],
              );
            },
          );

          if (shouldOpenSettings == true) {
            await openAppSettings();
          }
          return;
        }
      }

      print('Storage permission: GRANTED');

      final pdf = pw.Document(version: PdfVersion.pdf_1_5);

      final image = await WidgetWrapper.fromKey(key: _formKey, pixelRatio: 2.0);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(16),
          orientation: pw.PageOrientation.portrait,
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Container(
                  alignment: pw.Alignment.topCenter,
                  child: pw.Image(image),
                ),
                pw.Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: pw.Center(
                    child: pw.Text(
                      'Page 1 of 1',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey400),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      print('PDF generated: ${pdfBytes.length} bytes');

      final String fileName = '${controller.patientInfo.pid}_${DateFormat('ddMMyyyyHHmmss').format(controller.reportGenerationTime)}.pdf';

      final File? savedFile = await _savePdfWithAllFilesAccess(pdfBytes, fileName);

      if (savedFile != null) {
        print('Report successfully saved to: ${savedFile.path}');

        Get.snackbar(
          'PDF Export Successful',
          'The Analysis report has been saved successfully.',
          backgroundColor: successGreen,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );
      } else {
        throw 'Failed to save PDF file. Please ensure "All files access" permission is granted.';
      }

    } catch (e) {
      print('ERROR in savePdf: $e');

      Get.snackbar(
        'Save Failed',
        'Could not save Analysis report: ${e.toString()}',
        backgroundColor: dangerRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> sharePdf() async {
    try {
      print('=== Starting PDF Share Process ===');

      final pdf = pw.Document(version: PdfVersion.pdf_1_5);

      final image = await WidgetWrapper.fromKey(key: _formKey, pixelRatio: 2.0);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(16),
          orientation: pw.PageOrientation.portrait,
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Container(
                  alignment: pw.Alignment.topCenter,
                  child: pw.Image(image),
                ),
                pw.Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: pw.Center(
                    child: pw.Text(
                      'Page 1 of 1',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey400),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      final String reportsPath = await StorageService.getReportsPath();
      final String fileName = '${controller.patientInfo.pid}_${DateFormat('ddMMyyyyHHmmss').format(controller.reportGenerationTime)}.pdf';
      final String filePath = '$reportsPath/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      await Printing.sharePdf(
          bytes: await file.readAsBytes(),
          filename: fileName
      );

      Get.snackbar(
        'Share Successful',
        'Report shared successfully',
        backgroundColor: successGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );

    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Share Failed',
        'Could not share report: ${e.toString()}',
        backgroundColor: dangerRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Widget loadingAPI() {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (val) async {
          await back();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/loading.json',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 20),
              Text(
                'Analyzing Baby Cry Audio',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while the Analysis report is being generated.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
