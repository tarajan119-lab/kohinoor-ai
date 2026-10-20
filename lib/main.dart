import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const KohinoorApp());
}

class KohinoorApp extends StatelessWidget {
  const KohinoorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kohinoor Voice Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VoiceAssistantHome(),
    );
  }
}

class VoiceAssistantHome extends StatefulWidget {
  const VoiceAssistantHome({Key? key}) : super(key: key);

  @override
  _VoiceAssistantHomeState createState() => _VoiceAssistantHomeState();
}

class _VoiceAssistantHomeState extends State<VoiceAssistantHome> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking...';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            _processCommand(_text);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _processCommand(String command) async {
    String cmd = command.toLowerCase();
    if (cmd.contains('open youtube')) {
      Uri url = Uri.parse('https://www.youtube.com');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } else if (cmd.contains('open google')) {
      Uri url = Uri.parse('https://www.google.com');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kohinoor Voice Assistant'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            _text,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }
}
