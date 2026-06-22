import 'package:alumni_association_app/core/network/model/json_request.dart';

/// Query parameters sent when requesting member-home recommendation data.
class MemberHomeQuery implements JsonRequest {
  const MemberHomeQuery({this.cityCode, this.page = 1, this.pageSize = 10});

  final String? cityCode;
  final int page;
  final int pageSize;

  @override
  Map<String, dynamic> toJson() => {
    if (cityCode != null) 'cityCode': cityCode,
    'page': page,
    'pageSize': pageSize,
  };
}
