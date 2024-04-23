import 'package:flutter/material.dart';
import 'package:image_edit/screens/edit_image_.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void editScreenNavigate(String image) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditImageScreen(selectedImage: image),
      ));
    }

    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () async {
            XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

            if (file != null) {
              editScreenNavigate(file.path);
            }
          },
          icon: const Icon(Icons.upload_file),
        ),
      ),
    );
  }
}
