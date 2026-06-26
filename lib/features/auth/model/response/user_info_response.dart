class UserInfoResponse {
  final int userId;
  final String email;
  final String nickname;
  final String avatar;
  final String phone;
  final String createTime;
  final String updateTime;
  final String lastLoginTime;

  /// 是否商家
  /// 后端返回：0 = 普通会员，1 = 商家
  final int isMerchant;

  const UserInfoResponse({
    required this.userId,
    this.email = '',
    this.nickname = '',
    this.avatar = '',
    this.phone = '',
    this.createTime = '',
    this.updateTime = '',
    this.lastLoginTime = '',
    this.isMerchant = 0,
  });

  /// 是否普通会员
  bool get isCommon => isMerchant == 0;

  /// 是否商家
  bool get merchant => isMerchant == 1;

  /// 我的页面展示名称，优先昵称，其次邮箱
  String get displayName {
    if (nickname.trim().isNotEmpty) return nickname.trim();
    if (email.trim().isNotEmpty) return email.trim();
    return merchant ? '商家用户' : '校友会员';
  }

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    return UserInfoResponse(
      userId: _parseInt(json['userId'] ?? json['id']),
      email: json['email']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      createTime: json['createTime']?.toString() ?? '',
      updateTime: json['updateTime']?.toString() ?? '',
      lastLoginTime: json['lastLoginTime']?.toString() ?? '',
      isMerchant: _parseInt(json['isMerchant']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'nickname': nickname,
      'avatar': avatar,
      'phone': phone,
      'createTime': createTime,
      'updateTime': updateTime,
      'lastLoginTime': lastLoginTime,
      'isMerchant': isMerchant,
    };
  }

  UserInfoResponse copyWith({
    int? userId,
    String? email,
    String? nickname,
    String? avatar,
    String? phone,
    String? createTime,
    String? updateTime,
    String? lastLoginTime,
    int? isMerchant,
  }) {
    return UserInfoResponse(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
      isMerchant: isMerchant ?? this.isMerchant,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
