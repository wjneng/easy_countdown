import 'package:flutter/material.dart';

/// 倒计时配置
class CountDownConfig {
  /// 倒计时总时长
  final Duration duration;

  /// 是否自动开始倒计时
  final bool autoPlay;

  /// 倒计时刷新周期（默认1秒）
  final Duration interval;

  /// 是否允许倒计时为负（默认禁止，避免异常）
  final bool allowNegative;

  /// 重置时是否恢复初始时长（默认true，支持保留当前剩余时长重置）
  final bool resetToOriginal;

  /// 倒计时结束回调
  final VoidCallback? onDone;

  CountDownConfig(
      {required this.duration,
      this.autoPlay = true,
      this.interval = const Duration(seconds: 1),
      this.allowNegative = false,
      this.resetToOriginal = true,
      this.onDone})
      : assert(duration.inMicroseconds >= 0, "倒计时时长不能为负数");

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountDownConfig &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          autoPlay == other.autoPlay &&
          interval == other.interval &&
          allowNegative == other.allowNegative &&
          resetToOriginal == other.resetToOriginal &&
          onDone == other.onDone;

  @override
  int get hashCode => Object.hash(
      duration, autoPlay, interval, allowNegative, resetToOriginal, onDone);
}
