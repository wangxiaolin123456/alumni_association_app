import 'dart:developer' as developer;

import 'package:alumni_association_app/core/network/core/http_manager.dart';
import 'package:alumni_association_app/core/network/model/json_request.dart';
import 'package:alumni_association_app/core/network/model/page_response.dart';
import 'package:alumni_association_app/features/activity/model/response/activity_response.dart';
import 'package:alumni_association_app/features/member/record_center/model/response/member_record_response.dart';
import 'package:alumni_association_app/features/opportunity/model/response/opportunity_response.dart';
import 'package:alumni_association_app/features/profile/services/model/profile_service_item.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:get/get.dart';

/// 后端接口地址统一维护。
abstract final class URL {
  static const String storeList = '/member/store/list';
  static const String activityList = '/member/activity/list';
  static const String opportunityList = '/member/opportunity/list';
  static const String registrationRecords = '/member/records/registrations';
  static const String favoriteMerchants = '/member/records/favorite-merchants';
  static const String browsingRecords = '/member/records/browsing';
  static const String myOpportunities = '/member/profile/my-opportunities';
  static const String myPosts = '/member/profile/my-posts';
  static const String myActivities = '/member/profile/my-activities';
  static const String myBenefits = '/member/profile/my-benefits';
  static const String submitFeedback = '/member/profile/feedback';
}

/// 业务接口请求统一入口。
///
/// 此文件只负责真实网络请求和数据解析，不保存或制造业务假数据。
abstract final class ApiRequest {
  static HttpManager get _http => Get.find<HttpManager>();

  static Future<PageResponse<StoreResponse>?> storeList({
    required int pageNum,
    required int pageSize,
  }) => _getPage(
    path: URL.storeList,
    pageNum: pageNum,
    pageSize: pageSize,
    parser: StoreResponse.fromJson,
    errorMessage: '获取商家列表出错',
  );

  static Future<PageResponse<ActivityResponse>?> activityList({
    required int pageNum,
    required int pageSize,
    String? keyword,
    String? category,
  }) => _getPage(
    path: URL.activityList,
    pageNum: pageNum,
    pageSize: pageSize,
    params: {'keyword': keyword, 'category': category},
    parser: ActivityResponse.fromJson,
    errorMessage: '获取活动列表出错',
  );

  static Future<PageResponse<OpportunityResponse>?> opportunityList({
    required int pageNum,
    required int pageSize,
  }) => _getPage(
    path: URL.opportunityList,
    pageNum: pageNum,
    pageSize: pageSize,
    parser: OpportunityResponse.fromJson,
    errorMessage: '获取商机列表出错',
  );

  static Future<PageResponse<MemberRecordResponse>?> registrationRecords({
    required int pageNum,
    required int pageSize,
  }) => _getPage(
    path: URL.registrationRecords,
    pageNum: pageNum,
    pageSize: pageSize,
    parser: MemberRecordResponse.fromJson,
    errorMessage: '获取报名记录出错',
  );

  static Future<PageResponse<MemberRecordResponse>?> favoriteMerchants({
    required int pageNum,
    required int pageSize,
  }) => _getPage(
    path: URL.favoriteMerchants,
    pageNum: pageNum,
    pageSize: pageSize,
    parser: MemberRecordResponse.fromJson,
    errorMessage: '获取收藏商家出错',
  );

  static Future<PageResponse<MemberRecordResponse>?> browsingRecords({
    required int pageNum,
    required int pageSize,
  }) => _getPage(
    path: URL.browsingRecords,
    pageNum: pageNum,
    pageSize: pageSize,
    parser: MemberRecordResponse.fromJson,
    errorMessage: '获取浏览记录出错',
  );

  static Future<PageResponse<ProfileServiceItem>?> myOpportunityList({
    required int pageNum,
    required int pageSize,
  }) => _getPage(
    path: URL.myOpportunities,
    pageNum: pageNum,
    pageSize: pageSize,
    parser: ProfileServiceItem.fromJson,
    errorMessage: '获取我的商机出错',
  );

  static Future<PageResponse<ProfileServiceItem>?> myPostList({
    required int pageNum,
    required int pageSize,
  }) => _getPage(
    path: URL.myPosts,
    pageNum: pageNum,
    pageSize: pageSize,
    parser: ProfileServiceItem.fromJson,
    errorMessage: '获取我的发布出错',
  );

  static Future<PageResponse<ProfileServiceItem>?> myActivityList({
    required int pageNum,
    required int pageSize,
  }) => _getPage(
    path: URL.myActivities,
    pageNum: pageNum,
    pageSize: pageSize,
    parser: ProfileServiceItem.fromJson,
    errorMessage: '获取我的活动出错',
  );

  static Future<PageResponse<ProfileServiceItem>?> myBenefitList({
    required int pageNum,
    required int pageSize,
  }) => _getPage(
    path: URL.myBenefits,
    pageNum: pageNum,
    pageSize: pageSize,
    parser: ProfileServiceItem.fromJson,
    errorMessage: '获取我的权益出错',
  );

  static Future<bool> submitFeedback({
    required int type,
    required String content,
    required String contact,
  }) async {
    try {
      await _http.post<Object?>(
        URL.submitFeedback,
        body: MapJsonRequest({
          'type': type,
          'content': content,
          'contact': contact,
        }),
      );
      return true;
    } catch (error) {
      developer.log('提交意见反馈出错', error: error);
      return false;
    }
  }

  static Future<PageResponse<T>?> _getPage<T>({
    required String path,
    required int pageNum,
    required int pageSize,
    required T Function(Map<String, dynamic> json) parser,
    required String errorMessage,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final query = <String, dynamic>{
        'pageNum': pageNum,
        'pageSize': pageSize,
        ...params,
      }..removeWhere((_, value) => value == null || value == '');
      final response = await _http.get<PageResponse<T>>(
        path,
        query: MapJsonRequest(query),
        parser: (json) => PageResponse<T>.fromJson(
          json as Map<String, dynamic>,
          (item) => parser(item as Map<String, dynamic>),
        ),
      );
      return response.data;
    } catch (error) {
      developer.log(errorMessage, error: error);
      return null;
    }
  }
}
