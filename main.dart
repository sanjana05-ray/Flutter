import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: NotesHomePage(
        toggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const NotesHomePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final List<String> notes = [];
  final TextEditingController noteController = TextEditingController();

  void addNote() {
    String text = noteController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        notes.add(text);
        noteController.clear();
      });
    } else {
      _showAlert("Note is empty", "Please write something before adding.");
    }
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void editNote(int index) {
    noteController.text = notes[index];
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Note"),
            content: TextField(
              controller: noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Edit your note",
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  noteController.clear();
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text("Update"),
                onPressed: () {
                  setState(() {
                    notes[index] = noteController.text.trim();
                    noteController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 My Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Multiline input
            TextField(
              controller: noteController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Write your note...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: addNote,
              icon: const Icon(Icons.add),
              label: const Text('Add Note'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  notes.isEmpty
                      ? const Center(child: Text('No notes yet. Start typing!'))
                      : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(notes[index]),
                              leading: CircleAvatar(
                                backgroundColor: Colors.deepPurple,
                                child: Text('${index + 1}'),
                              ),
                              onTap: () => editNote(index),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteNote(index),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
