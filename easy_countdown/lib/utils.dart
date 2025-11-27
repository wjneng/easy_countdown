/// 倒计时格式化工具类（支持多格式/补零/自适应）
class CountdownFormatUtils {
  /// 格式化时长为 HH:mm:ss 格式（自动补零）
  static String formatHHmmss(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  /// 格式化时长为 mm:ss 格式（自动补零）
  static String formatMmss(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// 格式化时长为 ss 格式（自动补零）
  static String formatSs(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return twoDigits(duration.inSeconds.remainder(60));
  }

  /// 自适应格式化（根据时长自动选择格式）
  static String formatAuto(Duration duration) {
    if (duration.inHours > 0) {
      return formatHHmmss(duration);
    } else if (duration.inMinutes > 0) {
      return formatMmss(duration);
    } else {
      return formatSs(duration);
    }
  }

  /// 格式化为中文描述（如“1小时2分3秒”）
  static String formatChinese(Duration duration) {
    final parts = <String>[];
    if (duration.inHours > 0) {
      parts.add('${duration.inHours}小时');
    }
    final minutes = duration.inMinutes.remainder(60);
    if (minutes > 0) {
      parts.add('$minutes分');
    }
    final seconds = duration.inSeconds.remainder(60);
    if (seconds > 0 || parts.isEmpty) {
      parts.add('$seconds秒');
    }
    return parts.join('');
  }
}
