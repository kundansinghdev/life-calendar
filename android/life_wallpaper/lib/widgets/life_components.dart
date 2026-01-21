import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/responsive.dart';
import '../native/native_bridge.dart';
import '../logic/life_logic.dart';

class LifeDotGrid extends StatelessWidget {
  final int totalDays;
  final int dayOfYear;

  const LifeDotGrid({
    super.key,
    required this.totalDays,
    required this.dayOfYear,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final spacing = context.spacing;
    const cols = LifeLogic.gridColumns;
    final availWidth = r.width - (spacing.lg * 2);
    final dotDiameter = availWidth / (cols * 1.5 - 0.5);
    final dotSpacing = dotDiameter * 0.5;
    final radius = dotDiameter / 2;

    final rows = (totalDays / cols).ceil();
    final gridHeight = (rows * dotDiameter) + ((rows - 1) * dotSpacing);
    // Constraint removed: explicit height clamping causes overlap if screen is small or grid is tall.
    // The grid should take standard height based on content.
    
    return SizedBox(
      height: gridHeight, // Use full calculated height
      child: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          spacing: dotSpacing,
          runSpacing: dotSpacing,
          children: List.generate(totalDays, (index) {
            final dayNum = index + 1;
            final isPast = dayNum < dayOfYear;
            final isToday = dayNum == dayOfYear;

            return Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPast
                    ? Colors.white
                    : isToday
                        ? const Color(0xFFFFA500)
                        : Colors.white.withValues(alpha: 0.08),
                // "No circles" (aesthetic), "No animations" (behavior).
                // Today is just orange, no pulse, no shadow blur.
                // "One dot subtly marks today." -> Color change is sufficient.
              ),
            );
          }),
        ),
      ),
    );
  }
}

class LifeFact extends StatelessWidget {
  final int daysLeft;
  final int percentUsed;

  const LifeFact({
    super.key,
    required this.daysLeft,
    required this.percentUsed,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 14,
          fontWeight: FontWeight.bold, // Final Polish: Bold
          letterSpacing: 2.0,
          fontFamily: 'Roboto', 
        ),
        children: [
          TextSpan(text: '${daysLeft}d left'),
          TextSpan(
            text: ' · ',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          TextSpan(
            text: '$percentUsed%',
            style: TextStyle(
              fontSize: 12, 
              color: Colors.white.withValues(alpha: 0.2), 
            ),
          ),
        ],
      ),
    );
  }
}

class LifeFooter extends StatelessWidget {
  const LifeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final spacing = context.spacing;
    final textStyles = context.textStyles;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: r.hp(6),
        maxHeight: r.hp(8),
      ),
      child: OutlinedButton(
        onPressed: () => NativeBridge.openWallpaperPicker(),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFFA500),
          side: const BorderSide(color: Color(0xFFFFA500), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spacing.sm)),
          padding: EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.md),
        ),
        child: Text(
          'SET WALLPAPER',
          style: textStyles.titleMedium.copyWith(color: const Color(0xFFFFA500)),
        ),
      ),
    );
  }
}
