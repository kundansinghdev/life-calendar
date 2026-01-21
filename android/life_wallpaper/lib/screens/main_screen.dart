import 'package:flutter/material.dart';
import '../logic/life_logic.dart';
import '../utils/responsive.dart';
import '../widgets/life_components.dart';

class MainScreen extends StatefulWidget {
  final bool isPreviewMode;
  
  const MainScreen({
    super.key, 
    this.isPreviewMode = false,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _totalDays = 365;
  int _dayOfYear = 1;
  // REMOVED: AnimationController, TickerProvider
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _calcDate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _calcDate();
      if (mounted) setState(() {});
    }
  }

  void _calcDate() {
    final now = DateTime.now();
    _totalDays = LifeLogic.getTotalDays(now.year);
    _dayOfYear = LifeLogic.getDayOfYear(now, _totalDays);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final spacing = context.spacing;
    final daysLeft = LifeLogic.getDaysLeft(_totalDays, _dayOfYear);
    final percentUsed = LifeLogic.getPercentUsed(_totalDays, _dayOfYear);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          // Subtle gradient matches the "Awareness" vibe - not strictly "Flat" but "Atmospheric".
          // Keeping it as it provides depth without motion.
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.8,
            colors: [Color(0xFF0F0F0F), Color(0xFF000000)],
          ),
        ),
        child: Stack(
          children: [
            // PRIMARY RENDERING LAYER
            Positioned(
              top: r.height * LifeLogic.gridTopRatio,
              left: spacing.lg,
              right: spacing.lg,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LifeDotGrid(
                    totalDays: _totalDays,
                    dayOfYear: _dayOfYear,
                  ),
                  SizedBox(height: r.height * LifeLogic.gridToTextGapRatio),
                  LifeFact(daysLeft: daysLeft, percentUsed: percentUsed),
                ],
              ),
            ),

            // FOOTER (App-only)
            if (!widget.isPreviewMode)
              Positioned(
                bottom: spacing.lg,
                left: spacing.lg,
                right: spacing.lg,
                child: const SafeArea(child: LifeFooter()),
              ),
          ],
        ),
      ),
    );
  }
}
