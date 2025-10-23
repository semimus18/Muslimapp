import 'package:flutter/material.dart';

/// Creates a glowing box shadow effect with the specified color
/// 
/// Returns a list of BoxShadow widgets that create a multi-layered glow effect
/// 
/// Parameters:
/// - [color]: The base color for the glow effect
/// - [intensity]: Controls the opacity/strength of the glow (0.0 to 1.0), defaults to 0.6
List<BoxShadow> createGlowEffect({
  required Color color,
  double intensity = 0.6,
}) {
  return [
    // Outer glow - bright and spread out
    BoxShadow(
      color: color.withOpacity(intensity),
      blurRadius: 20,
      spreadRadius: 3,
      offset: const Offset(0, 0),
    ),
    // Inner glow - slightly darker for depth
    BoxShadow(
      color: color.withOpacity(intensity * 0.7),
      blurRadius: 15,
      spreadRadius: 1,
      offset: const Offset(0, 0),
    ),
    // Shadow for depth
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];
}

/// Creates a stronger, more intense glow effect
/// 
/// Parameters:
/// - [color]: The base color for the glow effect
List<BoxShadow> createStrongGlowEffect({
  required Color color,
}) {
  return createGlowEffect(color: color, intensity: 0.8);
}

/// Creates a subtle, softer glow effect
/// 
/// Parameters:
/// - [color]: The base color for the glow effect
List<BoxShadow> createSoftGlowEffect({
  required Color color,
}) {
  return createGlowEffect(color: color, intensity: 0.4);
}
