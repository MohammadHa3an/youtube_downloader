import 'dart:io';

import 'package:youtube_dl/ffmpeg_utils.dart';
import 'package:youtube_dl/file_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeDownloader {
  final YoutubeExplode yt = YoutubeExplode();

  Future<void> downloadVideo() async {
    try {
      print('\x1B[36mPaste YouTube Link\x1B[0m:');
      //// get url from client
      var videoUrl = stdin.readLineSync();

      //// get data from server
      var video = await yt.videos.get(videoUrl);

      //// show video title
      var safeTitle = sanitizeFileName(video.title);
      print('\x1B[33mVideo title:\x1B[0m \x1B[35m$safeTitle\x1B[0m');

      //// show time duration
      print(
          '\x1B[33mVideo Time Duration:\x1B[0m \x1B[35m${video.duration}\x1B[0m');

      //// show discription
      print(
          '\x1B[33mDescription:\x1B[0m \x1B[35m${video.description}\x1B[0m\n');

      //// get stream manifest
      var manifest = await yt.videos.streams.getManifest(videoUrl);

      //// show video qualities
      print('\x1B[36mAll video qualities\x1B[0m:');
      var videoStreams = manifest.videoOnly;
      for (var i = 0; i < videoStreams.length; i++) {
        var stream = videoStreams[i];
        print(
            '[$i] - ${stream.qualityLabel} - ${stream.size.totalMegaBytes.toStringAsFixed(2)} MB');
      }

      //// client choose video quality
      print('\x1B[33mSelect a video quality from the list\x1B[0m: ');
      int selectedVideoIndex = int.parse(stdin.readLineSync()!);
      VideoOnlyStreamInfo selectedVideoStream =
          videoStreams[selectedVideoIndex];

      //// Show Audio qualities
      print('\x1B[36mAll Audio qualities\x1B[0m:');
      var audioStreams = manifest.audioOnly;
      for (var i = 0; i < audioStreams.length; i++) {
        var stream = audioStreams[i];
        print(
            '[$i] - ${stream.bitrate.kiloBitsPerSecond} kbps - ${stream.size.totalMegaBytes.toStringAsFixed(2)} MB');
      }

      //// choose audio quality from client
      print('\x1B[33mSelect a audio quality from the list\x1B[0m: ');
      var selectedAudioIndex = int.parse(stdin.readLineSync()!);
      var selectedAudioStream = audioStreams[selectedAudioIndex];
      stdout.write('\x1B[2J\x1B[0;0H');
      var directory = await createDownloadDirectory('Youtube_Downloads');

      //// download video stream
      var videoFile = File('$directory/$safeTitle _video.mp4');
      var videoFileStream = videoFile.openWrite();
      var videoTotalSize = selectedVideoStream.size.totalBytes;
      var videoDownloadedBytes = 0;

      var videoStream = yt.videos.streamsClient.get(selectedVideoStream);
      await for (final chunk in videoStream) {
        videoFileStream.add(chunk);
        videoDownloadedBytes += chunk.length;
        var progress = (videoDownloadedBytes / videoTotalSize) * 100;
        stdout.write(
            '\r\x1B[33mVideo downloading:\x1B[0m ${progress.toStringAsFixed(2)}%');
      }

      await videoFileStream.flush();
      await videoFileStream.close();
      print('\n\x1B[32mDownload completed\x1B[0m\n');

      //// create audio file path
      var audioFile = File("$directory/$safeTitle _audio.mp3");
      var audioFileStream = audioFile.openWrite();
      var audioTotalSize = selectedAudioStream.size.totalBytes;
      var audioDownloadedBytes = 0;

      var audioStream = yt.videos.streamsClient.get(selectedAudioStream);
      await for (final chunk in audioStream) {
        audioFileStream.add(chunk);
        audioDownloadedBytes += chunk.length;
        var progress = (audioDownloadedBytes / audioTotalSize) * 100;
        stdout.write(
          '\r\x1B[33maudio downloading:\x1B[0m ${progress.toStringAsFixed(2)}%',
        );
      }

      await audioFileStream.flush();
      await audioFileStream.close();
      print('\n\x1B[32mDownload completed\x1B[0m\n');

      //// merge the audio and video files
      await mergeVideoAndAudio('$directory/$safeTitle _video.mp4',
          '$directory/$safeTitle _audio.mp3', '$directory/$safeTitle.mp4');

      //// delete temporary files
      var f1 = File('$directory/$safeTitle _video.mp4');
      var f2 = File('$directory/$safeTitle _audio.mp3');
      if (await fileExists(f1.path) && await fileExists(f2.path) == true) {
        f1.delete();
        f2.delete();
      }

      print(
          '\x1B[36mfinal output:\x1B[0m \x1B[35m$safeTitle _final.mp4\x1B[0m');

      //// Close YoutubeExplode
      yt.close();

      print(
        '\n\x1B[36mTelegram Support :\x1B[0m \x1B[35mhttps://t.me/Hasan_css\x1B[0m\n',
      );

      print('\x1B[33mpress enter to close the program\x1B[0m');
      stdin.readLineSync();
    } catch (e) {
      print('error $e');
    }
  }
}
