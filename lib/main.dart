import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String,HighlightedWord> _highlights ={
    'flutter':HighlightedWord(
      onTap: () => print("flutter"),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 40,
              )
    ),
    'voice' :HighlightedWord(
      onTap: () => print("voice"),
      textStyle: const TextStyle(
        color: Colors.green,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe' :HighlightedWord(
      onTap: () => print("subscribe"),
      textStyle: const TextStyle(
        color: Colors.red,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ),
     'like' :HighlightedWord(
      onTap: () => print("like"),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ),
     'comment' :HighlightedWord(
      onTap: () => print("comment"),
      textStyle: const TextStyle(
        fontSize: 40,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };
  stt.SpeechToText speech = stt.SpeechToText();
  bool islistening = false;
  String text = "Press the button and start speaking";
  double confidence = 1.0;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
                "Confidence: ${(confidence * 100.0).toStringAsFixed(1)}%")),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: islistening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(islistening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: Container(
            child: TextHighlight(
              text: text,
              words: _highlights,
              textStyle: const TextStyle(fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _listen() async{
    if(!islistening){
      bool available=await speech.initialize(
        onStatus: (val)=> print('onStatus : $val'),
        onError: (val)=> print('onError : $val'),
      );
      if(available){
        setState(() =>islistening=true);
        speech.listen(
          onResult: (val)=> setState(() {
                      text=val.recognizedWords;
                      if(val.hasConfidenceRating && val.confidence>0){
                          confidence=val.confidence;
                      }
                    })
        );
                
      }
    }
    else{
      setState(()=> islistening=false);
      speech.stop();
    }
  }
}
