import 'package:alumni_association_app/features/auth/model/response/login_response.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_onboarding_request.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_region_item.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_type_item.dart';
import 'package:dio/dio.dart';
import '../../features/auth/model/response/user_info_response.dart';
import '../../features/store/model/response/store_response.dart';
import '../../http/core/http_manager.dart';
import '../../http/model/page_response.dart';
import '../../storage/storage.dart';
import '../../util/toast_utils.dart';

class URL {
  /// 注册
  static const String register = "/api/register";

  ///邮箱注册发送验证码
  static const String sendRegisterCode = "/api/sendRegisterCode";

  ///邮箱忘记密码发送验证码
  static const String sendResetCode = "/api/sendResetCode";

  /// 账号密码登录
  static const String login = "/api/login";

  ///修改密码
  static const String updatePwd = "/api/passwordReset";

  ///退出登录
  static const String loginOut = "/api/loginOut";

  ///绑定手机号
  static const String bindMobile = "/api/bindMobile";

  /// 用户信息
  static const String userInfo = "/api/userInfo";

  /// 注册商户
  static const String addMerchant = "/api/merchant/addMerchant";

  /// 修改商户
  static const String updateMerchant = "/api/merchant/updateMerchant";

  /// 商户所属行业
  static const String merchantType = "/api/merchant/merchantType";

  /// 根据 pid 获取省市区信息
  static const String merchantRegionList = "/api/merchant/listByPid";

  /// 单张图片上传
  static const String uploadFile = "/api/upload/upload";

  /// 多张图片上传
  static const String uploadFiles = "/api/upload/uploads";

  /// 商户列表
  static const String merchantList = "/api/merchant/merchantList";

  /// 我的商户列表
  static const String myMerchantList = "/api/merchant/myMerchantList";
}

class ApiRequest {
  /// 邮箱注册发送验证码
  static Future<bool> sendRegisterCode({required String email}) async {
    try {
      final response = await HttpManager.post(
        URL.sendRegisterCode,
        data: {"email": email},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.code == 200) {
        // ToastUtils.showToast(
        //   message: response.msg.isNotEmpty ? response.msg : "验证码发送成功",
        //   type: ToastType.success,
        // );

        return true;
      } else {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);
        return false;
      }
    } catch (e) {
      ToastUtils.showToast(message: "验证码发送失败", type: ToastType.error);
      return false;
    }
  }

  /// 注册
  static Future<bool> register({
    required String email,
    required String password,
    required String code,
  }) async {
    try {
      final response = await HttpManager.post(
        URL.register,
        data: {"email": email, "password": password, "code": code},
      );

      if (response.code == 200) {
        // ToastUtils.showToast(
        //   message: response.msg.isNotEmpty ? response.msg : "注册成功",
        //
        //   type: ToastType.success,
        // );

        return true;
      } else {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);

        return false;
      }
    } catch (e) {
      ToastUtils.showToast(message: "注册失败", type: ToastType.error);

      return false;
    }
  }

  /// 账号密码登录
  ///
  /// - [username] 用户名
  /// - [password] 密码
  static Future<LoginResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      var response = await HttpManager.post<LoginResponse>(
        URL.login,
        data: {"email": email, "password": password},
      );
      if (response.code == 200 && response.data != null) {
        // 先缓存 token，便于未绑定手机号时调用绑定手机号接口。
        // 完整登录态在 _finishAuth 或绑定成功后再写入，避免未绑定账号直接恢复为已登录。
        Storage.setAccessToken(token: response.data!.token);
        // final detail = await userInfo(userId: response.data!.userId);
        // if(detail!=null){
        //   SessionController.current.updateLoginInfo(detail);
        // }

        return response.data;
      } else {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);
      }
      return null;
    } catch (e) {
      // ToastUtils.showToast(message: e.toString(),type: ToastType.error);
      return null;
    }
  }

  /// 退出登录
  static Future<bool> loginOut({required int userId}) async {
    try {
      final response = await HttpManager.post(
        URL.loginOut,
        // data: {"userId": userId},
      );
      if (response.code == 200) {
        Storage.setAccessToken(token: "");
        ToastUtils.showToast(
          message: response.msg.isNotEmpty ? response.msg : "退出成功",
          type: ToastType.success,
        );
        return true;
      } else {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);

        return false;
      }
    } catch (e) {
      ToastUtils.showToast(message: "退出失败", type: ToastType.error);

      return false;
    }
  }

  /// 绑定手机号
  ///
  /// 根据登录入口区分传参：
  /// 账号密码登录传 email + phone，微信传 wechatId + phone，LINE 传 lineId + phone。
  static Future<bool> bindMobile({
    required String phone,
    String email = '',
    String lineId = '',
    String wechatId = '',
  }) async {
    try {
      final response = await HttpManager.post(
        URL.bindMobile,
        data: {
          "email": email,
          "lineId": lineId,
          "wechatId": wechatId,
          "phone": phone,
        },
      );

      if (response.code == 200) {
        ToastUtils.showToast(
          message: response.msg.isNotEmpty ? response.msg : "手机号绑定成功",
          type: ToastType.success,
        );
        return true;
      } else {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);
        return false;
      }
    } catch (e) {
      ToastUtils.showToast(message: "手机号绑定失败", type: ToastType.error);
      return false;
    }
  }

  /// 获取用户信息。
  static Future<UserInfoResponse?> userInfo({required int userId}) async {
    try {
      final response = await HttpManager.get<UserInfoResponse>(
        URL.userInfo,
        // params: {"userId": userId},
      );
      if (response.code == 200 && response.data != null) {
        return response.data;
      }
      ToastUtils.showToast(message: response.msg, type: ToastType.error);
      return null;
    } catch (e) {
      ToastUtils.showToast(message: "获取用户信息失败", type: ToastType.error);
      return null;
    }
  }

  /// 根据父级 pid 获取省市区信息。
  ///
  /// pid = 0 时返回省级数据，选择省后用省 id 拉市级，选择市后用市 id 拉区级。
  static Future<List<MerchantRegionItem>> merchantRegionList({
    required int pid,
  }) async {
    try {
      final response = await HttpManager.get<dynamic>(
        URL.merchantRegionList,
        params: {"pid": pid},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.code != 200) {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);
        return [];
      }

      final rawData = response.raw['data'] ?? response.data;
      if (rawData is! List) return [];

      return rawData
          .whereType<Map>()
          .map(
            (item) =>
                MerchantRegionItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((item) => item.name.isNotEmpty)
          .toList();
    } catch (e) {
      ToastUtils.showToast(message: "地区数据获取失败", type: ToastType.error);
      return [];
    }
  }

  /// 获取商户行业类型。
  static Future<List<MerchantTypeItem>> merchantTypes() async {
    try {
      final response = await HttpManager.get<dynamic>(URL.merchantType);
      if (response.code != 200) {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);
        return [];
      }

      final rawData = response.raw['data'] ?? response.data;
      if (rawData is! List) return [];

      return rawData
          .whereType<Map>()
          .map(
            (item) =>
                MerchantTypeItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((item) => item.typeName.isNotEmpty && item.isDeleted == 0)
          .toList();
    } catch (e) {
      ToastUtils.showToast(message: "行业数据获取失败", type: ToastType.error);
      return [];
    }
  }

  /// 单张图片上传，返回后端 fileName。
  static Future<String?> uploadFile({required String filePath}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await HttpManager.post<dynamic>(
        URL.uploadFile,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      if (response.code == 200) {
        final names = _extractFileNames(response.raw);
        return names.isEmpty ? null : names.first;
      }
      ToastUtils.showToast(message: response.msg, type: ToastType.error);
      return null;
    } catch (e) {
      ToastUtils.showToast(message: "图片上传失败", type: ToastType.error);
      return null;
    }
  }

  /// 多张图片上传，返回逗号拼接后的 fileName。
  static Future<String?> uploadFiles({required List<String> filePaths}) async {
    if (filePaths.isEmpty) return '';
    try {
      final files = <MultipartFile>[];
      for (final path in filePaths) {
        files.add(await MultipartFile.fromFile(path));
      }
      final formData = FormData.fromMap({'files': files});
      final response = await HttpManager.post<dynamic>(
        URL.uploadFiles,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      if (response.code == 200) {
        return _extractFileNames(response.raw).join(',');
      }
      ToastUtils.showToast(message: response.msg, type: ToastType.error);
      return null;
    } catch (e) {
      ToastUtils.showToast(message: "图片上传失败", type: ToastType.error);
      return null;
    }
  }

  /// 提交商户入驻资料。
  static Future<bool> addMerchant({
    required MerchantOnboardingRequest request,
  }) async {
    try {
      final response = await HttpManager.post(
        URL.addMerchant,
        data: request.toJson(),
      );

      if (response.code == 200) {
        ToastUtils.showToast(message: "商户入驻资料已提交。", type: ToastType.success);
        return true;
      }

      ToastUtils.showToast(message: response.msg, type: ToastType.error);
      return false;
    } catch (e) {
      ToastUtils.showToast(message: "商户入驻提交失败", type: ToastType.error);
      return false;
    }
  }

  /// 修改商户资料。
  static Future<bool> updateMerchant({
    required MerchantOnboardingRequest request,
  }) async {
    try {
      final response = await HttpManager.post(
        URL.updateMerchant,
        data: request.toJson(),
      );

      if (response.code == 200) {
        ToastUtils.showToast(
          message: response.msg.isNotEmpty ? response.msg : "商户资料已更新",
          type: ToastType.success,
        );
        return true;
      }

      ToastUtils.showToast(message: response.msg, type: ToastType.error);
      return false;
    } catch (e) {
      ToastUtils.showToast(message: "商户资料更新失败", type: ToastType.error);
      return false;
    }
  }

  /// 从上传接口响应中提取 fileName。
  static List<String> _extractFileNames(dynamic raw) {
    final names = <String>[];
    void collect(dynamic value) {
      if (value == null) return;
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        final fileName =
            map['fileName'] ??
            map['fileNames'] ??
            map['newFileName'] ??
            map['url'] ??
            map['urls'];
        if (fileName is List) {
          collect(fileName);
        } else if (fileName != null && fileName.toString().isNotEmpty) {
          names.addAll(
            fileName
                .toString()
                .split(',')
                .map((item) => item.trim())
                .where((item) => item.isNotEmpty),
          );
        }
        collect(map['data']);
        collect(map['rows']);
      } else if (value is List) {
        for (final item in value) {
          collect(item);
        }
      } else if (value is String && value.isNotEmpty) {
        names.add(value);
      }
    }

    collect(raw);
    return names.toSet().toList();
  }

  /// 忘记密码发送验证码。
  static Future<bool> sendResetCode({required String email}) async {
    try {
      final response = await HttpManager.post(
        URL.sendResetCode,
        data: {"email": email},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.code == 200) {
        return true;
      } else {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);
        return false;
      }
    } catch (e) {
      ToastUtils.showToast(message: "验证码发送失败", type: ToastType.error);
      return false;
    }
  }

  /// 忘记密码重置密码。
  static Future<bool> passwordReset({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      final response = await HttpManager.post(
        URL.updatePwd,
        data: {"email": email, "code": code, "password": password},
      );

      if (response.code == 200) {
        ToastUtils.showToast(
          message: response.msg.isNotEmpty ? response.msg : "密码重置成功",
          type: ToastType.success,
        );
        return true;
      } else {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);
        return false;
      }
    } catch (e) {
      ToastUtils.showToast(message: "密码重置失败", type: ToastType.error);
      return false;
    }
  }

  /// 商户列表。
  ///
  /// typeId = 0 表示全部。
  static Future<PageResponse<StoreResponse>?> storeList({
    required int typeId,
    required int pageNum,
    required int pageSize,
    required String shopName,
  }) async {
    try {
      final response = await HttpManager.get<PageResponse<StoreResponse>>(
        URL.merchantList,
        params: {
          "shopName": shopName,
          "typeId": typeId,
          "pageNum": pageNum,
          "pageSize": pageSize,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.code != 200) {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);
        return null;
      }
      return response.data;
    } catch (e) {
      return null;
    }
  }

  /// 我的商户列表。
  ///
  /// 后端直接返回数组，不分页；这里从原始 data 中解析，避免泛型 List
  /// 在 FactoryModel 中没有注册时解析失败。
  static Future<List<StoreResponse>> myMerchantList() async {
    try {
      final response = await HttpManager.get<dynamic>(
        URL.myMerchantList,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.code != 200) {
        ToastUtils.showToast(message: response.msg, type: ToastType.error);
        return [];
      }

      final rawData = response.raw['data'] ?? response.data;
      if (rawData is! List) return [];

      return rawData
          .whereType<Map>()
          .map(
            (item) => StoreResponse.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((item) => item.shopId > 0 && item.isDeleted == 0)
          .toList();
    } catch (e) {
      ToastUtils.showToast(message: "我的商户获取失败", type: ToastType.error);
      return [];
    }
  }
}
