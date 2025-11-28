// presentation/screens/notification/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
          'Notifications',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 22.sp,
            ),
            onPressed: () {
              // TODO: Clear all notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clear all notifications'),
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Notifications',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Stay updated with your missions and community updates.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white60 : Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // Notifications List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildNotificationCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.celebration,
                  iconColor: AppColors.neonGreen,
                  title: 'Welcome back, faysaltanvir991@gmail.com!',
                  message:
                      'You\'re a hero! Just saved the world a bit – dopamine boost incoming!',
                  time: '2 hours ago',
                  isNew: true,
                ),
                SizedBox(height: 12.h),
                _buildNotificationCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.eco,
                  iconColor: AppColors.neonGreen,
                  title: 'Daily Challenge Completed!',
                  message:
                      'Great job on completing today\'s challenge! Keep up the amazing work.',
                  time: '5 hours ago',
                  isNew: true,
                ),
                SizedBox(height: 12.h),
                _buildNotificationCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.stars,
                  iconColor: Colors.amber,
                  title: 'Achievement Unlocked!',
                  message:
                      'You\'ve earned the "Eco Warrior" badge! 50 points added to your score.',
                  time: '1 day ago',
                  isNew: false,
                ),
                SizedBox(height: 12.h),
                _buildNotificationCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.groups,
                  iconColor: AppColors.neonBlue,
                  title: 'Community Update',
                  message:
                      'Join our weekly community meetup this Saturday! Let\'s make a difference together.',
                  time: '2 days ago',
                  isNew: false,
                ),
                SizedBox(height: 12.h),
                _buildNotificationCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.trending_up,
                  iconColor: AppColors.neonGreen,
                  title: 'Level Up!',
                  message:
                      'Congratulations! You\'ve reached Level 5. New challenges await!',
                  time: '3 days ago',
                  isNew: false,
                ),
                SizedBox(height: 12.h),
                _buildNotificationCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.volunteer_activism,
                  iconColor: Colors.pink,
                  title: 'Welcome back, faysaltanvir991@gmail.com!',
                  message:
                      'You\'re a hero! Just saved the world a bit – dopamine boost incoming!',
                  time: '4 days ago',
                  isNew: false,
                ),
                SizedBox(height: 12.h),
                _buildNotificationCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.tips_and_updates,
                  iconColor: Colors.orange,
                  title: 'New Tip Available!',
                  message:
                      'Check out our latest eco-friendly tips to maximize your impact.',
                  time: '5 days ago',
                  isNew: false,
                ),
                SizedBox(height: 12.h),
                _buildNotificationCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.local_fire_department,
                  iconColor: Colors.deepOrange,
                  title: 'Streak Alert!',
                  message:
                      'You\'re on a 7-day streak! Don\'t break the chain now.',
                  time: '1 week ago',
                  isNew: false,
                ),
                SizedBox(height: 24.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
    bool isNew = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isNew
              ? [
                  iconColor.withOpacity(0.15),
                  iconColor.withOpacity(0.05),
                ]
              : [
                  (isDark ? Colors.white : Colors.black).withOpacity(0.08),
                  (isDark ? Colors.white : Colors.black).withOpacity(0.02),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isNew
              ? iconColor.withOpacity(0.3)
              : (isDark ? Colors.white : Colors.black).withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: isNew
            ? [
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // TODO: Handle notification tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Notification tapped: $title'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isNew)
                            Container(
                              margin: EdgeInsets.only(left: 8.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: iconColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'NEW',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? Colors.white70 : Colors.black54,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12.sp,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark ? Colors.white38 : Colors.black38,
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
        ),
      ),
    );
  }
}