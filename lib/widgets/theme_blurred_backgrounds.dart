import 'package:flutter/material.dart';
import 'package:muslimapp/themes/themes.dart';

class ThemeBlurredBackgrounds extends StatelessWidget {
  final AppTheme theme;
  final PrayerTheme? prayerTheme; // Optional PrayerTheme for enhanced styling
  
  const ThemeBlurredBackgrounds({
    Key? key, 
    required this.theme,
    this.prayerTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    // Use prayerTheme if available, otherwise fallback to legacy theme
    final Color firstAccentColor = prayerTheme != null 
        ? prayerTheme!.accent.first
        : theme.backgroundGradient.first;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // First blurred circle (accent color at 20% opacity)
        Positioned(
          top: -80,
          left: -80,
          child: Container(
            width: 320,  // w-80 = 20rem = ~320px
            height: 320, // h-80 = 20rem = ~320px
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  firstAccentColor.withOpacity(0.2), // Theme accent color with 20% opacity
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
              borderRadius: BorderRadius.circular(160), // rounded-full
              boxShadow: [
                BoxShadow(
                  color: firstAccentColor.withOpacity(0.1),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ),
        
        // Second blurred circle (secondary color at 25% opacity)
        Positioned(
          top: size.height / 3, // top-1/3
          right: -80,
          child: Container(
            width: 240,  // w-60 = 15rem = ~240px
            height: 240, // h-60 = 15rem = ~240px
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  prayerTheme != null 
                      ? prayerTheme!.secondary.first.withOpacity(0.25) 
                      : theme.backgroundGradient.last.withOpacity(0.25),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
              borderRadius: BorderRadius.circular(120), // rounded-full
              boxShadow: [
                BoxShadow(
                  color: prayerTheme != null 
                      ? prayerTheme!.secondary.first.withOpacity(0.1) 
                      : theme.backgroundGradient.last.withOpacity(0.1),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ),
        
        // Third blurred circle with enhanced blur effect
        Positioned(
          bottom: 20, 
          left: size.width / 10, 
          child: Container(
            width: 288,
            height: 288,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  // Use prayer theme colors if available, otherwise use default colors
                  prayerTheme != null 
                      ? prayerTheme!.accent.last.withOpacity(0.3) 
                      : const Color(0x4DFDA4AF),  // Higher opacity for more visible blur
                  Colors.transparent,
                ],
                stops: const [0.2, 1.0],  // More concentrated gradient
              ),
              borderRadius: BorderRadius.circular(144),
              boxShadow: [
                BoxShadow(
                  color: prayerTheme != null 
                      ? prayerTheme!.accent.last.withOpacity(0.25)
                      : const Color(0x40FDA4AF),
                  blurRadius: 60,  // Increased blur radius
                  spreadRadius: 10,  // Increased spread for more prominent blur
                ),
                BoxShadow(  // Adding a second shadow for more pronounced blur effect
                  color: prayerTheme != null 
                      ? prayerTheme!.secondary.first.withOpacity(0.15)
                      : const Color(0x26FB7185),
                  blurRadius: 40,
                  spreadRadius: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Extension to use this more easily with your prayer background
class ThemeGradientBackground extends StatelessWidget {
  final AppTheme theme;
  final Widget child;
  
  const ThemeGradientBackground({
    Key? key,
    required this.theme,
    required this.child,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred background elements
        ThemeBlurredBackgrounds(theme: theme),
        
        // Your content goes here
        child,
      ],
    );
  }
}