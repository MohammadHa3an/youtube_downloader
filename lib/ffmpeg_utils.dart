import 'dart:io';

//// merge the Video and Audio
Future<void> mergeVideoAndAudio(
    String videoPath, String audioPath, String outputPath) async {
  var result = await Process.run('ffmpeg', [
    '-i', videoPath, //// video input
    '-i', audioPath, //// Audio input
    '-c:v', 'copy', //// Copy stream without changes
    '-c:a', 'aac', //// use AAC codec for audio
    outputPath //// final output
  ]);

  if (result.exitCode != 0) {
    print('\x1B[32mfailed to merge video & audio:\x1B[0m ${result.stderr}');
  } else {
    print('\x1B[32mSuccessfully merged video & audio\x1B[0m\n');
  }
}
