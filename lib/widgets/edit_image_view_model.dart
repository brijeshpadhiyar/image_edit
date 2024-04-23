import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_edit/models/text_info.dart';
import 'package:image_edit/screens/edit_image_.dart';
import 'package:image_edit/utils/utils.dart';
import 'package:image_edit/widgets/default_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController createText = TextEditingController();

  ScreenshotController screenshotController = ScreenshotController();
  int currentIndex = 0;

  List<TextInfo> texts = [];

  saveToGallery() async {
    if (texts.isNotEmpty) {
      await screenshotController.capture().then((Uint8List? image) {
        if (image != null) {
          saveImage(image);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Image saved to gallery",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          );
        }
      }).catchError((e) {
        debugPrint(e);
      });
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now().toIso8601String().replaceAll(".", "-").replaceAll(":", "-");

    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  setCurrentIndex(BuildContext context, int index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Selected for styling",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  alignLeft() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenter() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRight() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLineToText() {
    setState(() {
      if (texts[currentIndex].text.contains("\n")) {
        texts[currentIndex].text = texts[currentIndex].text.replaceAll("\n", " ");
      } else {
        texts[currentIndex].text = texts[currentIndex].text.replaceAll(" ", "\n");
      }
    });
  }

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Deleted",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  addNewText(BuildContext context) {
    setState(() {
      texts.add(
        TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left,
        ),
      );
      Navigator.of(context).pop();
    });
  }

  addNewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add new text"),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.edit),
            filled: true,
            hintText: "Your Text here ...",
          ),
        ),
        actions: <Widget>[
          DefaultButton(
            text: "Back",
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.white,
            textColor: Colors.black,
          ),
          DefaultButton(
            text: "Add Text",
            onPressed: () => addNewText(context),
            color: Colors.red,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
