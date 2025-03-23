import 'package:flustars/flustars.dart';

String formatDateMsByMS(int milliseconds) {
  return DateUtil.formatDateMs(milliseconds, format: 'mm:ss');
}

String formatDateMsByYMD(int milliseconds) {
  return DateUtil.formatDateMs(milliseconds, format: 'yyyy/MM/dd');
}

String formatDateMsByYMDHM(int milliseconds) {
  return DateUtil.formatDateMs(milliseconds, format: 'yyyy/MM/dd HH:mm');
}

String formatDuration(int seconds) {
  final duration = Duration(seconds: seconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final secs = duration.inSeconds.remainder(60);

  final hoursString = hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : '';
  final minutesString = minutes.toString().padLeft(2, '0');
  final secondsString = secs.toString().padLeft(2, '0');

  return '$hoursString$minutesString:$secondsString';
}
