import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? xFile = await imagePicker.pickImage(source: source);
  if (xFile != null) {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImagesDir = referenceRoot.child('images');
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceUploadImage = referenceImagesDir.child(uniqueName);
    try {
      await referenceUploadImage.putFile(File(xFile.path));
      String imageUrl = await referenceUploadImage.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return "";
    }
  }
  return "";
}
