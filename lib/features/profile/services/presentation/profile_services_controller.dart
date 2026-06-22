import 'package:alumni_association_app/core/network/api_request.dart';
import 'package:alumni_association_app/features/profile/services/model/profile_service_item.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfileServicesController extends GetxController {
  final selectedHelpIndex = (-1).obs;
  final submittedFeedback = false.obs;
  final feedbackType = 0.obs;
  final feedbackController = TextEditingController();
  final contactController = TextEditingController(text: '13888885678');

  final myOpportunities = const <ProfileServiceItem>[
    ProfileServiceItem(
      id: 'mine-op-1',
      title: '寻找餐饮供应链合作伙伴',
      subtitle: '合作需求 · 餐饮行业',
      meta: '浏览 1280 · 收藏 86',
      status: 'ongoing',
      iconCode: 0xe8f9,
      color: 0xFF0967F2,
    ),
    ProfileServiceItem(
      id: 'mine-op-2',
      title: '寻找软件开发外包团队',
      subtitle: '合作需求 · 互联网',
      meta: '浏览 680 · 收藏 38',
      status: 'ongoing',
      iconCode: 0xe8f9,
      color: 0xFF1687E8,
    ),
  ];
  final myPosts = const <ProfileServiceItem>[
    ProfileServiceItem(
      id: 'post-1',
      title: '校友企业招聘信息分享',
      subtitle: '动态发布 · 公开可见',
      meta: '2026-06-12 · 点赞 36',
      status: 'published',
      iconCode: 0xe163,
      color: 0xFF7155EA,
    ),
    ProfileServiceItem(
      id: 'post-2',
      title: '行业资源对接经验交流',
      subtitle: '动态发布 · 校友可见',
      meta: '2026-06-08 · 评论 18',
      status: 'published',
      iconCode: 0xe163,
      color: 0xFFA072F2,
    ),
  ];
  final myActivities = const <ProfileServiceItem>[
    ProfileServiceItem(
      id: 'act-1',
      title: '全球校友联谊会',
      subtitle: '2026-06-15 14:00 · 上海浦东',
      meta: '报名成功 · 待参加',
      status: 'upcoming',
      iconCode: 0xe878,
      color: 0xFF0967F2,
    ),
    ProfileServiceItem(
      id: 'act-2',
      title: '创享餐饮行业交流会',
      subtitle: '2026-06-20 14:00 · 上海静安',
      meta: '报名成功 · 待参加',
      status: 'upcoming',
      iconCode: 0xe878,
      color: 0xFF19B96B,
    ),
  ];
  final myBenefits = const <ProfileServiceItem>[
    ProfileServiceItem(
      id: 'benefit-1',
      title: '会员专享9折券',
      subtitle: '创享餐饮商会 · 无门槛',
      meta: '有效期至 2026-06-30',
      status: 'available',
      iconCode: 0xe8f6,
      color: 0xFFFF7A1A,
    ),
    ProfileServiceItem(
      id: 'benefit-2',
      title: '酒店房型立减券',
      subtitle: '悦享酒店集团 · 满500可用',
      meta: '有效期至 2026-07-15',
      status: 'available',
      iconCode: 0xe8f6,
      color: 0xFF0967F2,
    ),
  ];

  final helpQuestionCodes = const [
    'certification',
    'benefits',
    'activity',
    'opportunity',
    'service',
  ];

  void toggleHelp(int index) =>
      selectedHelpIndex.value = selectedHelpIndex.value == index ? -1 : index;

  /// 校验反馈内容并调用模拟提交接口。
  Future<bool> submitFeedback() async {
    if (feedbackController.text.trim().isEmpty) return false;
    final apiSuccess = await ApiRequest.submitFeedback(
      type: feedbackType.value,
      content: feedbackController.text.trim(),
      contact: contactController.text.trim(),
    );
    // 接口暂未接通时，在 Controller 中模拟提交成功。
    final success = apiSuccess || feedbackController.text.trim().isNotEmpty;
    submittedFeedback.value = success;
    return success;
  }

  @override
  void onClose() {
    feedbackController.dispose();
    contactController.dispose();
    super.onClose();
  }
}
