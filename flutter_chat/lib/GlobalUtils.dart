/// -------------------------------
/// Created with Flutter Dart File.
/// User tianNanYiHao@163.com
/// Date: 2020-08-10
/// Time: 11:26
/// Des: 用于记录一些 全局共享的基础数据
/// -------------------------------

///

import 'dart:ui';

class GlobalUtils {
  static num screenW; //设备的宽高
  static num screenH; //设备的宽高
  static num devicePixelRatio; // 设备的像素密度
  static Size physicalSize; // 设备的尺寸... (px)

  /// 初始化设备的宽高
  /// 全局记录设备的基本信息
  static initDevice() {
    // 从 window对象获取屏幕的物理尺寸(px) 及 像素密度
    final physicalSize = window.physicalSize;
    final devicePixelRatio = window.devicePixelRatio;
    GlobalUtils.devicePixelRatio = devicePixelRatio;
    GlobalUtils.physicalSize = physicalSize;
    // 计算出ios/android 常用的屏幕宽高 (dp / pt);
    GlobalUtils.screenW =
        GlobalUtils.physicalSize.width / GlobalUtils.devicePixelRatio;
    GlobalUtils.screenH =
        GlobalUtils.physicalSize.height / GlobalUtils.devicePixelRatio;
  }

  static const selectColors = [
    Color.fromRGBO(6, 1, 0, 1.0),
    Color.fromRGBO(54, 50, 39, 1.0),
    Color.fromRGBO(152, 143, 134, 1.0),
    Color.fromRGBO(242, 233, 224, 1.0),
  ];

  static const unselectColors = [
    Color.fromRGBO(255, 252, 252, 1.0),
    Color.fromRGBO(230, 218, 206, 1.0),
    Color.fromRGBO(164, 150, 123, 1.0),
    Color.fromRGBO(99, 81, 57, 1.0),
  ];

  static const colorPrimary = Color(0xffB39561);
  static const colorSecond = Color(0xffEDD8BF);
  static const colorPrimaryDark = Color(0xB39561);
  static const colorAccent = Color(0xffB39561);

  static fitSize(int srcSize) {
    return srcSize;
  }
}
