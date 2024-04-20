import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileUI extends StatefulWidget {
  final User? user;
  final VoidCallback refresh;
  const EditProfileUI({Key? key, required this.user, required this.refresh})
      : super(key: key);

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  final _userController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    _userController.dispose();
    super.dispose();
  }

  void selectImage() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    final bytes = await pickedImage.readAsBytes();
    setState(() {
      _image = bytes;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundImage: _image != null
                  ? MemoryImage(_image!)
                  : widget.user?.photoURL != null
                      ? NetworkImage(widget.user!.photoURL!)
                      : AssetImage('assets/default_profile_image.png') as ImageProvider,
            ),
            ElevatedButton(
              onPressed: selectImage,
              child: Text('Choose Profile Picture'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _userController,
              decoration: InputDecoration(
                hintText: 'Enter Name',
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_userController.text.isNotEmpty) {
                  // Update username if changed
                  if (_userController.text != widget.user?.displayName) {
                    await widget.user?.updateDisplayName(_userController.text);
                  }
                  // Update profile picture if changed
                  if (_image != null) {
                    final storageRef = FirebaseStorage.instance
                        .ref()
                        .child('profile_pictures')
                        .child('${widget.user?.uid}.jpg');
                    await storageRef.putData(_image!);
                    final String downloadURL =
                        await storageRef.getDownloadURL();
                    await widget.user?.updatePhotoURL(downloadURL);
                  }
                  // Refresh UI
                  widget.refresh();
                  // Close the edit profile screen
                  Navigator.pop(context);
                }
              },
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
