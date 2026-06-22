class MemberMessageResponse {
  const MemberMessageResponse({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.time,
    required this.iconCode,
  });

  final String id;
  final String type;
  final String title;
  final String content;
  final String time;
  final int iconCode;
}
