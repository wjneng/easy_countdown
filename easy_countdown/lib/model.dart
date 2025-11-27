import 'package:easy_countdown/enum.dart';

class CountDownProgress {
  final Duration remaining; // 剩余时间
  final Duration total; // 总时间
  final double progress; // 进度
  final CountdownStatus status; // 状态

  CountDownProgress(this.remaining, this.total, this.progress, this.status);
}
