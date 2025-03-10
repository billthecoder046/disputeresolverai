import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VoiceMessageRecorder extends StatefulWidget {
  final Function(File) onSend;

  VoiceMessageRecorder({required this.onSend});

  @override
  _VoiceMessageRecorderState createState() => _VoiceMessageRecorderState();
}

class _VoiceMessageRecorderState extends State<VoiceMessageRecorder> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  String? _audioPath;

  Future<void> _startRecording() async {
    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/voice_message.wav';
      await _audioRecorder.start(const RecordConfig(), path: path);
      setState(() {
        _isRecording = true;
        _audioPath = path;
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _playRecording() async {
    if (_audioPath != null) {
      await _audioPlayer.play(UrlSource(_audioPath!));
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            ),
            if (_audioPath != null)
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: _playRecording,
              ),
            if (_audioPath != null)
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_audioPath != null) {
                    widget.onSend(File(_audioPath!));
                  }
                },
              ),
          ],
        ),
        if (_isRecording) Text('Recording...'),
      ],
    );
  }
}