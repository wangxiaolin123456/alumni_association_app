import '../../features/auth/model/response/login_response.dart';
import '../../features/auth/model/response/user_info_response.dart';

class FactoryModel {
  static T generateModel<T>(json) {
    if (T.toString() == 'Map<dynamic，dynamic>' ||
        T.toString() == 'String' ||
        T.toString() == 'List' ||
        T.toString() == 'bool' ||
        T.toString() == 'int') {
      return json as T;
    }

    if (T.toString() == (LoginResponse).toString()) {
      return LoginResponse.fromJson(json) as T;
    }
    if (T.toString() == (UserInfoResponse).toString()) {
      return UserInfoResponse.fromJson(json) as T;
    }

    return json;
  }
}
