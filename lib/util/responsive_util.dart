import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
/// Best practice: Centralized responsive logic
class ResponsiveUtil {
  // Screen size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Device types
  static bool isMobile(double width) => width < mobileBreakpoint;
  static bool isTablet(double width) => width >= mobileBreakpoint && width < tabletBreakpoint;
  static bool isDesktop(double width) => width >= tabletBreakpoint;

  // Responsive font sizes
  static double getFontSize(double width, {
    double mobile = 14,
    double tablet = 16,
    double desktop = 18,
  }) {
    if (isMobile(width)) return mobile;
    if (isTablet(width)) return tablet;
    return desktop;
  }

  // Responsive padding
  static double getPadding(double width, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    if (isMobile(width)) return mobile;
    if (isTablet(width)) return tablet;
    return desktop;
  }

  // Responsive icon sizes
  static double getIconSize(double width, {
    double mobile = 20,
    double tablet = 24,
    double desktop = 28,
  }) {
    if (isMobile(width)) return mobile;
    if (isTablet(width)) return tablet;
    return desktop;
  }

  // Check if screen is small (need compact layout)
  static bool isSmallScreen(double width) => width < 360;
  
  // Check if screen is very large (need expanded layout)
  static bool isLargeScreen(double width) => width > 1024;

  // Calculate responsive spacing
  static double getSpacing(double width) {
    if (width < 360) return 4;  // Very small phones
    if (width < 400) return 6;  // Small phones
    if (width < 600) return 8;  // Normal phones
    return 12; // Tablets and larger
  }

  // Calculate card width based on screen size
  static double getCardWidth(double screenWidth) {
    if (isDesktop(screenWidth)) {
      return screenWidth * 0.4; // 40% on desktop
    } else if (isTablet(screenWidth)) {
      return screenWidth * 0.6; // 60% on tablet
    }
    return screenWidth * 0.9; // 90% on mobile
  }
}

/// Extension for easier MediaQuery access
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  bool get isMobile => ResponsiveUtil.isMobile(screenWidth);
  bool get isTablet => ResponsiveUtil.isTablet(screenWidth);
  bool get isDesktop => ResponsiveUtil.isDesktop(screenWidth);
  
  double responsiveFontSize({double mobile = 14, double tablet = 16, double desktop = 18}) {
    return ResponsiveUtil.getFontSize(screenWidth, mobile: mobile, tablet: tablet, desktop: desktop);
  }
  
  double responsivePadding({double mobile = 8, double tablet = 12, double desktop = 16}) {
    return ResponsiveUtil.getPadding(screenWidth, mobile: mobile, tablet: tablet, desktop: desktop);
  }
}