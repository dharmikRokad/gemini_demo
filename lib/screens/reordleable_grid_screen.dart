import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

List<dynamic> images = [
  'https://t4.ftcdn.net/jpg/02/44/43/69/360_F_244436923_vkMe10KKKiw5bjhZeRDT05moxWcPpdmb.jpg',
  'https://dummyimage.com/hd1080',
  'https://thumbs.dreamstime.com/z/vector-illustration-avatar-dummy-logo-collection-image-icon-stock-isolated-object-set-symbol-web-137160339.jpg',
  'https://dummyimage.com/600x400/000/fff',
  'https://images.unsplash.com/photo-1559116315-702b0b4774ce?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZHVtbXl8ZW58MHx8MHx8fDA%3D',
  'https://plus.unsplash.com/premium_photo-1667480556783-119d25e19d6e?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZHVtbXl8ZW58MHx8MHx8fDA%3D',
];

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
    images.add(image);
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
                images.insert(newIndex, images.removeAt(oldIndex));

                setState(() {});
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.66,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return getImageTile(images[index]);
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
