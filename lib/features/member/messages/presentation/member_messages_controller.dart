import 'package:alumni_association_app/features/member/messages/model/response/member_message_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberMessagesController extends GetxController {
  final selectedTab = 0.obs;
  final readIds = <String>{}.obs;

  /// 消息列表模拟接口返回，类型用于顶部分类筛选。
  final messages = const <MemberMessageResponse>[
    MemberMessageResponse(
      id: 'message-001',
      type: 'system',
      title: '校友认证已通过',
      content: '你的校友认证已审核通过，电子会员卡已生成。',
      time: '刚刚',
      iconCode: 0xe699,
    ),
    MemberMessageResponse(
      id: 'message-002',
      type: 'activity',
      title: '活动报名成功',
      content: '你已成功报名全球校友联谊会，请准时参加。',
      time: '2小时前',
      iconCode: 0xe491,
    ),
    MemberMessageResponse(
      id: 'message-003',
      type: 'merchant',
      title: '创享餐饮商会发布新优惠',
      content: '会员专享8.5折优惠已上线，欢迎到店使用。',
      time: '昨天',
      iconCode: 0xe59c,
    ),
  ];

  List<MemberMessageResponse> get filteredMessages {
    final type = switch (selectedTab.value) {
      1 => 'system',
      2 => 'activity',
      3 => 'merchant',
      _ => '',
    };
    return type.isEmpty
        ? messages
        : messages.where((item) => item.type == type).toList();
  }

  IconData iconFor(MemberMessageResponse message) =>
      IconData(message.iconCode, fontFamily: 'MaterialIcons');

  /// 点击消息后立即消除未读圆点。
  void markRead(String id) => readIds.add(id);

  void markAllRead() => readIds.assignAll(messages.map((item) => item.id));
}
