import 'package:flutter/material.dart';

/// 管理列表通用状态。
enum ProfileManageStatus { online, offline }

/// 商机管理和活动管理共用的卡片模型。
///
/// 两个页面字段相近，用一个模型可以保证列表样式与操作逻辑统一。
class ProfileManagementItem {
  const ProfileManagementItem({
    required this.title,
    required this.category,
    required this.publishTime,
    required this.status,
    required this.icon,
    required this.iconColor,
    this.location,
    this.participantCount,
    this.views = 0,
    this.inquiries = 0,
  });

  final String title;
  final String category;
  final String publishTime;
  final ProfileManageStatus status;
  final IconData icon;
  final Color iconColor;
  final String? location;
  final int? participantCount;
  final int views;
  final int inquiries;

  ProfileManagementItem copyWith({ProfileManageStatus? status}) {
    return ProfileManagementItem(
      title: title,
      category: category,
      publishTime: publishTime,
      status: status ?? this.status,
      icon: icon,
      iconColor: iconColor,
      location: location,
      participantCount: participantCount,
      views: views,
      inquiries: inquiries,
    );
  }
}
