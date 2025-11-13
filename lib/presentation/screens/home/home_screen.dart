// presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 200.h,
              floating: false,
              pinned: true,
              backgroundColor: isDark ? Colors.black : Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.hunterGreen,
                              AppColors.hunterGreen600,
                            ]
                          : [
                              AppColors.asparagus,
                              AppColors.yellowGreen,
                            ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200.r,
                          height: 200.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 150.r,
                          height: 150.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      // Content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.airplanemode_active,
                              size: 60.r,
                              color: Colors.white,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Corporate Battle',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 26.sp,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              'Arena',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.person_outline, color: isDark ? Colors.white : Colors.black87),
                  onPressed: () {
                    // Navigate to profile
                  },
                ),
                SizedBox(width: 8.w),
              ],
            ),

            // ── Content ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    _buildWelcomeSection(auth, theme, isDark),
                    SizedBox(height: 32.h),

                    // Start Battle Button
                    _buildStartBattleButton(theme, isDark),
                    SizedBox(height: 24.h),

                    // Quick Stats
                    _buildQuickStats(theme, isDark),
                    SizedBox(height: 32.h),

                    // Game Modes
                    _buildGameModesSection(theme, isDark),
                    SizedBox(height: 32.h),

                    // Features
                    _buildFeaturesSection(theme, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(AuthProvider auth, ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.hunterGreen200.withOpacity(0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? AppColors.hunterGreen600 : Colors.black12,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.asparagus, AppColors.yellowGreen],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shield, color: Colors.white, size: 28.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Warrior!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  auth.user?.email?.split('@')[0] ?? 'Player',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.asparagus.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: AppColors.yellowGreen, size: 16.r),
                SizedBox(width: 4.w),
                Text(
                  'Lvl 12',
                  style: TextStyle(
                    color: AppColors.asparagus,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartBattleButton(ThemeData theme, bool isDark) {
    return ScaleTransition(
      scale: _pulseAnim,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: LinearGradient(
            colors: [
              AppColors.bittersweet,
              AppColors.bittersweet400,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.bittersweet.withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Start battle
            },
            borderRadius: BorderRadius.circular(24.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 32.r,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'START BATTLE',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20.sp,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 32.r,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.emoji_events,
            label: 'Wins',
            value: '24',
            color: AppColors.yellowGreen,
            theme: theme,
            isDark: isDark,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_up,
            label: 'Win Rate',
            value: '68%',
            color: AppColors.asparagus,
            theme: theme,
            isDark: isDark,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            icon: Icons.local_fire_department,
            label: 'Streak',
            value: '5',
            color: AppColors.bittersweet,
            theme: theme,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.hunterGreen200.withOpacity(0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.hunterGreen600 : Colors.black12,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.r),
          SizedBox(height: 8.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.white60 : Colors.black54,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameModesSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Game Modes',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),
        _buildGameModeCard(
          title: '1v1 Quick Battle',
          description: 'Fast-paced quiz battle with nearby players',
          icon: Icons.bolt,
          gradient: [AppColors.asparagus, AppColors.yellowGreen],
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 12.h),
        _buildGameModeCard(
          title: 'Ranked Battle',
          description: 'Compete for glory and climb the leaderboard',
          icon: Icons.military_tech,
          gradient: [AppColors.bittersweet, AppColors.bittersweet400],
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 12.h),
        _buildGameModeCard(
          title: 'Practice Mode',
          description: 'Sharpen your skills with AI opponents',
          icon: Icons.psychology,
          gradient: [AppColors.hunterGreen, AppColors.hunterGreen600],
          theme: theme,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildGameModeCard({
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradient,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.hunterGreen200.withOpacity(0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.hunterGreen600 : Colors.black12,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to game mode
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 50.r,
                  height: 50.r,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28.r),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.r,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Game Features',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),
        _buildFeatureItem(
          icon: Icons.smart_toy,
          title: 'AI-Powered Quizzes',
          description: 'Dynamic questions from Gemini AI',
          theme: theme,
          isDark: isDark,
        ),
        _buildFeatureItem(
          icon: Icons.timer,
          title: 'Timed Rounds',
          description: 'Fast-paced 1-minute battle rounds',
          theme: theme,
          isDark: isDark,
        ),
        _buildFeatureItem(
          icon: Icons.upgrade,
          title: 'Upgrade System',
          description: 'Unlock weapons and planes with points',
          theme: theme,
          isDark: isDark,
        ),
        _buildFeatureItem(
          icon: Icons.favorite,
          title: 'Health & Armor',
          description: 'Strategic gameplay with recovery system',
          theme: theme,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.asparagus.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.asparagus, size: 22.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}