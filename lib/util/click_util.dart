///防止连点
class ClickUtil {
  static int _lastClickTime = 0;
  static const int minDelay = 1000; // 毫秒，1 秒内不允许再次点击

  static bool isFastClick() {
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - _lastClickTime < minDelay) {
      return true; // 是连点
    }
    _lastClickTime = currentTime;
    return false;
  }
}