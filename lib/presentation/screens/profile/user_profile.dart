// presentation/screens/profile/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_faysal_game/presentation/screens/home/provider/home_provider.dart';
import 'package:flutter_faysal_game/data/models/user_profile.dart';
import 'package:flutter_faysal_game/core/constants/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  final GlobalKey _certificateKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _downloadCertificate() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.neonGreen),
                SizedBox(height: 16.h),
                Text(
                  'Generating Certificate...',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),
      );

      // Capture certificate as image
      RenderRepaintBoundary boundary = _certificateKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save to temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/greenlife_certificate.png');
      await file.writeAsBytes(pngBytes);

      Navigator.pop(context); // Close loading dialog

      // Share the certificate
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My GreenLife Certificate of Completion! 🌱',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Certificate saved and ready to share!'),
            backgroundColor: AppColors.neonGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate certificate. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black87,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 22.sp,
            ),
            onPressed: () {
              // TODO: Navigate to edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile - Coming Soon!')),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<AppUser?>(
        stream: context.read<HomeProvider>().userFullStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.neonGreen),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                  SizedBox(height: 16.h),
                  Text(
                    'Failed to load profile',
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  ),
                ],
              ),
            );
          }

          final user = snapshot.data;
          if (user == null) {
            return Center(
              child: Text(
                'No user data available',
                style: TextStyle(fontSize: 16.sp),
              ),
            );
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar & Basic Info
                  _buildProfileHeader(user, isDark),
                  SizedBox(height: 32.h),

                  // Stats Cards
                  _buildStatsSection(user, isDark),
                  SizedBox(height: 32.h),

                  // User Details Section
                  _buildDetailsSection(user, isDark),
                  SizedBox(height: 32.h),

                  // Certificate Section
                  _buildCertificateSection(user, isDark),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(AppUser user, bool isDark) {
    return Column(
      children: [
        // Avatar with gradient border
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.neonGreen, AppColors.neonBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonGreen.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60.r,
            backgroundColor: isDark ? Colors.grey[850] : Colors.grey[200],
            backgroundImage: user.profile.photoURL != null
                ? NetworkImage(user.profile.photoURL!)
                : null,
            child: user.profile.photoURL == null
                ? Icon(
                    Icons.person,
                    size: 60.sp,
                    color: isDark ? Colors.white54 : Colors.black54,
                  )
                : null,
          ),
        ),
        SizedBox(height: 16.h),

        // Name
        Text(
          user.profile.displayName ?? user.profile.username,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),

        // Email
        Text(
          user.profile.email,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),

        // Level Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.neonGreen, AppColors.neonBlue],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonGreen.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.white, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                'Level ${user.stats.level}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(AppUser user, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Green Coins',
            '${user.stats.greenCoins}',
            Icons.monetization_on,
            AppColors.neonGreen,
            isDark,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'Streak',
            '${user.stats.streak} days',
            Icons.local_fire_department,
            Colors.orange,
            isDark,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'Completed',
            '${user.stats.completedDays}',
            Icons.check_circle,
            AppColors.neonBlue,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(AppUser user, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.neonBlue.withOpacity(0.1),
            AppColors.neonGreen.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.neonBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: AppColors.neonBlue, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'User Details',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          _buildDetailRow(
            'Username',
            user.profile.username,
            Icons.account_circle,
            isDark,
          ),
          _buildDivider(isDark),
          _buildDetailRow(
            'Display Name',
            user.profile.displayName ?? 'Not set',
            Icons.badge,
            isDark,
          ),
          _buildDivider(isDark),
          _buildDetailRow(
            'Email',
            user.profile.email,
            Icons.email,
            isDark,
          ),
        
          _buildDivider(isDark),
          _buildDetailRow(
            'Total Points',
            '${user.stats.xp}',
            Icons.stars,
            isDark,
          ),
          _buildDivider(isDark),
          _buildDetailRow(
            'Achievements',
            '${user.stats.completedDays}',
            Icons.emoji_events,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? Colors.white10 : Colors.black12,
      height: 1,
    );
  }

  Widget _buildCertificateSection(AppUser user, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.neonGreen.withOpacity(0.1),
            AppColors.neonGreen.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.neonGreen.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium,
                  color: AppColors.neonGreen, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Certificate of Completion',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Certificate Preview
          RepaintBoundary(
            key: _certificateKey,
            child: _buildCertificate(user),
          ),
          SizedBox(height: 16.h),

          // Download Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _downloadCertificate,
              icon: Icon(Icons.download, size: 20.sp),
              label: Text(
                'Download & Share Certificate',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 4,
                shadowColor: AppColors.neonGreen.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Share your achievement on LinkedIn and social media!',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.white60 : Colors.black54,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCertificate(AppUser user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Certificate ID
          Text(
            'GLF-2025-3X-001',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),

          // Title
          Text(
            'CERTIFICATE',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D32),
              letterSpacing: 2,
            ),
          ),
          Text(
            'OF COMPLETION',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 12.h),

          Text(
            'IS PRESENTED TO :',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.black87,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 16.h),

          // User Name
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 4.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black87, width: 2),
              ),
            ),
            child: Text(
              user.profile.displayName ?? user.profile.username,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.h),

          // Description
          Text(
            'This certificate honors this citizen for their valuable contribution to society through participation in the Green Skills program via the GreenLife app, successfully progressing through three levels of achievement.',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),

          // Signatures
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSignature('Saiful', 'CO FOUNDER', 'Md Saiful Islam'),
              _buildSignature('Synthia', 'FOUNDER', 'Sinthia Mehjabin Megha'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignature(String signature, String title, String name) {
    return Column(
      children: [
        Text(
          signature,
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Cursive',
            fontStyle: FontStyle.italic,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 100.w,
          height: 1,
          color: Colors.black87,
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 9.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}