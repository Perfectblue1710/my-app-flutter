import 'package:flutter/material.dart';

class SearchResult {
  final String document;
  final double score;

  SearchResult(this.document, this.score);
}

class TFIDFSearchScreen extends StatefulWidget {
  final List<String> regulations;

  const TFIDFSearchScreen({super.key, required this.regulations});

  @override
  State<TFIDFSearchScreen> createState() => _TFIDFSearchScreenState();
}

class _TFIDFSearchScreenState extends State<TFIDFSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<SearchResult> _results = [];

  void _search(String query) {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final results = widget.regulations
        .where((doc) => doc.toLowerCase().contains(query.toLowerCase()))
        .map((doc) => SearchResult(doc, 0.8)) 
        .toList();

    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for documents'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: _search,
              decoration: const InputDecoration(
                hintText: 'Add some words',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text('No results'))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final result = _results[index];
                      return ListTile(
                        title: Text(result.document),
                        subtitle: Text(
                          'Релевантность ${(result.score * 100).toInt()}%',
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
