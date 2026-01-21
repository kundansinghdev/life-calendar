class LifeLogic {
  // SHARED DESIGN CONSTANTS (Mirror in LifeWallpaperService.kt)
  static const double gridTopRatio = 0.12; // 12% of screen height
  static const double horizontalMarginDp = 80.0;
  static const int gridColumns = 15;
  static const double gridToTextGapRatio = 0.03; // Reduced from 0.08
  
  static int getTotalDays(int year) {
    final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    return isLeap ? 366 : 365;
  }

  static int getDayOfYear(DateTime now, int totalDays) {
    final startOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(startOfYear).inDays + 1;
    return dayOfYear > totalDays ? totalDays : dayOfYear;
  }

  static int getDaysLeft(int totalDays, int dayOfYear) {
    return totalDays - dayOfYear;
  }

  static int getPercentUsed(int totalDays, int dayOfYear) {
    return ((dayOfYear / totalDays) * 100).toInt();
  }
}
