class LoginResponse {
  final String token;
  final int userId;
  final int phoneStatus;
  final int role;

  const LoginResponse({
    required this.token,
    required this.userId,
    required this.phoneStatus,
    this.role = 0,
  });

  /// 是否已绑定手机号
  /// phoneStatus = 1 表示需要绑定手机号
  bool get hasBoundPhone => phoneStatus != 1;

  /// 是否普通会员
  bool get isCommon => role == 0;

  /// 是否商家
  bool get isMerchant => role == 1;



  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token']?.toString() ?? '',
      userId: _parseInt(json['userId'] ?? json['id']),
      phoneStatus: _parseInt(json['phoneStatus']),
      role: _parseInt(json['isMerchant'] ?? json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'phoneStatus': phoneStatus,
      'role': role,
    };
  }

  /// 复制登录信息。
  ///
  /// 绑定手机号成功后需要把 phoneStatus 更新为已绑定，同时保留 token 和角色。
  LoginResponse copyWith({
    String? token,
    int? userId,
    int? phoneStatus,
    int? role,
  }) {
    return LoginResponse(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      phoneStatus: phoneStatus ?? this.phoneStatus,
      role: role ?? this.role,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
