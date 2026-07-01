import 'package:alumni_association_app/features/consumption/model/response/order_response.dart';
import 'package:alumni_association_app/http/model/page_response.dart';

import '../../features/auth/model/response/login_response.dart';
import '../../features/auth/model/response/user_info_response.dart';
import '../../features/store/model/response/store_response.dart';

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
    if (T == PageResponse<StoreResponse>) {
      return PageResponse<StoreResponse>.fromJson(
        Map<String, dynamic>.from(json as Map),
        StoreResponse.fromJson,
      ) as T;
    }
    if (T.toString() == (OrderResponse).toString()) {
      return OrderResponse.fromJson(json) as T;
    }
    if (T == PageResponse<OrderResponse>) {
      return PageResponse<OrderResponse>.fromJson(
        Map<String, dynamic>.from(json as Map),
        OrderResponse.fromJson,
      ) as T;
    }
    return json;
  }
}
