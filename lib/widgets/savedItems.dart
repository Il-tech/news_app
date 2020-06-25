import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AiPage extends StatefulWidget {
  @override
  _AiPageState createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  File pickedImage;
  var imageFile;
  List<Rect> rect = new List<Rect>();
  final picker = ImagePicker();

  bool isFaceDetected = false;

  Future pickImage() async {
    final awaitImage = await picker.getImage(source: ImageSource.gallery);

    imageFile = await awaitImage.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    setState(() {
      imageFile = imageFile;
      pickedImage = File(awaitImage.path);
    });
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);

    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

    final List<Face> faces = await faceDetector.processImage(visionImage);
    if (rect.length > 0) {
      rect = new List<Rect>();
    }
    for (Face face in faces) {
      rect.add(face.boundingBox);

      final double rotY =
          face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double rotZ =
          face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
      print('the rotation y is ' + rotY.toStringAsFixed(2));
      print('the rotation z is ' + rotZ.toStringAsFixed(2));
    }

    setState(() {
      isFaceDetected = true;
    });
  }

  Future pickImageCamera() async {
    final awaitImage = await picker.getImage(source: ImageSource.camera);

    imageFile = await awaitImage.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    setState(() {
      imageFile = imageFile;
      pickedImage = File(awaitImage.path);
    });
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    final List<Face> faces = await faceDetector.processImage(visionImage);
    if (rect.length > 0) {
      rect = new List<Rect>();
    }
    for (Face face in faces) {
      rect.add(face.boundingBox);

      final double rotY =
          face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double rotZ =
          face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
      print('the rotation y is ' + rotY.toStringAsFixed(2));
      print('the rotation z is ' + rotZ.toStringAsFixed(2));
    }
    setState(() {
      isFaceDetected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("USE AI"),
          backgroundColor: Colors.indigo,
          leading: Icon(FontAwesomeIcons.brain),
        ),
        body: Container(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 50.0),
              isFaceDetected
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(blurRadius: 20),
                          ],
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Expanded(
                          child: FittedBox(
                            child: SizedBox(
                              width: imageFile.width.toDouble(),
                              height: imageFile.height.toDouble(),
                              child: CustomPaint(
                                painter: FacePainter(
                                    rect: rect, imageFile: imageFile),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(blurRadius: 20),
                            ],
                          ),
                          child: Image.asset(
                            'assets/my_back.png',
                            fit: BoxFit.cover,
                            height: 300, // set your height
                            width: 400, // and width here
                          )),
                    )
            ],
          ),
        )),
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.indigo,
          animatedIcon: AnimatedIcons.menu_home,
          animatedIconTheme: IconThemeData(size: 30),
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          children: [
            SpeedDialChild(
                child: Icon(Icons.image),
                backgroundColor: Color(0xff5c6bc0),
                label: 'Gallery',
                labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
                onTap: () => pickImage()),
            SpeedDialChild(
              child: Icon(Icons.photo_camera),
              backgroundColor: Color(0xff5c6bc0),
              label: 'Camera',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
              onTap: () => pickImageCamera(),
            ),
          ],
        ));
  }
}

class FacePainter extends CustomPainter {
  List<Rect> rect;
  var imageFile;

  FacePainter({@required this.rect, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (Rect rectangle in rect) {
      canvas.drawRect(
        rectangle,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
