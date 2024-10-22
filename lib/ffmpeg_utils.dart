import 'dart:io';

// تابع برای ادغام ویدیو و صدا با استفاده از FFmpeg
Future<void> mergeVideoAndAudio(
    String videoPath, String audioPath, String outputPath) async {
  var result = await Process.run('ffmpeg', [
    '-i', videoPath, // ورودی ویدیو
    '-i', audioPath, // ورودی صدا
    '-c:v', 'copy', // کپی استریم ویدیویی بدون تغییر
    '-c:a', 'aac', // استفاده از کدک AAC برای صدا
    outputPath // خروجی فایل نهایی
  ]);

  if (result.exitCode != 0) {
    print('\x1B[32mfailed to merge video & audio:\x1B[0m ${result.stderr}');
  } else {
    print('\x1B[32mSuccessfully merged video & audio\x1B[0m\n');
  }
}
