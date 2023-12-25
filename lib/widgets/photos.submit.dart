import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SubmitPhotosPage extends StatefulWidget {
  final String currentPickupId;

  const SubmitPhotosPage({Key? key, required this.currentPickupId})
      : super(key: key);

  @override
  _SubmitPhotosPageState createState() => _SubmitPhotosPageState();
}

class _SubmitPhotosPageState extends State<SubmitPhotosPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImages = [];

  Future<void> _getMultipleImages() async {
    List<XFile>? pickedFiles = await _picker.pickMultiImage(
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 80,
    );

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(pickedFiles);
      });
    }
  }

  Future<void> _uploadImages() async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    for (var imageFile in _pickedImages) {
      Reference ref = storage.ref().child('pickup_images/${DateTime.now()}');
      UploadTask uploadTask = ref.putFile(File(imageFile.path));

      try {
        TaskSnapshot taskSnapshot = await uploadTask;
        if (taskSnapshot.state == TaskState.success) {
          String downloadURL = await taskSnapshot.ref.getDownloadURL();
          // Link the downloadURL with the current pickup document in Firestore
          await FirebaseFirestore.instance
              .collection('pickups')
              .doc(widget.currentPickupId)
              .update({
            'job_status': 'Images Recieved',
            'images': FieldValue.arrayUnion([downloadURL])
          });
        }
      } catch (e) {
        // Handle upload errors here
        print('Error uploading image: $e');
      }
    }

    Navigator.pop(context); // Go back to the previous page after upload
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Photos'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _getMultipleImages();
            },
            child: Text('Choose from Gallery'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _pickedImages.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.file(File(_pickedImages[index].path));
              },
            ),
          ),
          ElevatedButton(
            onPressed: _pickedImages.isNotEmpty ? _uploadImages : null,
            child: Text('Upload Photos'),
          ),
        ],
      ),
    );
  }
}
