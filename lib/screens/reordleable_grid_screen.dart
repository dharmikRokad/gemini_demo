import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_experiments/const_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ReorderableGridScreen extends StatefulWidget {
  const ReorderableGridScreen({super.key});

  @override
  State<ReorderableGridScreen> createState() => _ReorderableGridScreenState();
}

class _ReorderableGridScreenState extends State<ReorderableGridScreen> {
  openGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    reorderableListImages.add(image);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Reorderable Grid'),
      ),
      body: ReorderableDragStartListener(
        index: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ReorderableGridView.builder(
              onReorder: (oldIndex, newIndex) {
                /// For swaping
                // var (a, b) = (images[newIndex], images[oldIndex]);
                // images[newIndex] = b;
                // images[oldIndex] = a;

                /// For reordering
                reorderableListImages.insert(
                    newIndex, reorderableListImages.removeAt(oldIndex));

                setState(() {});
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.66,
              ),
              itemCount: reorderableListImages.length,
              itemBuilder: (context, index) {
                return getImageTile(reorderableListImages[index]);
              }),
          /*child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              childAspectRatio: 0.66,
              mainAxisSpacing: 10,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              return DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    color: Colors.yellow,
                  );
                },
                /*child: LongPressDraggable(
                  feedback: getImageTile(image, 160, 110),
                  childWhenDragging: const SizedBox.shrink(),
                  child: getImageTile(image, 150, 100),
                ),*/
              );
            },
          ),*/
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openGallery,
        tooltip: 'Add Images',
        child: const Icon(Icons.add),
      ),
    );
  }

  getImageTile(dynamic image) => FadeInUp(
        child: AnimatedContainer(
          key: UniqueKey(),
          duration: const Duration(milliseconds: 1000),
          // height: height,
          // width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: image.runtimeType == XFile
                ? DecorationImage(
                    image: FileImage(File((image as XFile).path)),
                    fit: BoxFit.cover,
                  )
                : DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      );
}
