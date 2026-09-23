import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:store/boxes/boxes.dart';
import 'package:store/models/notes_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hive Database")),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            data[index].title.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              delete(data[index]);
                            },
                            child: const Icon(Icons.delete, color: Colors.red),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              _editDialog(
                                data[index],
                                data[index].title.toString(),
                                data[index].description.toString(),
                              );
                            },
                            child: const Icon(Icons.edit, color: Colors.green),
                          ),
                        ],
                      ),
                      Text(
                        data[index].description.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Notes'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final data = NotesModel(
                  title: titleController.text,
                  description: descriptionController.text,
                );

                final box = Boxes.getData();
                await box.add(data);

                titleController.clear();
                descriptionController.clear();

                if (mounted) Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialog(
    NotesModel notesModel,
    String title,
    String description,
  ) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Notes'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                notesModel.title = titleController.text;
                notesModel.description = descriptionController.text;

                await notesModel.save();

                titleController.clear();
                descriptionController.clear();

                if (mounted) Navigator.pop(context);
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }
}
