import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherDemo extends StatefulWidget {
  @override
  _LauncherDemoState createState() => _LauncherDemoState();
}

class _LauncherDemoState extends State<LauncherDemo> {
  File image;
 // PickedFile image2;
  launchApp(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var message = '';
  getLatLong() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      message =
          'Location Position is ${position.latitude}' '${position.longitude}';
      //Call Google Map API
    });
  }

//  camera() async {
//    ImagePicker imagePicker = new ImagePicker();
//    PickedFile image2 =  await imagePicker.getImage(source: ImageSource.camera);   //ImageSource.gallery
//
//   // File image = await ImagePicker.pickImage(source: ImageSource.camera);  //cross on pickImage bbecoz of older version
//   setState(() {
//     this.image = new File(image2.path);
//     //this.image2 = image2;
//   });
//
//  }
   String msg = '';
  _speakNow() async{
    SpeechToText speechToText = SpeechToText();
     bool micIsAvailable = await speechToText.initialize(
        onStatus: (String status){
          setState(() {
            msg = 'Mic is ready';
          });
        } ,
        onError: (SpeechRecognitionError error){
          setState(() {
            msg = 'Some error occurs';
          });
        }
    );
     if(micIsAvailable){
       speechToText.listen(onResult: (SpeechRecognitionResult result){
         setState(() {
           msg = result.recognizedWords;
         });
       });
     }
     else{
       setState(() {
         msg = 'User denied mic usage';
       });
     }
     Timer(Duration(seconds: 30), (){
       speechToText.stop();
     });

  }
  FlutterTts tts = new FlutterTts();
  _readIt() async{
    await tts.setPitch(1);  //0 - 5
    await tts.speak(msg??'Nothing to Speak');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Launcher Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Speak Now'),
              onPressed: (){
                _readIt();
              },
            ),
            RaisedButton(
              child: Text('Mic'),
              onPressed: (){
                _speakNow();
              },
            ),
            Text('Result is $msg', style: TextStyle(fontSize: 20),),
            RaisedButton(
              child: Text('Phone: +1 555 010 999'),
              onPressed: (){
                //var phone = 'Phone : 011-26742575, 26742676, 26741557';
                var phone =
                    "tel:+1 555 010 999"; //compolsary to write tel: i guess
                launchApp(phone);
              },
            ),
            RaisedButton(
              child: Text('SMS: 5550101234'),
              onPressed: () {
                //var phone = 'Phone : 011-26742575, 26742676, 26741557';
                var sms = "sms:5550101234";
                launchApp(sms);
              },
            ),
            RaisedButton(
              child: Text('Mail'),
              onPressed: () {
                var mail = "mailto:jnunews@mail.jnu.ac.in";
                launchApp(mail);
              },
            ),
            RaisedButton(
              child: Text('GPS'),
              onPressed: () {
                getLatLong();
              },
            ),
            Text(
              'GPS $message',
              style: TextStyle(fontSize: 30),
            ),
            RaisedButton(
              child: Text('Camera'),
              onPressed: () {
              //  camera();
              },
            ),
            image == null
                ? Container(
                    child: Text(
                      'No  Image',
                      style: TextStyle(fontSize: 30),
                    ),
                  )
                : Image.file(
                    image,
                    height: 300,
                    width: 300,
                  )
          ],
        ),
      ),
    );
  }
}
