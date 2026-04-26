import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../constants/colors.dart';

class MicButton extends StatefulWidget {
  final Function(String) onTranscript;
  final bool disabled;

  const MicButton({
    super.key,
    required this.onTranscript,
    this.disabled = false,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          onResult: (val) {
            if (val.finalResult) {
              widget.onTranscript(val.recognizedWords);
              setState(() => _isListening = false);
            }
          },
          localeId: 'pt_BR',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.disabled ? null : _listen,
        child: ScaleTransition(
          scale: _isListening 
              ? Tween(begin: 1.0, end: 1.2).animate(
                  CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
                )
              : const AlwaysStoppedAnimation(1.0),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isListening ? AppColors.error : AppColors.brightBlue,
              boxShadow: [
                BoxShadow(
                  color: (_isListening ? AppColors.error : AppColors.brightBlue).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              _isListening ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }
}
