import 'package:flutter/material.dart';
import 'package:flutter_sqllite_apptask_1/data/datasources/local_datasource.dart';
import 'package:flutter_sqllite_apptask_1/data/models/notes.dart';
import 'package:flutter_sqllite_apptask_1/pages/add_page.dart';
import 'package:flutter_sqllite_apptask_1/pages/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];

  bool isLoading = false;

  Future<void> getNotes() async {
    setState(() {
      isLoading = true;
    });
    notes = await LocalDatasource().getNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Noted App Sesi 12',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? const Center(child: Text('No Notes'))
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.8),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DetailPage(
                            note: notes[index],
                          );
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notes[index].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    notes[index].content,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: 10,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
