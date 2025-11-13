// presentation/screens/authentication/sign_up.dart
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _isLoading = false;
  String? _errorMessage;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _companyCtrl.dispose();
    _passCtrl.dispose();
    _countryCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Validators ─────────────────────────────────────────────────────
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Invalid email';
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    if (value.trim().length < 3) return 'Username too short';
    return null;
  }

  String? _validateCompany(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Company name is required';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be 6+ characters';
    return null;
  }

  String? _validateCountry() {
    if (_selectedCountry == null) return 'Please select a country';
    return null;
  }

  // ── Sign Up Action ─────────────────────────────────────────────────
  Future<void> _signUp() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) return;
    if (_validateCountry() != null) {
      setState(() => _errorMessage = _validateCountry());
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      await auth.signUpWithDetails(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        username: _usernameCtrl.text.trim(),
        company: _companyCtrl.text.trim(),
        country: _selectedCountry!.name,
      );
      if (mounted) Navigator.pop(context); // Go back to sign-in
    } catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.toString());
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'Email already registered';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email';
    } else if (error.contains('network-request-failed')) {
      return 'Check your internet';
    } else {
      return 'Sign up failed. Try again';
    }
  }

  // ── Country Picker Dialog ─────────────────────────────────────────
  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _countryCtrl.text = '${country.flagEmoji} ${country.name}';
        });
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(16.r),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
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
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ── Logo ──
                      Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.primaryColor,
                              theme.primaryColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_add,
                          size: 40.r,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // ── Title ──
                      Text(
                        'Create Account',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 32.sp,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Fill in your details to get started',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.white60 : Colors.black45,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // ── Error ──
                      if (_errorMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
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

                      // ── Email ──
                      CustomTextField(
                        controller: _emailCtrl,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        enabled: !_isLoading,
                      ),
                      SizedBox(height: 16.h),

                      // ── Username ──
                      CustomTextField(
                        controller: _usernameCtrl,
                        label: 'Username',
                        icon: Icons.person_outline,
                        validator: _validateUsername,
                        enabled: !_isLoading,
                      ),
                      SizedBox(height: 16.h),

                      // ── Company ──
                      CustomTextField(
                        controller: _companyCtrl,
                        label: 'Company Name',
                        icon: Icons.business,
                        validator: _validateCompany,
                        enabled: !_isLoading,
                      ),
                      SizedBox(height: 16.h),

                      // ── Country Picker ──
                      CustomTextField(
                        controller: _countryCtrl,
                        label: 'Country',
                        icon: Icons.public,
                        readOnly: true, // ← NEW
                        onTap: _isLoading ? null : _showCountryPicker, // ← NEW
                        validator: (_) => _validateCountry(),
                        enabled: !_isLoading,
                        suffixIcon: Icon(
                          // ← NEW
                          Icons.arrow_drop_down,
                          color: theme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // ── Password ──
                      CustomTextField(
                        controller: _passCtrl,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: _validatePassword,
                        enabled: !_isLoading,
                      ),
                      SizedBox(height: 32.h),

                      // ── Sign Up Button ──
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Create Account',
                          onPressed: _isLoading ? () {} : _signUp,
                          isLoading: _isLoading,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // ── Sign In Link ──
                      GestureDetector(
                        onTap: _isLoading ? null : () => Navigator.pop(context),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 15.sp,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
