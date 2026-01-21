import 'package:flutter/material.dart';
import 'dart:math';

/// Responsive design utilities for adaptive layouts across all screen sizes
class ResponsiveUtils {
  final BuildContext context;
  
  ResponsiveUtils(this.context);
  
  /// Screen width
  double get width => MediaQuery.of(context).size.width;
  
  /// Screen height
  double get height => MediaQuery.of(context).size.height;
  
  /// Screen diagonal (for truly responsive sizing)
  double get diagonal {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }
  
  /// Device pixel ratio
  double get pixelRatio => MediaQuery.of(context).devicePixelRatio;
  
  /// Safe area padding
  EdgeInsets get safeArea => MediaQuery.of(context).padding;
  
  /// Breakpoints
  bool get isSmallPhone => width < 360;
  bool get isMediumPhone => width >= 360 && width < 400;
  bool get isLargePhone => width >= 400 && width < 600;
  bool get isTablet => width >= 600;
  
  /// Aspect ratio categories
  bool get isTallScreen => height / width > 2.0;  // 20:9 or taller
  bool get isNormalScreen => height / width >= 1.6 && height / width <= 2.0;
  bool get isWideScreen => height / width < 1.6;
  
  /// Responsive sizing based on screen width (percentage)
  double wp(double percentage) => width * (percentage / 100);
  
  /// Responsive sizing based on screen height (percentage)
  double hp(double percentage) => height * (percentage / 100);
  
  /// Responsive sizing based on diagonal (for truly device-independent sizing)
  double dp(double percentage) => diagonal * (percentage / 100);
  
  /// Responsive text size (scales with screen size)
  double sp(double size) {
    // Base width: 375 (iPhone SE/8 width)
    const baseWidth = 375.0;
    final scale = width / baseWidth;
    return size * scale.clamp(0.8, 1.3); // Limit scaling between 80% and 130%
  }
  
  /// Responsive spacing (8dp grid system)
  double spacing(double multiplier) {
    const baseUnit = 8.0;
    final scale = width / 375.0;
    return baseUnit * multiplier * scale.clamp(0.9, 1.2);
  }
}

/// Responsive spacing system based on 8dp grid
class AppSpacing {
  final ResponsiveUtils r;
  
  AppSpacing(this.r);
  
  double get xs => r.spacing(0.5);   // 4dp scaled
  double get sm => r.spacing(1);     // 8dp scaled
  double get md => r.spacing(2);     // 16dp scaled
  double get lg => r.spacing(3);     // 24dp scaled
  double get xl => r.spacing(4);     // 32dp scaled
  double get xxl => r.spacing(6);    // 48dp scaled
  double get xxxl => r.spacing(8);   // 64dp scaled
}

/// Responsive typography system
class AppTextStyles {
  final ResponsiveUtils r;
  
  AppTextStyles(this.r);
  
  TextStyle get displayLarge => TextStyle(
    fontSize: r.sp(80),
    fontWeight: FontWeight.w700,
    letterSpacing: -4.0,
    height: 0.85,
  );
  
  TextStyle get displayMedium => TextStyle(
    fontSize: r.sp(48),
    fontWeight: FontWeight.w600,
    letterSpacing: -2.0,
    height: 1.0,
  );
  
  TextStyle get headlineLarge => TextStyle(
    fontSize: r.sp(32),
    fontWeight: FontWeight.w600,
    letterSpacing: -1.0,
    height: 1.2,
  );
  
  TextStyle get headlineMedium => TextStyle(
    fontSize: r.sp(26),
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.25,
  );
  
  TextStyle get titleLarge => TextStyle(
    fontSize: r.sp(17),
    fontWeight: FontWeight.w700,
    letterSpacing: 2.5,
  );
  
  TextStyle get titleMedium => TextStyle(
    fontSize: r.sp(14),
    fontWeight: FontWeight.w600,
    letterSpacing: 2.5,
  );
  
  TextStyle get bodyLarge => TextStyle(
    fontSize: r.sp(13),
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.2,
  );
  
  TextStyle get bodyMedium => TextStyle(
    fontSize: r.sp(12),
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.3,
  );
  
  TextStyle get labelLarge => TextStyle(
    fontSize: r.sp(12),
    fontWeight: FontWeight.w600,
    letterSpacing: 3.0,
  );
  
  TextStyle get labelSmall => TextStyle(
    fontSize: r.sp(10),
    fontWeight: FontWeight.w600,
    letterSpacing: 3.5,
  );
}

/// Extension for easy access to responsive utilities
extension ResponsiveContext on BuildContext {
  ResponsiveUtils get r => ResponsiveUtils(this);
  AppSpacing get spacing => AppSpacing(ResponsiveUtils(this));
  AppTextStyles get textStyles => AppTextStyles(ResponsiveUtils(this));
}
