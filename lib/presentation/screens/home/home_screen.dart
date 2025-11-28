// presentation/screens/home/home_screen.dart
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faysal_game/data/models/user_profile.dart';
import 'package:flutter_faysal_game/presentation/screens/home/model/user_daily_task.dart';
import 'package:flutter_faysal_game/presentation/screens/home/provider/home_provider.dart';
import 'package:flutter_faysal_game/presentation/screens/widgets/background.dart';
import 'package:flutter_faysal_game/presentation/screens/widgets/header.dart';
import 'package:flutter_faysal_game/presentation/screens/widgets/week_challange_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  
  // Text controllers for report form
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final _reportFormKey = GlobalKey<FormState>();

  @override
@override
void initState() {
  super.initState();

  /// ---- SAFE PROVIDER CALL AFTER BUILD ----
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<HomeProvider>(context, listen: false).getUserLocation();
  });

  /// ---- YOUR ANIMATION CONTROLLERS ----
  _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..repeat(reverse: true);

  _pulseAnim = Tween<double>(
    begin: 1.0,
    end: 1.1,
  ).animate(
    CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
  );
}


getUserLocation()async{
  
Provider.of<HomeProvider>(context,listen: false).getUserLocation();
}
  @override
  void dispose() {
    _pulseCtrl.dispose();
    _issueController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Helper method to submit report
  void _submitReport() {
    if (_reportFormKey.currentState!.validate()) {
      // TODO: Implement your report submission logic here
      final issue = _issueController.text.trim();
      final location = _locationController.text.trim();
      
      print('Issue: $issue');
      print('Location: $location');
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Report submitted successfully!'),
          backgroundColor: AppColors.neonGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Clear form
      _issueController.clear();
      _locationController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  // Helper method to launch URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  // Helper method to launch phone dialer
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open phone dialer')),
        );
      }
    }
  }

  // Helper method to launch email
  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri.parse('mailto:$email');
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email client')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FA),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: HomeScreenAnimatedBackground(
              child: CustomScrollView(
                slivers: [
                  UserProfileHeader(),

                  StreamBuilder<List<Challenge>>(
                    stream: context.read<HomeProvider>().getAllChallenges(),
                    builder: (context, snapshot) {
                      // ───── Loading ─────
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 300,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      }

                      // ───── Error ─────
                      if (snapshot.hasError) {
                        return SliverToBoxAdapter(
                          child: SizedBox(
                            height: 120,
                            child: Center(
                              child: Text(
                                'Failed to load challenges',
                                style: TextStyle(color: Colors.red[300]),
                              ),
                            ),
                          ),
                        );
                      }

                      // ───── Empty ─────
                      final challenges = snapshot.data ?? [];
                      if (challenges.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 120,
                            child: Center(child: Text('No challenges yet')),
                          ),
                        );
                      }

                      // ───── Carousel Slider (Horizontal) ─────
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 50.h,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: challenges.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () =>
                                      provider.changeSelectedWeek(index),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          index == provider.selectedWeek
                                              ? AppColors.neonGreen.withOpacity(
                                                  0.3,
                                                )
                                              : AppColors.neonBlue.withOpacity(
                                                  0.3,
                                                ),
                                          index == provider.selectedWeek
                                              ? AppColors.neonGreen.withOpacity(
                                                  0.3,
                                                )
                                              : AppColors.neonBlue.withOpacity(
                                                  0.3,
                                                ),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: AppColors.neonBlue.withOpacity(
                                          0.5,
                                        ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: index == provider.selectedWeek
                                              ? AppColors.neonGreen.withOpacity(
                                                  0.3,
                                                )
                                              : AppColors.neonBlue.withOpacity(
                                                  0.3,
                                                ),
                                          blurRadius: 6,
                                          spreadRadius: 0.5,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      "${challenges[index].week} week",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: index == provider.selectedWeek
                                                ? AppColors.neonGreen
                                                    .withOpacity(
                                                    0.3,
                                                  )
                                                : AppColors.neonBlue
                                                    .withOpacity(
                                                    0.3,
                                                  ),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Weekly Challenges Stream
                  StreamBuilder<List<Challenge>>(
                    stream: context.read<HomeProvider>().getAllChallenges(),
                    builder: (context, snapshot) {
                      // ───── Loading ─────
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 300,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      }

                      // ───── Error ─────
                      if (snapshot.hasError) {
                        return SliverToBoxAdapter(
                          child: SizedBox(
                            height: 120,
                            child: Center(
                              child: Text(
                                'Failed to load challenges',
                                style: TextStyle(color: Colors.red[300]),
                              ),
                            ),
                          ),
                        );
                      }

                      // ───── Empty ─────
                      final challenges = snapshot.data ?? [];
                      if (challenges.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 120,
                            child: Center(child: Text('No challenges yet')),
                          ),
                        );
                      }

                      // ───── Carousel Slider (Horizontal) ─────
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 450.h,
                          child: CarouselSlider.builder(
                            itemCount:
                                challenges[provider.selectedWeek].tasks.length,
                            itemBuilder: (context, index, realIndex) {
                              final task =
                                  challenges[provider.selectedWeek].tasks;
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: // First, update your user model to track completed days per week
// Then update the logic in your home screen

StreamBuilder<AppUser?>(
  stream: provider.userFullStream(),
  builder: (context, snapshot) {
    // 1. Loading state
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Error state
    if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    }

    // 3. No user data
    final user = snapshot.data;
    if (user == null) {
      return const SizedBox.shrink();
    }

    // 4. Calculate completed days for the SELECTED WEEK
    // selectedWeek is 0-indexed (0 = Week 1, 1 = Week 2, etc.)
    final currentWeekNumber = provider.selectedWeek + 1;
    
    // Calculate total days before current week
    final daysBeforeCurrentWeek = provider.selectedWeek * 7;
    
    // Calculate how many days are completed in the current week
    final totalCompletedDays = user.stats.completedDays;
    
    // Days completed in current week
    int completedDaysInCurrentWeek = 0;
    if (totalCompletedDays > daysBeforeCurrentWeek) {
      completedDaysInCurrentWeek = totalCompletedDays - daysBeforeCurrentWeek;
      if (completedDaysInCurrentWeek > 7) {
        completedDaysInCurrentWeek = 7; // Max 7 days per week
      }
    }

    // 5. Determine lock & completed state for THIS week's day
    final isCompleted = index < completedDaysInCurrentWeek;
    final isLocked = index > completedDaysInCurrentWeek;

    // 6. Show task card
    return DailyTaskUploadCard(
      index: index,
      weekTitle: task[index].day.toString(),
      mainTask: task[index].task,
      imageurl: challenges[provider.selectedWeek].badgeUrl,
      isLocked: isLocked,
      isCompleted: isCompleted,
      onComplete: () {
        print('Task done!');
      },
    );
  },
) );
                            },
                            options: CarouselOptions(
                              height: 380.h,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 4),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.easeInOutCubic,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.25,
                              viewportFraction: 0.75,
                              enableInfiniteScroll: challenges.length > 1,
                              pageSnapping: true,
                              padEnds: true,
                              disableCenter: true,
                              scrollPhysics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (idx, reason) {},
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // ═══════════════════════════════════════════════════════
                  // SUBMIT REPORT FORM
                  // ═══════════════════════════════════════════════════════
                  SliverToBoxAdapter(
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 24.w,
      vertical: 16.h,
    ),
    child: Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.neonPurple.withOpacity(0.15), // You can change to any color
            AppColors.neonPurple.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.neonPurple.withOpacity(0.3), // Match with gradient color
          width: 1.5,
        ),
      ),
      child: Form(
        key: _reportFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.neonPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.report_problem_outlined,
                    color: AppColors.neonPurple,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Submit Report',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            
            // Description text
            Text(
              'Report any issues or problems you encounter.',
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            SizedBox(height: 20.h),

            // Issue TextField
            TextFormField(
              controller: _issueController,
              maxLines: 4,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                labelText: 'Describe the Issue',
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14.sp,
                ),
                hintText: 'Please provide detailed information about the issue...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontSize: 13.sp,
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.neonPurple.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.neonPurple.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.neonPurple,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.red.withOpacity(0.5),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.description_outlined,
                  color: AppColors.neonPurple,
                  size: 20.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please describe the issue';
                }
                if (value.trim().length < 10) {
                  return 'Issue description must be at least 10 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Location TextField
            TextFormField(
              controller: _locationController,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14.sp,
                ),
                hintText: 'Where did this issue occur?',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontSize: 13.sp,
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.neonPurple.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.neonPurple.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.neonPurple,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.red.withOpacity(0.5),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.neonPurple,
                  size: 20.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter location';
                }
                return null;
              },
            ),
            SizedBox(height: 20.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitReport,
                icon: Icon(Icons.send_rounded, size: 20.sp),
                label: Text(
                  'Submit Report',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
             // ═══════════════════════════════════════════════════════
                  // SUPPORT & HELP CARDS
                  // ═══════════════════════════════════════════════════════
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Title
                          Text(
                            'Need Assistance?',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // ──────────────────────────────────────────────
                          // GET HELP CARD
                          // ──────────────────────────────────────────────
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.neonBlue.withOpacity(0.15),
                                  AppColors.neonBlue.withOpacity(0.05),
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
                                    Container(
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.neonBlue
                                            .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(
                                        Icons.support_agent,
                                        color: AppColors.neonBlue,
                                        size: 24.sp,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'Get Help',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Contact our support team for assistance.',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 16.h),

                                // Helpline Button
                                InkWell(
                                  onTap: () => _launchPhone('01310706874'),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: AppColors.neonGreen,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Helpline: ',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        '01310706874',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.neonGreen,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.h),

                                // Email Button
                                InkWell(
                                  onTap: () =>
                                      _launchEmail('support@greenlife.com'),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: AppColors.neonGreen,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Email: ',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          'support@greenlife.com',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.neonGreen,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // ──────────────────────────────────────────────
                          // VIDEO TUTORIALS CARD
                          // ──────────────────────────────────────────────
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.neonGreen.withOpacity(0.15),
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
                                    Container(
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.neonGreen
                                            .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        color: AppColors.neonGreen,
                                        size: 24.sp,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'Tutorial Videos',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Watch how to use GreenLife.',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 16.h),

                                // Watch Videos Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: Navigate to video tutorials screen or open YouTube
                                      // _launchUrl('https://youtube.com/your-channel');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Video Tutorials - Coming Soon!'),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.video_library,
                                        size: 20.sp),
                                    label: Text(
                                      'Watch Tutorials',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.neonGreen,
                                      foregroundColor: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}