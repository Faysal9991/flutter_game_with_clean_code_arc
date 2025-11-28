// presentation/screens/authentication/sign_in.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_faysal_game/core/utils/helpers.dart';
import 'package:flutter_faysal_game/presentation/admin_panel/home_screen.dart';
import 'package:flutter_faysal_game/presentation/screens/authentication/sign_up.dart';
import 'package:flutter_faysal_game/presentation/screens/home/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  
  final bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    try {
    await auth.signIn(_emailCtrl.text.trim(), _passCtrl.text);
     if (auth.user != null) {

      auth.user!.email== "admin@gmail.com"?Helpers.pushAndClearStack(const AdminHomeScreen()):
  Helpers.pushAndClearStack(const HomeScreen());
}
    } catch (_) {
      // Error shown via provider
    }
  }



  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FA),
      body: Container(
         decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.4, -0.6),
          radius: 1.5,
          colors: [
            Color(0xFF1a5c44),
            Color(0xFF0b2030),
            Color(0xFF07141d),
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    
                        _buildLoginView(context, auth, theme, isDark),
                      
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

  Widget _buildLoginView(
      BuildContext context, AuthProvider auth, ThemeData theme, bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Logo/Icon ────────────────────────────────────────────
          Image.asset("assets/images/leaf_splash.png",height: 100,width: 100,),
          SizedBox(height: 32.h),

          // ── Title ────────────────────────────────────────────────
          Text(
            'Welcome Back',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 32.sp,
              color: isDark ? Colors.white : Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Sign in to continue to GreenLife',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white60 : Colors.black45,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 48.h),

          // ── Error Message ────────────────────────────────────────
          if (_errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade700,
                    size: 20.r, 
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],

          // ── Email Field ──────────────────────────────────────────
          CustomTextField(
            controller: _emailCtrl,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            enabled: !_isLoading,
          ),
          SizedBox(height: 16.h),

          // ── Password Field ───────────────────────────────────────
          CustomTextField(
            controller: _passCtrl,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: _validatePassword,
            enabled: !_isLoading,
          ),
          SizedBox(height: 32.h),

          // ── Sign In Button ───────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Sign In',
              onPressed: _isLoading ? () {} : _signIn,
              isLoading: _isLoading,
            ),
          ),
          SizedBox(height: 24.h),

          // ── Divider ──────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: isDark ? Colors.white24 : Colors.black12,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: isDark ? Colors.white24 : Colors.black12,
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // ── Sign Up Link ─────────────────────────────────────────
          GestureDetector(
            onTap: _isLoading
    ? null
    : () async {
        await Helpers.push(const SignUpScreen());
      },
            child: AnimatedOpacity(
              opacity: _isLoading ? 0.5 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? Colors.white24 : Colors.black12,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 15.sp,
                      ),
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }





}class GlassLoginCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const GlassLoginCard({
    super.key,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 420.w),
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.fromLTRB(32.w, 40.h, 32.w, 32.h),
        decoration: BoxDecoration(
          // Glassmorphic background
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.18),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.2),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              // Inner subtle gradient for depth
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(isDark ? 0.1 : 0.08),
                  Colors.transparent,
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
