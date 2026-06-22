class MemberBannerResponse {
  const MemberBannerResponse({
    required this.id,
    required this.titleCode,
    required this.subtitleCode,
    required this.iconCode,
    required this.gradientColors,
  });

  final String id;
  final String titleCode;
  final String subtitleCode;
  final int iconCode;
  final List<int> gradientColors;
}
