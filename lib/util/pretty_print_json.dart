import 'dart:convert';
import 'package:flutter/foundation.dart';

void printJsonLine(dynamic data) {
  try {
    // 如果 data 是 String(可能已经是 json)，尝试 decode 再 encode，保证格式统一
    dynamic obj = data;
    if (data is String) {
      try {
        obj = jsonDecode(data);
      } catch (_) {
        // 不是 json 字符串就原样
        obj = data;
      }
    }

    final line = jsonEncode(obj); // ✅ 标准 JSON：带双引号、单行
    _printLong(line);             // ✅ 分段，保证不截断
  } catch (e) {
    _printLong(data.toString());
  }
}

void _printLong(String text) {
  const chunkSize = 800;
  for (var i = 0; i < text.length; i += chunkSize) {
    final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
    debugPrint(text.substring(i, end));
  }
}