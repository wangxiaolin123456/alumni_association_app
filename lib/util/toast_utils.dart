import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
enum ToastType { success, warning, error, info }

class ToastUtils {
  ///Get.snackbar
  static void showToast({
    required String message,
    ToastType type = ToastType.info,
    int duration = 3000,
  }) {
    final orientation = MediaQuery.of(Get.context!).orientation;
    print("竖屏${orientation == Orientation.portrait}");

    // 根据横竖屏选择不同的字体大小
    double fontSize = orientation == Orientation.portrait ? 18.sp : 12.sp;
    double iconSize  = orientation == Orientation.portrait ? 20.sp : 16.sp;
    Color bgColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        bgColor = Color(0xFF5EC907);
        icon = Icons.check_circle;
        break;
      case ToastType.warning:
        bgColor = Colors.red;
        icon = Icons.warning;
        break;
      case ToastType.error:
        bgColor = Colors.orange;
        icon = Icons.error;
        break;
      case ToastType.info:
      default:
        bgColor = Colors.black87;
        icon = Icons.info;
        break;
    }

    Get.snackbar(
      '', // 没有标题
      '',///message
      backgroundColor: bgColor,///Colors.white.withOpacity(0.2)
      colorText: Colors.white,
      // titleText: const SizedBox.shrink(), // ✅ 不显示标题
      /// ✅ 自定义标题组件，放入图标和文字
      titleText: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // ✅ 垂直居中
        children: [
          Icon(icon, color: Colors.white, size: iconSize),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(

                height: 1.3,
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      // messageText: Text(
      //   message,
      //   style: TextStyle(
      //     fontSize: 14.sp, // ✅ 设置提示文字大小
      //     color: bgColor,
      //     fontWeight: FontWeight.w500,
      //   ),
      // ),
      duration: Duration(milliseconds: duration),
      // icon: Icon(icon, color:bgColor),
      /// ✅ 避免 messageText 和 icon 冲突
      messageText: const SizedBox.shrink(),
      icon: null,
      padding: EdgeInsets.only(top: orientation == Orientation.portrait?10.h:12.h,bottom:3.h,left: 8.w,),
      // margin:  EdgeInsets.symmetric(horizontal: 20.w),
      snackPosition: SnackPosition.TOP,
      borderRadius: 26.w,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}




