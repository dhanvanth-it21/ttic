import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bottom_navigation_bar.dart';
import 'bottom_navigation_handler.dart';
import 'image_processing.dart';
// import 'package:image_cropper/image_cropper.dart';

class SearchPage extends StatefulWidget {
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  double _notepadHeight = 200.0;
  int _currentIndex = 1;
  TextEditingController _textEditingController = TextEditingController();
  String _extractedText = '';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              _copyToClipboard(_textEditingController.text);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetImageContent,
          ),
        ],
      ),
      body: Center(
        child: _buildContent(),
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

  Widget _buildContent() {
    if (ImageProcessing.selectedImage == null) {
      return Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ImageProcessing.takePhoto(updateExtractedText);
                    setState(() {
                      _extractedText = '';
                    });
                  },
                  child: Text('Take Photo'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ImageProcessing.getPhoto(updateExtractedText);
                    setState(() {
                      _extractedText = '';
                    });
                  },
                  child: Text('Get Photo from Device'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: [
              Container(
                height: 3.0, // Set the desired height for the divider
                width: double.infinity, // Make the divider span the full width
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Divider(
                        color: Colors.blue,
                        thickness: 5.0,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ), // Add a divider here
              GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _notepadHeight -= details.delta.dy;
                    if (_notepadHeight < 100.0) {
                      _notepadHeight = 100.0;
                    }
                  });
                },
                child: Container(
                  height: _notepadHeight,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Start typing or paste here',
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return ImageProcessing.buildImageContent(
        _textEditingController,
        _resetImageContent,
        _copyToClipboard,
        _extractedText,
      );
    }
  }

  void _resetImageContent() {
    setState(() {
      ImageProcessing.selectedImage = null;
      _extractedText = '';
      _textEditingController.clear();
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  void updateExtractedText(String extractedText) {
    setState(() {
      _extractedText = extractedText;
      _textEditingController.text = extractedText;
    });
  }
}
