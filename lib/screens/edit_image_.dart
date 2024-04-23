import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_edit/widgets/edit_image_view_model.dart';
import 'package:image_edit/widgets/image_text.dart';
import 'package:screenshot/screenshot.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({super.key, required this.selectedImage});
  final String selectedImage;

  @override
  State<EditImageScreen> createState() => EditImageScreenState();
}

class EditImageScreenState extends EditImageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: _appBar,
      ),
      body: SafeArea(
          child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              _selectedImage,
              for (int i = 0; i < texts.length; i++)
                Positioned(
                  left: texts[i].left,
                  top: texts[i].top,
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        currentIndex = i;
                      });
                      removeText(context);
                    },
                    onTap: () => setCurrentIndex(context, i),
                    child: Draggable(
                      feedback: ImageText(textInfo: texts[i]),
                      child: ImageText(textInfo: texts[i]),
                      onDragEnd: (details) {
                        final renderBox = context.findRenderObject() as RenderBox;
                        Offset offset = renderBox.globalToLocal(details.offset);
                        setState(() {
                          texts[i].top = offset.dy - 96;
                          texts[i].left = offset.dx;
                        });
                      },
                    ),
                  ),
                ),
              createText.text.isNotEmpty
                  ? Positioned(
                      left: 0,
                      bottom: 0,
                      child: Text(
                        createText.text,
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.3)),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      )),
      floatingActionButton: _addNewTextFab,
    );
  }

  Widget get _appBar => AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              IconButton(
                onPressed: () => saveToGallery(),
                icon: const Icon(Icons.save, color: Colors.black),
                tooltip: "Save Image",
              ),
              IconButton(
                onPressed: () => increaseFontSize(),
                icon: const Icon(Icons.add, color: Colors.black),
                tooltip: "Increase font size",
              ),
              IconButton(
                onPressed: () => decreaseFontSize(),
                icon: const Icon(Icons.remove, color: Colors.black),
                tooltip: "Decrease font size",
              ),
              IconButton(
                onPressed: () => alignLeft(),
                icon: const Icon(Icons.format_align_left, color: Colors.black),
                tooltip: "Align Left",
              ),
              IconButton(
                onPressed: () => alignCenter(),
                icon: const Icon(Icons.format_align_center, color: Colors.black),
                tooltip: "Align Center",
              ),
              IconButton(
                onPressed: () => alignRight(),
                icon: const Icon(Icons.format_align_right, color: Colors.black),
                tooltip: "Align Right",
              ),
              IconButton(
                onPressed: () => boldText(),
                icon: const Icon(Icons.format_bold, color: Colors.black),
                tooltip: "Bold",
              ),
              IconButton(
                onPressed: () => italicText(),
                icon: const Icon(Icons.format_italic, color: Colors.black),
                tooltip: "Italic",
              ),
              IconButton(
                onPressed: () => addLineToText(),
                icon: const Icon(Icons.space_bar, color: Colors.black),
                tooltip: "Add New line",
              ),
              Tooltip(
                message: "Yellow",
                child: GestureDetector(
                  onTap: () {},
                  child: const CircleAvatar(
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const SizedBox(width: 5),
              Tooltip(
                message: "white",
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.white),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: "red",
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.red),
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: "black",
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.black),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: "blue",
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.blue),
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: "Green",
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.green),
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      );

  Widget get _selectedImage => Center(
        child: Image.file(
          File(widget.selectedImage),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
      );

  Widget get _addNewTextFab => FloatingActionButton(
        onPressed: () => addNewDialog(context),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        tooltip: "Add New Text",
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      );
}
