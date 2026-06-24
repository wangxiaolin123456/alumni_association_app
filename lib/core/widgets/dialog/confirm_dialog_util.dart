import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/app.dart';
import '../../../util/click_util.dart';

class ConfirmDialogUtil {
  /// 显示确认对话框
  static Future<bool?> show({
    required String message,
    String title = '',
    String cancelText = 'キャンセル',
    String confirmText = '確定',
    Color text1Color = const Color(0xFF808080),
    Color text2Color = Colors.black,
    bool showCancelButton = true,
    bool barrierDismissible = true,
  }) async {
    final context = navigatorKey.currentContext;
    if (context == null) return null;
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return OrientationBuilder(
          builder: (context, orientation) {
            final isLandscape = orientation == Orientation.landscape;
            final mq = MediaQuery.of(context);
            final screenW = mq.size.width;
            final screenH = mq.size.height;
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.w),
              ),
              backgroundColor: Colors.white,
              child: isLandscape
                  ? ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenW * 0.7,
                ),
                child: _buildDialogContent(isLandscape, title, message, text1Color, text2Color, cancelText, confirmText, showCancelButton,context),
              )
                  : _buildDialogContent(isLandscape, title, message, text1Color, text2Color, cancelText, confirmText, showCancelButton,context),
            );
          },
        );
      },
    );
  }

}
Widget _buildDialogContent(
    bool isLandscape,
    String title,
    String message,
    Color text1Color,
    Color text2Color,
    String cancelText,
    String confirmText,
    bool showCancelButton,
    BuildContext context,
    ) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: isLandscape ? 10.w:20.w, horizontal: isLandscape ? 10.w:15.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10.h),
        // if (title.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(bottom: message.isNotEmpty? 10.h:0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isLandscape ?9.sp:20.sp,
              color: Colors.black,
            ),
          ),
        ),
        if (message.isNotEmpty)
          Text(
            message,
            style: TextStyle(
              height: 1.2,
              fontWeight: FontWeight.bold,
              fontSize: isLandscape ?10.sp:20.sp,
              color: Colors.black54,
            ),
          ),
        SizedBox(height: isLandscape ?20.h:40.h),
        Row(
          children: [
            if (showCancelButton) ...[
              Expanded(
                child: _buildNoIconButton(
                  text: cancelText,
                  textColor: text1Color,
                  borderRadius: 24.w,
                  height:  isLandscape ? 52 :42,
                  textSize: isLandscape ? 10 :20,
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
              SizedBox(width: isLandscape ?6.w:12.w),
            ],
            Expanded(
              child: _buildNoIconButton(
                text: confirmText,
                textColor: text2Color,
                borderRadius: 24.w,
                height:  isLandscape ? 52 :42,
                textSize: isLandscape ? 10 :20,
                onTap: () async {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}





///封装的顶部按钮
Widget _buildNoIconButton({
  required String text,
  required VoidCallback onTap,
  double height = 42,
  double borderRadius = 20,
  Color textColor = Colors.black,
  int textSize = 20,
  bool isLandscape = false,
  bool enabled = true,
}) {
  // 置灰的渐变色
  const List<Color> disabledGradient = [
    Color(0xFFE5E5E5),
    Color(0xFFCCCCCC),
  ];

  const List<Color> activeGradient = [
    Color(0xFFF2F4F6),
    Color(0xFFDADDDF),
  ];
  return InkWell(
    onTap: (){
      if (!enabled) return;              // 先判断按钮是否可用
      if (ClickUtil.isFastClick()) return;  // 再判断是否是快速连点
      onTap();                           // 最终执行回调
    },
    child: Container(
      width: double.infinity,
      // ✅ 宽度充满横屏
      height: height.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: enabled ? activeGradient : disabledGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          // fontFamily: 'MiSans',
          fontSize: isLandscape?10.sp:textSize.sp,
          color: enabled ? textColor : Color(0xFFA6A6A6),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}