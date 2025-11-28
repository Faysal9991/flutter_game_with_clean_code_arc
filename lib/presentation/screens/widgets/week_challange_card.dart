import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_faysal_game/presentation/screens/home/provider/home_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class DailyTaskUploadCard extends StatefulWidget {
  final String weekTitle;
  final String mainTask;
  final String imageurl;
  final int index;
  final VoidCallback? onComplete;
  final bool isLocked;
  final bool isCompleted;

  const DailyTaskUploadCard({
    super.key,
    required this.weekTitle,
    required this.mainTask,
    required this.imageurl,
    required this.index,
    this.onComplete,
    this.isLocked = false,
    this.isCompleted = false,
  });

  @override
  State<DailyTaskUploadCard> createState() => _DailyTaskUploadCardState();
}

class _DailyTaskUploadCardState extends State<DailyTaskUploadCard>
    with TickerProviderStateMixin {
  File? _selectedFile;
  bool _isSubmitting = false;

  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _shimmerAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image first'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Call Provider method
    await Provider.of<HomeProvider>(context, listen: false)
        .postSubmit(_selectedFile!, widget.index);

    setState(() {
      _isSubmitting = false;
      _selectedFile = null; // RESET IMAGE AFTER SUBMIT
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Task submitted!'),
            ],
          ),
          backgroundColor: const Color(0xFF00D9A5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFF16213E);
    final accentColor = const Color(0xFF00D9A5);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                padding: EdgeInsets.all(16.w),
                height: 400.h,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: accentColor.withOpacity(_shimmerAnimation.value),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(_shimmerAnimation.value * 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Section - Badge and Task Description
                    Column(
                      children: [
                        // Badge Image
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: accentColor.withOpacity(0.5),
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipOval(child: _buildImage()),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Week Title
                        Text(
                          widget.weekTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: accentColor,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // Main Task - Dynamic based on image selection
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          crossFadeState: _selectedFile == null
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Text(
                            widget.mainTask,
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          secondChild: Text(
                            widget.mainTask,
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Middle Section - Selected Image Preview
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _selectedFile == null ? 0 : 120.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _selectedFile != null
                            ? accentColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16.r),
                        border: _selectedFile != null
                            ? Border.all(
                                color: accentColor.withOpacity(0.5),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: _selectedFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14.r),
                              child: Image.file(
                                _selectedFile!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Bottom Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _AnimatedButton(
                            onPressed: widget.isLocked || _isSubmitting
                                ? null
                                : _pickFile,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            borderColor: Colors.white.withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.attach_file,
                                    size: 18, color: Colors.white),
                                SizedBox(width: 6.w),
                                Text(
                                  'Attach',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _AnimatedButton(
                            onPressed: widget.isLocked || _isSubmitting
                                ? null
                                : _handleSubmit,
                            backgroundColor: accentColor,
                            borderColor: accentColor,
                            child: _isSubmitting
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload_outlined,
                                          size: 18, color: Colors.white),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'Submit',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // LOCK OVERLAY
              if (widget.isLocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock,
                        color: Colors.white70,
                        size: 48,
                      ),
                    ),
                  ),
                ),

              // COMPLETED OVERLAY
              if (widget.isCompleted)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.white, size: 48),
                          SizedBox(height: 8),
                          Text(
                            'Task Completed',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImage() {
    if (widget.imageurl.isEmpty) {
      return _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: widget.imageurl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF00D9A5),
          strokeWidth: 2,
        ),
      ),
      errorWidget: (context, url, error) => _buildPlaceholder(),
      httpHeaders: const {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF2A2A3E),
      child: Icon(
        Icons.emoji_events,
        size: 40,
        color: const Color(0xFF00D9A5).withOpacity(0.5),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;

  const _AnimatedButton({
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: widget.borderColor, width: 1.5),
            boxShadow: widget.onPressed != null
                ? [
                    BoxShadow(
                      color: widget.borderColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}