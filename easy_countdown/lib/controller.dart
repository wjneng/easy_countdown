import 'package:easy_countdown/enum.dart';
import 'package:easy_countdown/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 倒计时控制器
class EasyCountdownController {
  VoidCallback? onStart;
  VoidCallback? onPause;
  VoidCallback? onReset;
  final ValueNotifier<Duration> remainingDurationNotifier =
      ValueNotifier(Duration.zero);
  final ValueNotifier<CountdownStatus> statusNotifier =
      ValueNotifier(CountdownStatus.idle);
  ValueSetter<Duration>? setRemainingDuration;

  final void Function(CountDownProgress)? onProgress;
  EasyCountdownController({this.onProgress});

  /// 开始倒计时
  void start() {
    if (statusNotifier.value != CountdownStatus.running) {
      onStart?.call();
    }
  }

  /// 暂停倒计时
  void pause() {
    if (statusNotifier.value == CountdownStatus.running) {
      onPause?.call();
    }
  }

  /// 重置倒计时
  void reset() {
    onReset?.call();
  }

  /// 手动设置剩余时长
  void updateRemainingDuration(Duration duration) {
    assert(duration.inMilliseconds >= 0, "剩余时长不能为负数");
    // 确保设置的时长不为负
    final validDuration =
        duration.inMilliseconds < 0 ? Duration.zero : duration;
    setRemainingDuration?.call(validDuration);
  }

  /// 获取当前剩余时长（实时同步）
  Duration get remainingDuration => remainingDurationNotifier.value;

  /// 获取当前倒计时状态（实时同步）
  CountdownStatus get status => statusNotifier.value;

  /// 销毁控制器
  void dispose() {
    onStart = null;
    onPause = null;
    onReset = null;
    setRemainingDuration = null;
    remainingDurationNotifier.dispose();
    statusNotifier.dispose();
  }
}
