/// 绑定手机号来源。
///
/// 不同登录入口绑定手机号时，后端需要不同的身份字段：
/// - 账号密码登录：email + phone
/// - 微信登录：wechatId + phone
/// - LINE 登录：lineId + phone
class BindMobileSource {
  const BindMobileSource({
    this.email = '',
    this.lineId = '',
    this.wechatId = '',
  });

  final String email;
  final String lineId;
  final String wechatId;

  factory BindMobileSource.email(String email) {
    return BindMobileSource(email: email);
  }

  factory BindMobileSource.wechat(String wechatId) {
    return BindMobileSource(wechatId: wechatId);
  }

  factory BindMobileSource.line(String lineId) {
    return BindMobileSource(lineId: lineId);
  }
}
