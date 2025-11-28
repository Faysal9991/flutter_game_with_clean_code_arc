// lib/widgets/user_profile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_faysal_game/core/constants/app_colors.dart';
import 'package:flutter_faysal_game/core/utils/helpers.dart';
import 'package:flutter_faysal_game/data/models/user_profile.dart';
import 'package:flutter_faysal_game/presentation/providers/auth_provider.dart';
import 'package:flutter_faysal_game/presentation/screens/authentication/sign_in.dart';
import 'package:flutter_faysal_game/presentation/screens/home/provider/home_provider.dart';
import 'package:flutter_faysal_game/presentation/screens/map/map_screen.dart';
import 'package:flutter_faysal_game/presentation/screens/notification/notification.dart';
import 'package:flutter_faysal_game/presentation/screens/profile/user_profile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserProfileHeader extends StatefulWidget {
  final Function()? onLocationTap;
  final String? userLocation;

  const UserProfileHeader({
    super.key,
    this.onLocationTap,
    this.userLocation,
  });

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final repository = context.read<HomeProvider>();

    return SliverAppBar(
      expandedHeight: 270.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      // Add leading property for statistics button
      leading: Container(
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.neonBlue, Color(0xFF4CAF50)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonBlue.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.bar_chart_rounded, // or Icons.analytics_outlined
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Helpers.push(const BangladeshStaticMapScreen());
            print("Statistics button pressed");
          },
          padding: EdgeInsets.all(8.r),
          constraints: const BoxConstraints(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Align(
          alignment: Alignment.center,
          child: StreamBuilder<AppUser?>(
            stream: repository.userFullStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoading();
              }
              if (snapshot.hasError) {
                return _buildError(context);
              }
              final user = snapshot.data;
              if (user == null) {
                return _buildGuest();
              }
              return _buildUserProfile(user, theme, isDark);
            },
          ),
        ),
      ),
      actions: [
        // Notifications
        Container(
          margin: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [AppColors.neonBlue, Color(0xFF4CAF50)]),
            boxShadow: [
              BoxShadow(color: AppColors.neonBlue.withOpacity(0.2), blurRadius: 6, spreadRadius: 1),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
            onPressed: () => Helpers.push(const NotificationScreen()),
            padding: EdgeInsets.all(8.r),
            constraints: const BoxConstraints(),
          ),
        ),

        // Logout
        Container(
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF6B6B)]),
            boxShadow: [
              BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.2), blurRadius: 6, spreadRadius: 1),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 20),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
              Helpers.pushReplacement(const SignInScreen());
            },
            padding: EdgeInsets.all(8.r),
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [AppColors.primary, AppColors.neonBlue]),
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 15, spreadRadius: 2)],
          ),
          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
        ),
        SizedBox(height: 10.h),
        Text("Loading...", style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withOpacity(0.2),
            border: Border.all(color: Colors.red, width: 2),
          ),
          child: Icon(Icons.error_outline, color: Colors.red[300], size: 28.r),
        ),
        SizedBox(height: 8.h),
        Text("Connection Lost!", style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 6.h),
        ElevatedButton(
          onPressed: () => context.read<HomeProvider>().userFullStream(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
          child: Text("Reconnect", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildGuest() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [AppColors.primary, AppColors.neonBlue]),
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 1)],
          ),
          child: CircleAvatar(
            radius: 32.r,
            backgroundColor: const Color(0xFF1A1F3A),
            child: Icon(Icons.person, size: 36.r, color: Colors.white),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Guest Player",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: AppColors.primary.withOpacity(0.6), blurRadius: 10)],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          "Sign in to unlock rewards!",
          style: TextStyle(color: AppColors.neonBlue, fontSize: 11.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildUserProfile(AppUser user, ThemeData theme, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Static level ring
            Container(
              width: 74.r,
              height: 74.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [AppColors.primary, AppColors.neonBlue, AppColors.primary],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Helpers.push(const UserProfileScreen()),
              child: Container(
                padding: EdgeInsets.all(3.r),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1A1F3A)),
                child: CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  backgroundImage: user.profile.photoURL != null ? NetworkImage(user.profile.photoURL!) : null,
                  child: user.profile.photoURL == null ? Icon(Icons.person, size: 32.r, color: Colors.white) : null,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.neonBlue, const Color(0xFFFF6B6B)]),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(0.5), blurRadius: 6, spreadRadius: 1)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: Colors.white, size: 11.r),
                    SizedBox(width: 2.w),
                    Text("${user.stats.level}", style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // User Name
        Text(
          user.profile.displayName ?? user.profile.username,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: AppColors.primary.withOpacity(0.6), blurRadius: 10)],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        SizedBox(height: 4.h),

        // Location with Icon
        Consumer<HomeProvider>(
          builder: (context, provider, child) {
            final location = provider.getLocationString();
            if (location == 'Location not available') {
              return const SizedBox.shrink();
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.neonGreen.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.neonGreen,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 150.w),
                    child: Text(
                      location,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        SizedBox(height: 12.h),

        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _statChip("${user.stats.greenCoins}", "Coins", "assets/images/coin.png", AppColors.neonBlue),
            SizedBox(width: 10.w),
            _statChip("${user.stats.streak}", "Streak", "assets/images/spark.png", AppColors.neonGreen),
            SizedBox(width: 10.w),
            _statChip("${user.stats.level}", "Level", "assets/images/levelup.png", AppColors.neonBlue),
          ],
        ),
      ],
    );
  }

  Widget _statChip(
    String value,
    String label,
    String icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.35),
            color.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: color.withOpacity(0.55),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ICON
          Container(
            height: 52,
            width: 52,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.10),
            ),
            child: Image.asset(
              icon,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: 6.h),

          // MAIN VALUE
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // LABEL
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.90),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}