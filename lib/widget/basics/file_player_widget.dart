import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_ii_example/widget/other/floating_action_button_widget.dart';
import 'package:video_ii_example/widget/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class FilePlayerWidget extends StatefulWidget {
  @override
  _FilePlayerWidgetState createState() => _FilePlayerWidgetState();
}

class _FilePlayerWidgetState extends State<FilePlayerWidget> {
  final File file = File(
      '/data/user/0/com.example.video_example/cache/file_picker/big_buck_bunny_720p_10mb.mp4');
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    if (file.existsSync()) {
      controller = VideoPlayerController.file(file)
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((_) => controller.play());
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            VideoPlayerWidget(controller: controller),
            buildAddButton(),
          ],
        ),
      );

  Widget buildAddButton() => Container(
        padding: EdgeInsets.all(32),
        child: FloatingActionButtonWidget(
          onPressed: () async {
            final file = await pickVideoFile();
            if (file == null) return;

            controller = VideoPlayerController.file(file)
              ..addListener(() => setState(() {}))
              ..setLooping(true)
              ..initialize().then((_) {
                controller.play();
                setState(() {});
              });
          },
        ),
      );

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null) return null;

    return File(result.files.single.path);
  }
}
