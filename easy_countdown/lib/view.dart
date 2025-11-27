import 'dart:async';
import 'dart:math' as math;

import 'package:easy_countdown/config.dart';
import 'package:easy_countdown/controller.dart';
import 'package:easy_countdown/enum.dart';
import 'package:easy_countdown/model.dart';
import 'package:flutter/material.dart';

class EasyCountdown extends StatefulWidget {
  final CountDownConfig config;
  final Widget Function(
      BuildContext context, Duration value, CountdownStatus status) builder;
  final EasyCountdownController? controller;

  const EasyCountdown(
      {super.key,
      required this.config,
      required this.builder,
      this.controller});

  @override
  State<EasyCountdown> createState() => _EasyCountdownState();
}

class _EasyCountdownState extends State<EasyCountdown> {
  Timer? _timer;
  late Duration _remainingDuration;
  late Duration _totalDuration;
  late CountdownStatus _status;

  @override
  void initState() {
    super.initState();
    _totalDuration = widget.config.duration.inMilliseconds < 0
        ? Duration.zero
        : widget.config.duration;
    _remainingDuration = _totalDuration;
    _status = _totalDuration.inMilliseconds == 0
        ? CountdownStatus.completed
        : CountdownStatus.idle;
    _bindController();

    // 延迟初始化自动播放，避免帧冲突
    if (widget.config.autoPlay && _totalDuration.inMilliseconds > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _startCountdown();
      });
    }
  }

  void _bindController() {
    if (widget.controller != null) {
      widget.controller!.onStart = _startCountdown;
      widget.controller!.onPause = _stopCountdown;
      widget.controller!.onReset = _resetCountdown;
      widget.controller!.setRemainingDuration = _updateRemainingDuration;
      // 初始化通知器
      widget.controller!.remainingDurationNotifier.value = _remainingDuration;
      widget.controller!.statusNotifier.value = _status;
    }
  }

  void _updateRemainingDuration(Duration duration) {
    if (mounted) {
      setState(() {
        _remainingDuration = duration;
        _totalDuration = widget.config.resetToOriginal
            ? widget.config.duration
            : _totalDuration;
        // 同步更新状态
        if (_remainingDuration.inMilliseconds == 0) {
          _status = CountdownStatus.completed;
        } else if (_remainingDuration.inMilliseconds < 0 &&
            widget.config.allowNegative) {
          _status = CountdownStatus.overtime;
        }
        _syncControllerState();
      });
    }
  }

  void _startCountdown() {
    if (_status == CountdownStatus.completed && !widget.config.allowNegative) {
      _resetCountdown();
    }

    _timer?.cancel();
    _status =
        _remainingDuration.inMilliseconds < 0 && widget.config.allowNegative
            ? CountdownStatus.overtime
            : CountdownStatus.running;

    _timer = Timer.periodic(widget.config.interval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final newRemaining = _remainingDuration - widget.config.interval;
      _remainingDuration = widget.config.allowNegative
          ? newRemaining
          : Duration(milliseconds: math.max(0, newRemaining.inMilliseconds));

      // 状态更新逻辑
      if (!widget.config.allowNegative) {
        if (_remainingDuration.inMilliseconds <= 0) {
          _remainingDuration = Duration.zero;
          _status = CountdownStatus.completed;
          _stopCountdown(isUpdate: true);
          widget.config.onDone?.call();
        } else {
          _status = CountdownStatus.running;
        }
      } else {
        _status = _remainingDuration.inMilliseconds > 0
            ? CountdownStatus.running
            : CountdownStatus.overtime;
      }
      _syncControllerState();

      _updateProgress();
      setState(() {});
    });
    _syncControllerState();
  }

  void _stopCountdown({bool isUpdate = false}) {
    _timer?.cancel();
    _timer = null;
    if (_status != CountdownStatus.completed &&
        _status != CountdownStatus.overtime) {
      _status = CountdownStatus.paused;
    }
    _syncControllerState();

    if (!isUpdate) {
      _updateProgress();
    }
    setState(() {});
  }

  void _resetCountdown() {
    if (mounted) {
      setState(() {
        _remainingDuration =
            widget.config.resetToOriginal ? _totalDuration : _remainingDuration;
        _status = _remainingDuration.inMilliseconds == 0
            ? CountdownStatus.completed
            : (_remainingDuration.inMilliseconds < 0 &&
                    widget.config.allowNegative
                ? CountdownStatus.overtime
                : CountdownStatus.idle);
        _syncControllerState();
      });

      if (widget.config.autoPlay) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _startCountdown();
        });
      } else {
        _stopCountdown();
      }
    }
  }

  _updateProgress() {
    final progress = _totalDuration.inMilliseconds == 0
        ? 0.0
        : _remainingDuration.inMilliseconds / _totalDuration.inMilliseconds;
    widget.controller?.onProgress?.call(CountDownProgress(
        _remainingDuration, _totalDuration, progress.clamp(0.0, 1.0), _status));
  }

  // 同步状态到控制器
  void _syncControllerState() {
    if (widget.controller != null) {
      widget.controller!.remainingDurationNotifier.value = _remainingDuration;
      widget.controller!.statusNotifier.value = _status;
    }
  }

  @override
  void didUpdateWidget(covariant EasyCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != oldWidget.config) {
      _totalDuration = widget.config.duration.inMilliseconds < 0
          ? Duration.zero
          : widget.config.duration;
      _remainingDuration =
          widget.config.resetToOriginal ? _totalDuration : _remainingDuration;
      _stopCountdown();

      if (widget.controller != null) {
        if (oldWidget.controller != widget.controller) {
          oldWidget.controller?.dispose();
          _bindController();
        } else {
          _syncControllerState();
        }
      }

      // 延迟自动播放，避免状态闪烁
      if (widget.config.autoPlay) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _startCountdown();
        });
      }

      _status = _remainingDuration.inMilliseconds == 0
          ? CountdownStatus.completed
          : (_remainingDuration.inMilliseconds < 0 &&
                  widget.config.allowNegative
              ? CountdownStatus.overtime
              : CountdownStatus.idle);
      _syncControllerState();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    if (widget.controller != null) {
      widget.controller!.onStart = null;
      widget.controller!.onPause = null;
      widget.controller!.onReset = null;
      widget.controller!.setRemainingDuration = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingDuration.inMilliseconds < 0 && !widget.config.allowNegative) {
      _remainingDuration = Duration.zero;
      _status = CountdownStatus.completed;
      _syncControllerState();
    }
    return widget.builder(context, _remainingDuration, _status);
  }
}
