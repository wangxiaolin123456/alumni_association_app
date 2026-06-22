import 'package:alumni_association_app/features/auth/model/response/login_response.dart';

/// 登录相关接口。
///
/// 当前阶段先在这里模拟后端接口，Controller 只依赖接口返回结果；
/// 后续接入真实服务时，替换本文件内部实现即可，不需要改页面逻辑。
class AuthApi {
  const AuthApi._();

  /// 邮箱密码登录。
  static Future<LoginResponse?> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (email == '316152945@qq.com' && password == '111111') {
      return LoginResponse(
        token: 'mock_member_token',
        userName: email,
        role: 'member',
        company: '',
        nickName: '张三',
      );
    }

    if (email == '316152946@qq.com' && password == '000000') {
      return LoginResponse(
        token: 'mock_merchant_token',
        userName: email,
        role: 'merchant',
        company: '华创科技有限公司',
        nickName: '华创科技有限公司',
      );
    }

    return null;
  }

  /// 邮箱验证码注册。
  static Future<LoginResponse> registerWithEmailCode({
    required String email,
    required String code,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return LoginResponse(
      token: 'mock_register_token',
      userName: email,
      role: 'member',
      company: '',
      nickName: '新校友',
    );
  }
}
