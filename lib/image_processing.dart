import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ImageProcessing {
  static File? selectedImage;

  static Future<void> takePhoto(Function(String) onUpdateExtractedText) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final croppedFile =
          await cropImage(onUpdateExtractedText, File(image.path));
      if (croppedFile != null) {
        selectedImage = croppedFile;
        await _extractTextFromImage(onUpdateExtractedText);
      }
    }
  }

  static Future<void> getPhoto(Function(String) onUpdateExtractedText) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final croppedFile =
          await cropImage(onUpdateExtractedText, File(image.path));
      if (croppedFile != null) {
        selectedImage = croppedFile;
        await _extractTextFromImage(onUpdateExtractedText);
      }
    }
  }

  static Future<void> _extractTextFromImage(
      Function(String) onUpdateExtractedText) async {
    final inputImage = InputImage.fromFile(selectedImage!);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognisedText =
        await textRecognizer.processImage(inputImage);

    String extractedText = '';
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          extractedText += '${element.text} ';
        }
        extractedText += '\n';
      }
    }

    extractedText = extractedText.trim();

    onUpdateExtractedText(extractedText);

    textRecognizer.close();
  }

  static Future<File?> cropImage(
      Function(String) onUpdateExtractedText, File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }

    return null;
  }

  static Widget buildImageContent(
    TextEditingController textEditingController,
    VoidCallback resetImageContent,
    Function(String) copyToClipboard,
    String extractedText,
  ) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            child: Image.file(
              selectedImage!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Extracted Text:'),
                SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(25.0),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
