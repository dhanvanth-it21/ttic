import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ttic/bottom_navigation_handler.dart';
import 'bottom_navigation_bar.dart';
import 'package:share_plus/share_plus.dart';

class Note {
  String title;
  String text;
  DateTime createdAt;

  Note({
    required this.title,
    required this.text,
    required this.createdAt,
  });
}

class FavoritesPage extends StatefulWidget {
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int _currentIndex = 2;
  List<Note> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Text('Created at: ${notes[index].createdAt}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotePadScreen(
                    note: notes[index],
                    onDelete: () {
                      _deleteNote(index);
                    },
                  ),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteNote(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(notes[index].text);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(
                onNoteAdded: (note) {
                  setState(() {
                    notes.add(note);
                  });
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          handleItemTapped(context, index);
        },
      ),
    );
  }

  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  notes.removeAt(index);
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class NotePadScreen extends StatefulWidget {
  final Note note;
  final Function onDelete;

  NotePadScreen({required this.note, required this.onDelete});

  @override
  _NotePadScreenState createState() => _NotePadScreenState();
}

class _NotePadScreenState extends State<NotePadScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (_titleController.text.isEmpty) {
      _titleController.text = widget.note.title;
    }
    if (_textController.text.isEmpty) {
      _textController.text = widget.note.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _saveChanges();
            },
          ),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              _copyToClipboard();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Text',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
            ),
            // SizedBox(height: 16.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       child: Text('Copy'),
            //       onPressed: () {
            //         _copyToClipboard();
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    widget.note.title = _titleController.text;
    widget.note.text = _textController.text;

    // Perform any other necessary operations to save the changes

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Changes saved')),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.note.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text copied to clipboard')),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  final Function(Note) onNoteAdded;

  AddNoteScreen({required this.onNoteAdded});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Text',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                String title = _titleController.text.trim();
                String text = _textController.text.trim();
                DateTime now = DateTime.now();

                if (title.isEmpty) {
                  int newLineIndex = text.indexOf('\n');
                  title = (newLineIndex != -1)
                      ? text.substring(0, newLineIndex)
                      : text;
                }

                Note newNote = Note(
                  title: title,
                  text: text,
                  createdAt: now,
                );

                widget.onNoteAdded(newNote);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
